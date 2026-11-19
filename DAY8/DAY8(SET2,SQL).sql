


CREATE DATABASE IF NOT EXISTS AirlineBookingDB;
USE AirlineBookingDB;


-- 1. CREATE TABLES


CREATE TABLE IF NOT EXISTS Flights (
    FlightID INT PRIMARY KEY,
    FlightName VARCHAR(100),
    Source VARCHAR(50),
    Destination VARCHAR(50)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Seats (
    SeatID INT AUTO_INCREMENT PRIMARY KEY,
    FlightID INT NOT NULL,
    SeatNumber VARCHAR(10) NOT NULL,
    Status VARCHAR(20) DEFAULT 'Available',
    UNIQUE (FlightID, SeatNumber),
    FOREIGN KEY (FlightID) REFERENCES Flights(FlightID)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Bookings (
    BookingID INT AUTO_INCREMENT PRIMARY KEY,
    PassengerName VARCHAR(100) NOT NULL,
    FlightID INT NOT NULL,
    SeatNumber VARCHAR(10) NOT NULL,
    Fare DECIMAL(10,2) NOT NULL,
    BookingDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (FlightID, SeatNumber),
    FOREIGN KEY (FlightID) REFERENCES Flights(FlightID)
) ENGINE=InnoDB;


-- 2. INSERT SAMPLE DATA


INSERT IGNORE INTO Flights VALUES
(101, 'Indigo 6E-101', 'Chennai', 'Delhi'),
(102, 'Air India AI-202', 'Mumbai', 'Bangalore');

INSERT IGNORE INTO Seats
(FlightID, SeatNumber, Status)
VALUES
(101, 'A1', 'Available'),
(101, 'A2', 'Available'),
(101, 'A3', 'Available'),
(101, 'A4', 'Available'),
(102, 'B1', 'Available'),
(102, 'B2', 'Available');


-- TASK 1: BOOKING TRANSACTION
-- CHECK SEAT, INSERT BOOKING, UPDATE STATUS


DELIMITER //

CREATE PROCEDURE BookSeat(
    IN p_PassengerName VARCHAR(100),
    IN p_FlightID INT,
    IN p_SeatNumber VARCHAR(10),
    IN p_Fare DECIMAL(10,2)
)
BEGIN

    DECLARE v_SeatID INT;
    DECLARE v_Status VARCHAR(20);
    DECLARE v_Found INT DEFAULT 1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_Found = 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Lock and check seat
    SELECT SeatID, Status
    INTO v_SeatID, v_Status
    FROM Seats
    WHERE FlightID = p_FlightID
      AND SeatNumber = p_SeatNumber
    FOR UPDATE;

    IF v_Found = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Seat does not exist';
    END IF;

    IF v_Status <> 'Available' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Seat already booked';
    END IF;

    IF p_Fare <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid fare';
    END IF;

    -- Insert booking
    INSERT INTO Bookings
    (PassengerName, FlightID, SeatNumber, Fare)
    VALUES
    (p_PassengerName, p_FlightID, p_SeatNumber, p_Fare);

    -- Update seat status
    UPDATE Seats
    SET Status = 'Booked'
    WHERE SeatID = v_SeatID;

    COMMIT;

    SELECT 'Booking successful' AS Result;

END //

DELIMITER ;

-- Test booking
CALL BookSeat('Abdullah', 101, 'A1', 5000);



SELECT
    FlightID,
    PassengerName,
    Fare,

    RANK() OVER (
        PARTITION BY FlightID
        ORDER BY Fare DESC
    ) AS FareRank,

    DENSE_RANK() OVER (
        PARTITION BY FlightID
        ORDER BY Fare DESC
    ) AS DenseFareRank

FROM Bookings
ORDER BY FlightID, Fare DESC;

-
-- TASK 4: CTE AND RUNNING REVENUE


WITH FlightRevenue AS
(
    SELECT
        FlightID,
        BookingID,
        PassengerName,
        Fare,
        BookingDate,

        RANK() OVER (
            PARTITION BY FlightID
            ORDER BY Fare DESC
        ) AS FareRank,

        DENSE_RANK() OVER (
            PARTITION BY FlightID
            ORDER BY Fare DESC
        ) AS DenseFareRank,

        SUM(Fare) OVER (
            PARTITION BY FlightID
            ORDER BY BookingDate, BookingID
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) AS RunningRevenue

    FROM Bookings
)

SELECT
    FlightID,
    BookingID,
    PassengerName,
    Fare,
    BookingDate,
    FareRank,
    DenseFareRank,
    RunningRevenue

FROM FlightRevenue
ORDER BY FlightID, BookingDate, BookingID;




SELECT * FROM Flights;

SELECT * FROM Seats;

SELECT * FROM Bookings;

-- Total revenue per flight
SELECT
    FlightID,
    SUM(Fare) AS TotalRevenue
FROM Bookings
GROUP BY FlightID;

