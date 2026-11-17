
// Select the Retail Inventory database
use('RetailInventoryDB');

// Create reviews collection with JSON Schema validation
db.createCollection('reviews', {
    validator: {
        $jsonSchema: {
            bsonType: 'object',
            required: [
                'productSKU',
                'customerName',
                'rating',
                'reviewText',
                'reviewDate'
            ],
            properties: {
                productSKU: {
                    bsonType: 'string',
                    description: 'Product SKU is required'
                },
                customerName: {
                    bsonType: 'string',
                    description: 'Customer name is required'
                },
                rating: {
                    bsonType: 'int',
                    minimum: 1,
                    maximum: 5,
                    description: 'Rating must be between 1 and 5'
                },
                reviewText: {
                    bsonType: 'string',
                    description: 'Review text is required'
                },
                reviewDate: {
                    bsonType: 'date',
                    description: 'Review date is required'
                }
            }
        }
    }
});

// Display all collections
// Display all collection names
db.getCollectionNames();


use('RetailInventoryDB');

// Insert multiple customer reviews
db.reviews.insertMany([
    {
        productSKU: "P101",
        customerName: "Arun",
        rating: 5,
        reviewText: "Excellent laptop with great performance",
        reviewDate: new Date("2026-11-10")
    },
    {
        productSKU: "P101",
        customerName: "Priya",
        rating: 4,
        reviewText: "Good laptop but slightly expensive",
        reviewDate: new Date("2026-11-11")
    },
    {
        productSKU: "P102",
        customerName: "Rahul",
        rating: 5,
        reviewText: "Comfortable and good quality T-shirt",
        reviewDate: new Date("2026-11-12")
    },
    {
        productSKU: "P103",
        customerName: "Sneha",
        rating: 3,
        reviewText: "Average office chair",
        reviewDate: new Date("2026-11-12")
    },
    {
        productSKU: "P104",
        customerName: "Karthik",
        rating: 5,
        reviewText: "Very useful SQL learning book",
        reviewDate: new Date("2026-11-13")
    },
    {
        productSKU: "P105",
        customerName: "Divya",
        rating: 4,
        reviewText: "Good quality rice",
        reviewDate: new Date("2026-11-13")
    },
    {
        productSKU: "P106",
        customerName: "Vijay",
        rating: 4,
        reviewText: "Good football for practice",
        reviewDate: new Date("2026-11-14")
    },
    {
        productSKU: "P107",
        customerName: "Anu",
        rating: 5,
        reviewText: "Very comfortable running shoes",
        reviewDate: new Date("2026-11-14")
    },
    {
        productSKU: "P108",
        customerName: "Manoj",
        rating: 2,
        reviewText: "Not suitable for my skin",
        reviewDate: new Date("2026-11-15")
    },
    {
        productSKU: "P109",
        customerName: "Meera",
        rating: 4,
        reviewText: "Works well in the kitchen",
        reviewDate: new Date("2026-11-15")
    }
]);
// 1. Display all reviews
db.reviews.find({});

// 2. Find reviews with a 5-star rating
db.reviews.find({ rating: 5 });

// 3. Find reviews for product P101
db.reviews.find({ productSKU: "P101" });

// 4. Find reviews with ratings below 3
db.reviews.find({ rating: { $lt: 3 } });

db.reviews.updateOne(
    { customerName: "Arun" },
    {
        $set: {
            rating: 4,
            reviewText: "Good laptop with excellent performance"
        }
    }
);
db.reviews.find({ customerName: "Arun" });

db.reviews.deleteOne(
    { customerName: "Manoj" }
);

db.reviews.find({ customerName: "Manoj" });