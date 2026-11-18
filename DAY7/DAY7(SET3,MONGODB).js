

use("ReturnsRefundsDB");

db.dropDatabase();


// 1. PRODUCTS

db.products.insertMany([
    { product_id: 1, product_name: "Laptop", category: "Electronics" },
    { product_id: 2, product_name: "Mobile Phone", category: "Electronics" },
    { product_id: 3, product_name: "Headphones", category: "Accessories" },
    { product_id: 4, product_name: "Keyboard", category: "Accessories" },
    { product_id: 5, product_name: "Monitor", category: "Electronics" },
    { product_id: 6, product_name: "Mouse", category: "Accessories" },
    { product_id: 7, product_name: "Smart Watch", category: "Electronics" }
]);


// 2. CUSTOMERS


db.customers.insertMany([
    { customer_id: 1, customer_name: "Abdullah", city: "Chennai" },
    { customer_id: 2, customer_name: "Hashini", city: "Bangalore" },
    { customer_id: 3, customer_name: "Rahul", city: "Hyderabad" },
    { customer_id: 4, customer_name: "Priya", city: "Mumbai" },
    { customer_id: 5, customer_name: "Karthik", city: "Delhi" },
    { customer_id: 6, customer_name: "Sara", city: "Chennai" },
    { customer_id: 7, customer_name: "Arun", city: "Bangalore" }
]);

// 3. STORES


db.stores.insertMany([
    { store_id: 1, store_name: "Chennai Central", region: "South" },
    { store_id: 2, store_name: "Bangalore Store", region: "South" },
    { store_id: 3, store_name: "Hyderabad Store", region: "South" },
    { store_id: 4, store_name: "Mumbai Store", region: "West" },
    { store_id: 5, store_name: "Delhi Store", region: "North" },
    { store_id: 6, store_name: "Kolkata Store", region: "East" }
]);


// 4. EMPLOYEES


db.employees.insertMany([
    { employee_id: 1, employee_name: "Arun Manager", store_id: 1, manager_id: null },
    { employee_id: 2, employee_name: "Bala", store_id: 1, manager_id: 1 },
    { employee_id: 3, employee_name: "Charan", store_id: 2, manager_id: 1 },
    { employee_id: 4, employee_name: "Divya Manager", store_id: 3, manager_id: null },
    { employee_id: 5, employee_name: "Esha", store_id: 3, manager_id: 4 },
    { employee_id: 6, employee_name: "Farhan Manager", store_id: 4, manager_id: null },
    { employee_id: 7, employee_name: "Gokul", store_id: 4, manager_id: 6 },
    { employee_id: 8, employee_name: "Hari", store_id: 5, manager_id: null }
]);

// =====================================================
// 5. SALES
// =====================================================

db.sales.insertMany([
    { sale_id: 101, product_id: 1, customer_id: 1, store_id: 1, quantity_sold: 10, sale_amount: 500000 },
    { sale_id: 102, product_id: 2, customer_id: 2, store_id: 1, quantity_sold: 20, sale_amount: 400000 },
    { sale_id: 103, product_id: 3, customer_id: 3, store_id: 2, quantity_sold: 50, sale_amount: 150000 },
    { sale_id: 104, product_id: 4, customer_id: 4, store_id: 2, quantity_sold: 100, sale_amount: 200000 },
    { sale_id: 105, product_id: 5, customer_id: 5, store_id: 3, quantity_sold: 20, sale_amount: 600000 },
    { sale_id: 106, product_id: 6, customer_id: 6, store_id: 3, quantity_sold: 100, sale_amount: 100000 },
    { sale_id: 107, product_id: 1, customer_id: 7, store_id: 4, quantity_sold: 15, sale_amount: 750000 },
    { sale_id: 108, product_id: 2, customer_id: 1, store_id: 4, quantity_sold: 30, sale_amount: 600000 },
    { sale_id: 109, product_id: 3, customer_id: 2, store_id: 5, quantity_sold: 40, sale_amount: 120000 },
    { sale_id: 110, product_id: 4, customer_id: 3, store_id: 5, quantity_sold: 80, sale_amount: 160000 },
    { sale_id: 111, product_id: 5, customer_id: 4, store_id: 1, quantity_sold: 10, sale_amount: 300000 },
    { sale_id: 112, product_id: 6, customer_id: 5, store_id: 2, quantity_sold: 60, sale_amount: 60000 },
    { sale_id: 113, product_id: 7, customer_id: 6, store_id: 3, quantity_sold: 25, sale_amount: 250000 },
    { sale_id: 114, product_id: 7, customer_id: 7, store_id: 4, quantity_sold: 20, sale_amount: 200000 }
]);


// 6. RETURNS


db.returns.insertMany([
    { return_id: 201, sale_id: 101, product_id: 1, customer_id: 1, store_id: 1, employee_id: 2, return_quantity: 3, return_reason: "Damaged product", return_date: ISODate("2026-10-15") },
    { return_id: 202, sale_id: 102, product_id: 2, customer_id: 2, store_id: 1, employee_id: 2, return_quantity: 4, return_reason: "Wrong item", return_date: ISODate("2026-10-16") },
    { return_id: 203, sale_id: 103, product_id: 3, customer_id: 3, store_id: 2, employee_id: 3, return_quantity: 8, return_reason: "Defective", return_date: ISODate("2026-10-17") },
    { return_id: 204, sale_id: 104, product_id: 4, customer_id: 4, store_id: 2, employee_id: 3, return_quantity: 5, return_reason: "Changed mind", return_date: ISODate("2026-10-18") },
    { return_id: 205, sale_id: 105, product_id: 5, customer_id: 5, store_id: 3, employee_id: 5, return_quantity: 5, return_reason: "Damaged product", return_date: ISODate("2026-10-19") },
    { return_id: 206, sale_id: 106, product_id: 6, customer_id: 6, store_id: 3, employee_id: 5, return_quantity: 2, return_reason: "Wrong item", return_date: ISODate("2026-10-20") },
    { return_id: 207, sale_id: 107, product_id: 1, customer_id: 7, store_id: 4, employee_id: 7, return_quantity: 2, return_reason: "Defective", return_date: ISODate("2026-10-21") },
    { return_id: 208, sale_id: 108, product_id: 2, customer_id: 1, store_id: 4, employee_id: 7, return_quantity: 6, return_reason: "Damaged product", return_date: ISODate("2026-10-22") },
    { return_id: 209, sale_id: 109, product_id: 3, customer_id: 2, store_id: 5, employee_id: 8, return_quantity: 3, return_reason: "Changed mind", return_date: ISODate("2026-10-23") },
    { return_id: 210, sale_id: 110, product_id: 4, customer_id: 3, store_id: 5, employee_id: 8, return_quantity: 4, return_reason: "Defective", return_date: ISODate("2026-10-24") },
    { return_id: 211, sale_id: 111, product_id: 5, customer_id: 4, store_id: 1, employee_id: 2, return_quantity: 1, return_reason: "Wrong item", return_date: ISODate("2026-10-25") },
    { return_id: 212, sale_id: 112, product_id: 6, customer_id: 5, store_id: 2, employee_id: 3, return_quantity: 5, return_reason: "Damaged product", return_date: ISODate("2026-10-26") },
    { return_id: 213, sale_id: 113, product_id: 7, customer_id: 6, store_id: 3, employee_id: 5, return_quantity: 3, return_reason: "Defective", return_date: ISODate("2026-10-27") },
    { return_id: 214, sale_id: 114, product_id: 7, customer_id: 7, store_id: 4, employee_id: 7, return_quantity: 2, return_reason: "Wrong item", return_date: ISODate("2026-10-28") },
    { return_id: 215, sale_id: 101, product_id: 1, customer_id: 1, store_id: 1, employee_id: 2, return_quantity: 1, return_reason: "Damaged product", return_date: ISODate("2026-10-29") },
    { return_id: 216, sale_id: 102, product_id: 2, customer_id: 2, store_id: 1, employee_id: 2, return_quantity: 1, return_reason: "Wrong item", return_date: ISODate("2026-10-30") },
    { return_id: 217, sale_id: 103, product_id: 3, customer_id: 3, store_id: 2, employee_id: 3, return_quantity: 1, return_reason: "Defective", return_date: ISODate("2026-10-31") },
    { return_id: 218, sale_id: 104, product_id: 4, customer_id: 4, store_id: 2, employee_id: 3, return_quantity: 1, return_reason: "Changed mind", return_date: ISODate("2026-11-01") },
    { return_id: 219, sale_id: 105, product_id: 5, customer_id: 5, store_id: 3, employee_id: 5, return_quantity: 1, return_reason: "Damaged product", return_date: ISODate("2026-11-02") },
    { return_id: 220, sale_id: 106, product_id: 6, customer_id: 6, store_id: 3, employee_id: 5, return_quantity: 1, return_reason: "Wrong item", return_date: ISODate("2026-11-03") },
    { return_id: 221, sale_id: 107, product_id: 1, customer_id: null, store_id: 4, employee_id: 7, return_quantity: 1, return_reason: "Anonymous return", return_date: ISODate("2026-11-04") }
]);


// 7. REFUNDS


db.refunds.insertMany([
    { refund_id: 301, return_id: 201, refund_amount: 150000, refund_date: ISODate("2026-10-16") },
    { refund_id: 302, return_id: 202, refund_amount: 80000, refund_date: ISODate("2026-10-17") },
    { refund_id: 303, return_id: 203, refund_amount: 24000, refund_date: ISODate("2026-10-18") },
    { refund_id: 304, return_id: 204, refund_amount: 10000, refund_date: ISODate("2026-10-19") },
    { refund_id: 305, return_id: 205, refund_amount: 150000, refund_date: ISODate("2026-10-20") },
    { refund_id: 306, return_id: 207, refund_amount: 100000, refund_date: ISODate("2026-10-22") },
    { refund_id: 307, return_id: 208, refund_amount: 120000, refund_date: ISODate("2026-10-23") },
    { refund_id: 308, return_id: 209, refund_amount: 9000, refund_date: ISODate("2026-10-24") },
    { refund_id: 309, return_id: 210, refund_amount: 8000, refund_date: ISODate("2026-10-25") },
    { refund_id: 310, return_id: 211, refund_amount: 30000, refund_date: ISODate("2026-10-26") },
    { refund_id: 311, return_id: 213, refund_amount: 30000, refund_date: ISODate("2026-10-28") },
    { refund_id: 312, return_id: 215, refund_amount: 50000, refund_date: ISODate("2026-10-30") },
    { refund_id: 313, return_id: 217, refund_amount: 3000, refund_date: ISODate("2026-11-01") },
    { refund_id: 314, return_id: 219, refund_amount: 30000, refund_date: ISODate("2026-11-03") }
]);

// =====================================================
// 8. RETURNS FEEDBACK
// =====================================================

db.returns_feedback.insertMany([
    { feedback_id: 401, return_id: 201, rating: 2, feedback_comment: "Product arrived damaged" },
    { feedback_id: 402, return_id: 202, rating: 3, feedback_comment: "Incorrect product delivered" },
    { feedback_id: 403, return_id: 203, rating: 1, feedback_comment: "Very poor quality" },
    { feedback_id: 404, return_id: 204, rating: 4, feedback_comment: "Return process was easy" },
    { feedback_id: 405, return_id: 205, rating: 2, feedback_comment: "Product was broken" },
    { feedback_id: 406, return_id: 207, rating: 3, feedback_comment: "Replacement preferred" },
    { feedback_id: 407, return_id: 208, rating: 1, feedback_comment: "Not satisfied" },
    { feedback_id: 408, return_id: 210, rating: 4, feedback_comment: "Good customer support" },
    { feedback_id: 409, return_id: 213, rating: 2, feedback_comment: "Defective item" }
]);

// TASK 5: THREE MONGODB $LOOKUP PIPELINES


// PIPELINE 1:
// RETURNS WITH CUSTOMER, PRODUCT AND FEEDBACK

db.returns.aggregate([
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
            from: "products",
            localField: "product_id",
            foreignField: "product_id",
            as: "product_details"
        }
    },
    {
        $lookup: {
            from: "returns_feedback",
            localField: "return_id",
            foreignField: "return_id",
            as: "feedback_details"
        }
    },
    {
        $project: {
            _id: 0,
            return_id: 1,
            return_quantity: 1,
            return_reason: 1,
            customer_details: 1,
            product_details: 1,
            feedback_details: 1
        }
    }
]);


// PIPELINE 2:
// RETURNS WITH THEIR REFUND DETAILS

db.returns.aggregate([
    {
        $lookup: {
            from: "refunds",
            localField: "return_id",
            foreignField: "return_id",
            as: "refund_details"
        }
    },
    {
        $lookup: {
            from: "customers",
            localField: "customer_id",
            foreignField: "customer_id",
            as: "customer_details"
        }
    },
    {
        $project: {
            _id: 0,
            return_id: 1,
            return_reason: 1,
            return_quantity: 1,
            customer_details: 1,
            refund_details: 1
        }
    }
]);


// PIPELINE 3:
// STORES WITH THEIR TOTAL REFUND VALUE
// AND RETURN FEEDBACK

db.stores.aggregate([
    {
        $lookup: {
            from: "returns",
            localField: "store_id",
            foreignField: "store_id",
            as: "store_returns"
        }
    },
    {
        $unwind: {
            path: "$store_returns",
            preserveNullAndEmptyArrays: true
        }
    },
    {
        $lookup: {
            from: "refunds",
            localField: "store_returns.return_id",
            foreignField: "return_id",
            as: "refund_details"
        }
    },
    {
        $lookup: {
            from: "returns_feedback",
            localField: "store_returns.return_id",
            foreignField: "return_id",
            as: "feedback_details"
        }
    },
    {
        $group: {
            _id: {
                store_id: "$store_id",
                store_name: "$store_name",
                region: "$region"
            },
            total_refund: {
                $sum: {
                    $sum: "$refund_details.refund_amount"
                }
            },
            total_returns: {
                $sum: {
                    $cond: [
                        { $ne: ["$store_returns", null] },
                        1,
                        0
                    ]
                }
            },
            feedback_records: {
                $push: "$feedback_details"
            }
        }
    },
    {
        $project: {
            _id: 0,
            store_id: "$_id.store_id",
            store_name: "$_id.store_name",
            region: "$_id.region",
            total_refund: 1,
            total_returns: 1,
            feedback_records: 1
        }
    }
]);
