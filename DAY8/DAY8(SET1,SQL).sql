


CREATE DATABASE IF NOT EXISTS BankTransferDB;
USE BankTransferDB;

-- 1. CREATE TABLES


CREATE TABLE IF NOT EXISTS Account (
    AccountID INT PRIMARY KEY,
    Balance DECIMAL(15,2) NOT NULL,
    Status VARCHAR(20) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Transactions (
    TransactionID INT AUTO_INCREMENT PRIMARY KEY,
    AccountID INT NOT NULL,
    Transaction_Type VARCHAR(30),
    Amount DECIMAL(15,2),
    TransactionDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    RelatedAccountID INT,
    Direction VARCHAR(10)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS FeeLedger (
    FeeID INT AUTO_INCREMENT PRIMARY KEY,
    AccountID INT,
    FeeAmount DECIMAL(15,2),
    FeeDate DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 2. INSERT SAMPLE DATA


INSERT IGNORE INTO Account VALUES
(1, 10000, 'Active'),
(2, 5000, 'Active'),
(3, 2000, 'Frozen');


-- TASK 1: SUCCESSFUL FUND TRANSFER


DELIMITER //

CREATE PROCEDURE FundTransfer(
    IN p_FromAccount INT,
    IN p_ToAccount INT,
    IN p_Amount DECIMAL(15,2)
)
BEGIN

    DECLARE v_Balance DECIMAL(15,2);
    DECLARE v_FromStatus VARCHAR(20);
    DECLARE v_ToStatus VARCHAR(20);
    DECLARE v_Count INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Transfer failed. Transaction rolled back.' AS Result;
    END;

    START TRANSACTION;

    SELECT COUNT(*) INTO v_Count
    FROM Account
    WHERE AccountID IN (p_FromAccount, p_ToAccount);

    IF v_Count <> 2 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Account does not exist';
    END IF;

    SELECT Balance, Status
    INTO v_Balance, v_FromStatus
    FROM Account
    WHERE AccountID = p_FromAccount
    FOR UPDATE;

    SELECT Status INTO v_ToStatus
    FROM Account
    WHERE AccountID = p_ToAccount
    FOR UPDATE;

    IF p_FromAccount = p_ToAccount THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Same account transfer not allowed';
    END IF;

    IF v_FromStatus <> 'Active' OR v_ToStatus <> 'Active' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Account is not active';
    END IF;

    IF p_Amount <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid transfer amount';
    END IF;

    IF v_Balance < p_Amount THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient balance';
    END IF;

    UPDATE Account
    SET Balance = Balance - p_Amount
    WHERE AccountID = p_FromAccount;

    UPDATE Account
    SET Balance = Balance + p_Amount
    WHERE AccountID = p_ToAccount;

    INSERT INTO Transactions
    (AccountID, Transaction_Type, Amount,
     RelatedAccountID, Direction)
    VALUES
    (p_FromAccount, 'Transfer', p_Amount,
     p_ToAccount, 'DEBIT'),
    (p_ToAccount, 'Transfer', p_Amount,
     p_FromAccount, 'CREDIT');

    COMMIT;

    SELECT 'Transfer successful' AS Result;

END //

DELIMITER ;

CALL FundTransfer(1, 2, 1000);


-- TASK 2: DELIBERATE FAILURE AND ROLLBACK


DELIMITER //

CREATE PROCEDURE TestRollback()
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Deliberate failure. Rollback successful.' AS Result;
    END;

    START TRANSACTION;

    UPDATE Account
    SET Balance = Balance - 500
    WHERE AccountID = 1;

    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Simulated failure after debit';

    COMMIT;

END //

DELIMITER ;

SELECT Balance AS BeforeRollback
FROM Account WHERE AccountID = 1;

CALL TestRollback();

SELECT Balance AS AfterRollback
FROM Account WHERE AccountID = 1;


-- TASK 3: SAVEPOINT
-- ROLLBACK ONLY FEE POSTING


DELIMITER //

CREATE PROCEDURE TransferWithSavepoint()
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Main transaction failed' AS Result;
    END;

    START TRANSACTION;

    UPDATE Account
    SET Balance = Balance - 1000
    WHERE AccountID = 1;

    UPDATE Account
    SET Balance = Balance + 1000
    WHERE AccountID = 2;

    INSERT INTO Transactions
    (AccountID, Transaction_Type, Amount,
     RelatedAccountID, Direction)
    VALUES
    (1, 'Transfer', 1000, 2, 'DEBIT'),
    (2, 'Transfer', 1000, 1, 'CREDIT');

    SAVEPOINT FeePosting;

    BEGIN

        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK TO SAVEPOINT FeePosting;
            SELECT 'Fee posting rolled back' AS Result;
        END;

        INSERT INTO FeeLedger(AccountID, FeeAmount)
        VALUES (1, 50);

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Simulated fee posting failure';

    END;

    COMMIT;

    SELECT 'Transfer retained successfully' AS Result;

END //

DELIMITER ;

CALL TransferWithSavepoint();


-- TASK 4: MONTHLY STATEMENT
-- CTE + ROW_NUMBER + LAG


SET @OpeningBalance = 10000.00;

WITH MonthlyTransactions AS
(
    SELECT
        TransactionID,
        AccountID,
        Transaction_Type,
        Amount,
        TransactionDate,

        CASE
            WHEN Direction = 'CREDIT' THEN Amount
            WHEN Direction = 'DEBIT' THEN -Amount
            WHEN Transaction_Type = 'Deposit' THEN Amount
            WHEN Transaction_Type = 'Withdrawal' THEN -Amount
            ELSE 0
        END AS SignedAmount

    FROM Transactions

    WHERE AccountID = 1
      AND TransactionDate >= '2026-11-01'
      AND TransactionDate < '2026-12-01'
),

RunningStatement AS
(
    SELECT
        *,
        ROW_NUMBER() OVER (
            ORDER BY TransactionDate, TransactionID
        ) AS RowNumber,

        @OpeningBalance +
        SUM(SignedAmount) OVER (
            ORDER BY TransactionDate, TransactionID
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) AS RunningBalance

    FROM MonthlyTransactions
)

SELECT
    TransactionID,
    AccountID,
    Transaction_Type,
    Amount,
    TransactionDate,
    RowNumber,

    LAG(RunningBalance, 1, @OpeningBalance)
    OVER (
        ORDER BY TransactionDate, TransactionID
    ) AS PreviousBalance,

    RunningBalance AS CurrentBalance

FROM RunningStatement
ORDER BY TransactionDate, TransactionID;


-- TASK 5: ISOLATION LEVELS


-- READ COMMITTED

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

START TRANSACTION;

SELECT Balance
FROM Account
WHERE AccountID = 1;

COMMIT;

-- SNAPSHOT-LIKE CONSISTENT READ
-- MySQL InnoDB REPEATABLE READ

SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

START TRANSACTION WITH CONSISTENT SNAPSHOT;

SELECT Balance
FROM Account
WHERE AccountID = 1;

COMMIT;


-- FINAL OUTPUT


SELECT * FROM Account;

SELECT * FROM Transactions;

SELECT * FROM FeeLedger;
