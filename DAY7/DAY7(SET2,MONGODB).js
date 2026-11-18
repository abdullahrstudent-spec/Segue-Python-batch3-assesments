

// Select database
use("BankLoanDB");

// Reset database for fresh execution
db.dropDatabase();


// 1. BRANCHES COLLECTION


db.branches.insertMany([
    { branch_id: 1, branch_name: "Chennai Main Branch", city: "Chennai" },
    { branch_id: 2, branch_name: "Bangalore Branch", city: "Bangalore" },
    { branch_id: 3, branch_name: "Hyderabad Branch", city: "Hyderabad" },
    { branch_id: 4, branch_name: "Mumbai Branch", city: "Mumbai" },
    { branch_id: 5, branch_name: "Delhi Branch", city: "Delhi" },
    { branch_id: 6, branch_name: "Kolkata Branch", city: "Kolkata" }
]);

// 2. CUSTOMERS COLLECTION

db.customers.insertMany([
    { customer_id: 1, customer_name: "Abdullah", city: "Chennai" },
    { customer_id: 2, customer_name: "Hashini", city: "Bangalore" },
    { customer_id: 3, customer_name: "Rahul", city: "Hyderabad" },
    { customer_id: 4, customer_name: "Priya", city: "Mumbai" },
    { customer_id: 5, customer_name: "Karthik", city: "Delhi" },
    { customer_id: 6, customer_name: "Sara", city: "Chennai" },
    { customer_id: 7, customer_name: "Arun", city: "Bangalore" },
    { customer_id: 8, customer_name: "Divya", city: "Mumbai" },
    { customer_id: 9, customer_name: "Vijay", city: "Hyderabad" }
]);


// 3. LOANS COLLECTION


db.loans.insertMany([
    {
        loan_id: 101, customer_id: 1, branch_id: 1,
        loan_amount: 500000, overdue_installments: 4,
        loan_date: ISODate("2026-01-10")
    },
    {
        loan_id: 102, customer_id: 1, branch_id: 2,
        loan_amount: 300000, overdue_installments: 1,
        loan_date: ISODate("2026-02-15")
    },
    {
        loan_id: 103, customer_id: 2, branch_id: 1,
        loan_amount: 800000, overdue_installments: 0,
        loan_date: ISODate("2026-03-10")
    },
    {
        loan_id: 104, customer_id: 3, branch_id: 2,
        loan_amount: 400000, overdue_installments: 5,
        loan_date: ISODate("2026-01-20")
    },
    {
        loan_id: 105, customer_id: 3, branch_id: 3,
        loan_amount: 600000, overdue_installments: 2,
        loan_date: ISODate("2026-04-12")
    },
    {
        loan_id: 106, customer_id: 4, branch_id: 3,
        loan_amount: 900000, overdue_installments: 4,
        loan_date: ISODate("2026-02-18")
    },
    {
        loan_id: 107, customer_id: 5, branch_id: 1,
        loan_amount: 200000, overdue_installments: 0,
        loan_date: ISODate("2026-05-05")
    },
    {
        loan_id: 108, customer_id: 6, branch_id: 2,
        loan_amount: 700000, overdue_installments: 3,
        loan_date: ISODate("2026-03-22")
    },
    {
        loan_id: 109, customer_id: 7, branch_id: 3,
        loan_amount: 350000, overdue_installments: 1,
        loan_date: ISODate("2026-06-01")
    },
    {
        loan_id: 110, customer_id: 8, branch_id: 4,
        loan_amount: 1000000, overdue_installments: 6,
        loan_date: ISODate("2026-01-15")
    },
    {
        loan_id: 111, customer_id: 9, branch_id: 4,
        loan_amount: 450000, overdue_installments: 0,
        loan_date: ISODate("2026-06-20")
    }
]);


// 4. GUARANTORS COLLECTION


db.guarantors.insertMany([
    { guarantor_id: 1, loan_id: 101, guarantor_customer_id: 2 },
    { guarantor_id: 2, loan_id: 103, guarantor_customer_id: 1 },
    { guarantor_id: 3, loan_id: 104, guarantor_customer_id: 5 },
    { guarantor_id: 4, loan_id: 106, guarantor_customer_id: 7 },
    { guarantor_id: 5, loan_id: 110, guarantor_customer_id: 3 }
]);


// 5. REPAYMENTS COLLECTION


db.repayments.insertMany([
    {
        repayment_id: 1, loan_id: 101,
        repayment_amount: 20000,
        repayment_date: ISODate("2026-11-05")
    },
    {
        repayment_id: 2, loan_id: 101,
        repayment_amount: 15000,
        repayment_date: ISODate("2026-10-05")
    },
    {
        repayment_id: 3, loan_id: 102,
        repayment_amount: 10000,
        repayment_date: ISODate("2026-11-10")
    },
    {
        repayment_id: 4, loan_id: 103,
        repayment_amount: 25000,
        repayment_date: ISODate("2026-10-20")
    },
    {
        repayment_id: 5, loan_id: 104,
        repayment_amount: 12000,
        repayment_date: ISODate("2026-08-01")
    },
    {
        repayment_id: 6, loan_id: 105,
        repayment_amount: 18000,
        repayment_date: ISODate("2026-11-12")
    },
    {
        repayment_id: 7, loan_id: 106,
        repayment_amount: 30000,
        repayment_date: ISODate("2026-07-15")
    },
    {
        repayment_id: 8, loan_id: 107,
        repayment_amount: 8000,
        repayment_date: ISODate("2026-11-01")
    },
    {
        repayment_id: 9, loan_id: 108,
        repayment_amount: 22000,
        repayment_date: ISODate("2026-09-10")
    },
    {
        repayment_id: 10, loan_id: 109,
        repayment_amount: 11000,
        repayment_date: ISODate("2026-11-15")
    },
    {
        repayment_id: 11, loan_id: 110,
        repayment_amount: 35000,
        repayment_date: ISODate("2026-08-15")
    },
    {
        repayment_id: 12, loan_id: 111,
        repayment_amount: 14000,
        repayment_date: ISODate("2026-10-25")
    }
]);


// TASK 5: THREE AGGREGATION PIPELINES USING $LOOKUP



// PIPELINE 1:
// COMBINE LOANS WITH CUSTOMER COLLECTION

db.loans.aggregate([
    {
        $lookup: {
            from: "customers",
            localField: "customer_id",
            foreignField: "customer_id",
            as: "customer_details"
        }
    },
    {
        $unwind: "$customer_details"
    },
    {
        $project: {
            _id: 0,
            loan_id: 1,
            loan_amount: 1,
            overdue_installments: 1,
            customer_name: "$customer_details.customer_name",
            customer_city: "$customer_details.city"
        }
    }
]);


// PIPELINE 2:
// COMBINE LOANS WITH REPAYMENT COLLECTION

db.loans.aggregate([
    {
        $lookup: {
            from: "repayments",
            localField: "loan_id",
            foreignField: "loan_id",
            as: "repayment_details"
        }
    },
    {
        $project: {
            _id: 0,
            loan_id: 1,
            customer_id: 1,
            loan_amount: 1,
            repayment_details: 1
        }
    }
]);


// PIPELINE 3:
// FIND THE LAST REPAYMENT FOR EACH LOAN
// ALSO COMBINE WITH CUSTOMER DETAILS

db.loans.aggregate([
    {
        $lookup: {
            from: "customers",
            localField: "customer_id",
            foreignField: "customer_id",
            as: "customer_details"
        }
    },
    {
        $lookup: {
            from: "repayments",
            let: { currentLoanId: "$loan_id" },
            pipeline: [
                {
                    $match: {
                        $expr: {
                            $eq: ["$loan_id", "$$currentLoanId"]
                        }
                    }
                },
                {
                    $sort: {
                        repayment_date: -1
                    }
                },
                {
                    $limit: 1
                }
            ],
            as: "last_repayment"
        }
    },
    {
        $project: {
            _id: 0,
            loan_id: 1,
            loan_amount: 1,
            customer_details: 1,
            last_repayment: 1
        }
    }
]);

