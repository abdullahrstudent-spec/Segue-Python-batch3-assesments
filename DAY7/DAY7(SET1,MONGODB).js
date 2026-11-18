
use("LogisticsDB");

// Reset database for fresh execution
db.dropDatabase();


// 1. HUBS COLLECTION

db.hubs.insertMany([
    { hub_id: 1, hub_name: "Chennai Hub", city: "Chennai" },
    { hub_id: 2, hub_name: "Bangalore Hub", city: "Bangalore" },
    { hub_id: 3, hub_name: "Hyderabad Hub", city: "Hyderabad" },
    { hub_id: 4, hub_name: "Mumbai Hub", city: "Mumbai" },
    { hub_id: 5, hub_name: "Delhi Hub", city: "Delhi" }
]);


// 2. EMPLOYEES COLLECTION


db.employees.insertMany([
    { employee_id: 1, employee_name: "Arun", hub_id: 1, supervisor_id: null },
    { employee_id: 2, employee_name: "Bala", hub_id: 1, supervisor_id: 1 },
    { employee_id: 3, employee_name: "Charan", hub_id: 2, supervisor_id: 1 },
    { employee_id: 4, employee_name: "Divya", hub_id: 3, supervisor_id: 2 },
    { employee_id: 5, employee_name: "Esha", hub_id: 4, supervisor_id: 2 }
]);

// 3. CARRIERS COLLECTION

db.carriers.insertMany([
    { carrier_id: 1, carrier_name: "BlueDart" },
    { carrier_id: 2, carrier_name: "DHL" },
    { carrier_id: 3, carrier_name: "FedEx" },
    { carrier_id: 4, carrier_name: "DTDC" }
]);


// 4. CUSTOMERS COLLECTION


db.customers.insertMany([
    { customer_id: 1, customer_name: "Abdullah", city: "Chennai" },
    { customer_id: 2, customer_name: "Hashini", city: "Bangalore" },
    { customer_id: 3, customer_name: "Rahul", city: "Hyderabad" },
    { customer_id: 4, customer_name: "Priya", city: "Mumbai" },
    { customer_id: 5, customer_name: "Karthik", city: "Delhi" },
    { customer_id: 6, customer_name: "Sara", city: "Chennai" }
]);


// 5. SHIPMENTS COLLECTION


db.shipments.insertMany([
    {
        shipment_id: 101, customer_id: 1, hub_id: 1, carrier_id: 1,
        shipping_cost: 500,
        expected_delivery: ISODate("2026-01-03"),
        actual_delivery: ISODate("2026-01-07")
    },
    {
        shipment_id: 102, customer_id: 1, hub_id: 2, carrier_id: 2,
        shipping_cost: 800,
        expected_delivery: ISODate("2026-01-04"),
        actual_delivery: ISODate("2026-01-04")
    },
    {
        shipment_id: 103, customer_id: 1, hub_id: 3, carrier_id: 3,
        shipping_cost: 600,
        expected_delivery: ISODate("2026-01-05"),
        actual_delivery: ISODate("2026-01-09")
    },
    {
        shipment_id: 104, customer_id: 1, hub_id: 4, carrier_id: 1,
        shipping_cost: 900,
        expected_delivery: ISODate("2026-01-06"),
        actual_delivery: ISODate("2026-01-06")
    },
    {
        shipment_id: 105, customer_id: 1, hub_id: 5, carrier_id: 2,
        shipping_cost: 700,
        expected_delivery: ISODate("2026-01-07"),
        actual_delivery: ISODate("2026-01-07")
    },
    {
        shipment_id: 106, customer_id: 2, hub_id: 1, carrier_id: 2,
        shipping_cost: 450,
        expected_delivery: ISODate("2026-01-08"),
        actual_delivery: ISODate("2026-01-08")
    },
    {
        shipment_id: 107, customer_id: 2, hub_id: 2, carrier_id: 3,
        shipping_cost: 750,
        expected_delivery: ISODate("2026-01-09"),
        actual_delivery: ISODate("2026-01-13")
    },
    {
        shipment_id: 108, customer_id: 3, hub_id: 1, carrier_id: 3,
        shipping_cost: 550,
        expected_delivery: ISODate("2026-01-10"),
        actual_delivery: ISODate("2026-01-15")
    },
    {
        shipment_id: 109, customer_id: 3, hub_id: 3, carrier_id: 4,
        shipping_cost: 650,
        expected_delivery: ISODate("2026-01-11"),
        actual_delivery: ISODate("2026-01-11")
    },
    {
        shipment_id: 110, customer_id: 4, hub_id: 2, carrier_id: 1,
        shipping_cost: 1000,
        expected_delivery: ISODate("2026-01-12"),
        actual_delivery: ISODate("2026-01-17")
    },
    {
        shipment_id: 111, customer_id: 4, hub_id: 4, carrier_id: 4,
        shipping_cost: 1200,
        expected_delivery: ISODate("2026-01-13"),
        actual_delivery: ISODate("2026-01-13")
    },
    {
        shipment_id: 112, customer_id: 5, hub_id: 3, carrier_id: 2,
        shipping_cost: 400,
        expected_delivery: ISODate("2026-01-14"),
        actual_delivery: ISODate("2026-01-14")
    },
    {
        shipment_id: 113, customer_id: 6, hub_id: 1, carrier_id: 1,
        shipping_cost: 300,
        expected_delivery: ISODate("2026-01-15"),
        actual_delivery: ISODate("2026-01-20")
    },
    {
        shipment_id: 114, customer_id: 6, hub_id: 2, carrier_id: 2,
        shipping_cost: 850,
        expected_delivery: ISODate("2026-01-16"),
        actual_delivery: ISODate("2026-01-16")
    }
]);


// 6. DELIVERY EVENTS COLLECTION


db.delivery_events.insertMany([
    { event_id: 1, shipment_id: 101, event_type: "Picked Up", description: "Shipment collected" },
    { event_id: 2, shipment_id: 101, event_type: "In Transit", description: "Shipment moving" },
    { event_id: 3, shipment_id: 101, event_type: "Delivered", description: "Delivered late" },
    { event_id: 4, shipment_id: 102, event_type: "Delivered", description: "Delivered on time" },
    { event_id: 5, shipment_id: 103, event_type: "Delayed", description: "Weather conditions" },
    { event_id: 6, shipment_id: 103, event_type: "Delivered", description: "Delivered late" },
    { event_id: 7, shipment_id: 107, event_type: "Delayed", description: "Vehicle breakdown" },
    { event_id: 8, shipment_id: 107, event_type: "Delivered", description: "Delivered late" },
    { event_id: 9, shipment_id: 108, event_type: "Delayed", description: "Sorting issue" },
    { event_id: 10, shipment_id: 108, event_type: "Delivered", description: "Delivered late" },
    { event_id: 11, shipment_id: 110, event_type: "Delayed", description: "Traffic delay" },
    { event_id: 12, shipment_id: 110, event_type: "Delivered", description: "Delivered late" },
    { event_id: 13, shipment_id: 113, event_type: "Delivered", description: "Delivered late" }
]);


// TASK 5: THREE MONGODB AGGREGATION PIPELINES
// USING $LOOKUP



// PIPELINE 1:
// SHIPMENTS WITH DELIVERY EVENTS

db.shipments.aggregate([
    {
        $lookup: {
            from: "delivery_events",
            localField: "shipment_id",
            foreignField: "shipment_id",
            as: "delivery_details"
        }
    },
    {
        $project: {
            _id: 0,
            shipment_id: 1,
            customer_id: 1,
            shipping_cost: 1,
            delivery_details: 1
        }
    }
]);


// PIPELINE 2:
// CUSTOMERS WITH THEIR SHIPMENTS

db.customers.aggregate([
    {
        $lookup: {
            from: "shipments",
            localField: "customer_id",
            foreignField: "customer_id",
            as: "customer_shipments"
        }
    },
    {
        $project: {
            _id: 0,
            customer_id: 1,
            customer_name: 1,
            city: 1,
            customer_shipments: 1
        }
    }
]);


// PIPELINE 3:
// CARRIERS WITH DELAY STATISTICS

db.carriers.aggregate([
    {
        $lookup: {
            from: "shipments",
            let: { carrierId: "$carrier_id" },
            pipeline: [
                {
                    $match: {
                        $expr: {
                            $eq: ["$carrier_id", "$$carrierId"]
                        }
                    }
                },
                {
                    $addFields: {
                        delay_days: {
                            $dateDiff: {
                                startDate: "$expected_delivery",
                                endDate: "$actual_delivery",
                                unit: "day"
                            }
                        }
                    }
                },
                {
                    $group: {
                        _id: null,
                        total_shipments: { $sum: 1 },
                        average_delay: { $avg: "$delay_days" },
                        delayed_shipments: {
                            $sum: {
                                $cond: [
                                    { $gt: ["$delay_days", 0] },
                                    1,
                                    0
                                ]
                            }
                        }
                    }
                }
            ],
            as: "delay_statistics"
        }
    },
    {
        $project: {
            _id: 0,
            carrier_id: 1,
            carrier_name: 1,
            delay_statistics: 1
        }
    }
]);

