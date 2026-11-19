
use("BankTransferDB");


// 1. CREATE COLLECTIONS


db.createCollection("accounts");
db.createCollection("transactions");


// 2. INSERT SAMPLE ACCOUNTS


db.accounts.insertMany([
    {
        _id: 1,
        balance: 10000,
        status: "Active"
    },
    {
        _id: 2,
        balance: 5000,
        status: "Active"
    },
    {
        _id: 3,
        balance: 2000,
        status: "Frozen"
    }
]);


// 3. MULTI-DOCUMENT TRANSACTION


const session = db.getMongo().startSession();

const bankDB = session.getDatabase("BankSphereDB");

const accounts = bankDB.accounts;
const transactions = bankDB.transactions;

try {

    session.startTransaction();

    const fromAccount = accounts.findOne({ _id: 1 });
    const toAccount = accounts.findOne({ _id: 2 });

    const amount = 1000;

    // Validate accounts
    if (!fromAccount || !toAccount) {
        throw new Error("Account does not exist");
    }

    if (
        fromAccount.status !== "Active" ||
        toAccount.status !== "Active"
    ) {
        throw new Error("Account is not active");
    }

    if (fromAccount.balance < amount) {
        throw new Error("Insufficient balance");
    }

    // Debit sender
    const debit = accounts.updateOne(
        {
            _id: 1,
            balance: { $gte: amount },
            status: "Active"
        },
        {
            $inc: { balance: -amount }
        }
    );

    if (debit.matchedCount !== 1) {
        throw new Error("Debit failed");
    }

    // Credit receiver
    const credit = accounts.updateOne(
        {
            _id: 2,
            status: "Active"
        },
        {
            $inc: { balance: amount }
        }
    );

    if (credit.matchedCount !== 1) {
        throw new Error("Credit failed");
    }

    // Insert transaction records
    transactions.insertMany([
        {
            fromAccount: 1,
            toAccount: 2,
            amount: amount,
            type: "DEBIT",
            date: new Date()
        },
        {
            fromAccount: 1,
            toAccount: 2,
            amount: amount,
            type: "CREDIT",
            date: new Date()
        }
    ]);

    // Commit transaction
    session.commitTransaction();

    print("Fund transfer successful");

} catch (error) {

    session.abortTransaction();

    print("Transaction failed: " + error.message);
    print("All changes rolled back");

} finally {

    session.endSession();

}


// 4. DISPLAY FINAL ACCOUNTS


print("FINAL ACCOUNT BALANCES");

db.accounts.find().forEach(printjson);


// 5. DISPLAY TRANSACTION HISTORY


print("TRANSACTION HISTORY");

db.transactions.find().forEach(printjson);
