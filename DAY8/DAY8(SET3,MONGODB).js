

// Select database
use("RetailInventoryDB");


// 1. CREATE COLLECTION

db.createCollection("products");


// 2. INSERT SAMPLE PRODUCTS


const sampleProducts = [
    {
        _id: 1,
        productName: "Laptop",
        category: "Electronics",
        stock: 20,
        price: 50000
    },
    {
        _id: 2,
        productName: "Mobile",
        category: "Electronics",
        stock: 15,
        price: 25000
    },
    {
        _id: 3,
        productName: "Headphones",
        category: "Electronics",
        stock: 5,
        price: 2000
    },
    {
        _id: 4,
        productName: "Keyboard",
        category: "Electronics",
        stock: 30,
        price: 1500
    },
    {
        _id: 5,
        productName: "Mouse",
        category: "Electronics",
        stock: 8,
        price: 800
    },
    {
        _id: 6,
        productName: "T-Shirt",
        category: "Clothing",
        stock: 40,
        price: 700
    }
];

sampleProducts.forEach(product => {
    db.products.updateOne(
        { _id: product._id },
        { $setOnInsert: product },
        { upsert: true }
    );
});


// 3. SINGLE-DOCUMENT ATOMIC STOCK UPDATE

// Reserve 2 laptops

const productID = 1;
const quantity = 2;

const result = db.products.updateOne(
    {
        _id: productID,
        stock: { $gte: quantity }
    },
    {
        $inc: { stock: -quantity }
    }
);

if (result.modifiedCount === 1) {

    print("Stock reserved successfully");

} else {

    print("Reservation failed: Insufficient stock");

}


// 4. DISPLAY UPDATED PRODUCT


print("UPDATED PRODUCT DETAILS");

db.products.findOne({ _id: productID });


// 5. DISPLAY ALL PRODUCTS


print("ALL PRODUCTS");

db.products.find().forEach(printjson);


// 6. DEMONSTRATE INSUFFICIENT STOCK


// Request 100 laptops

const failedResult = db.products.updateOne(
    {
        _id: productID,
        stock: { $gte: 100 }
    },
    {
        $inc: { stock: -100 }
    }
);

if (failedResult.modifiedCount === 0) {

    print("Insufficient stock. Update rejected.");

}

// Verify stock remains unchanged
print("FINAL LAPTOP STOCK");

db.products.findOne(
    { _id: productID },
    { productName: 1, stock: 1 }
);

