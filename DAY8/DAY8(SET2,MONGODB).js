


// Select database
use("AirlineBookingDB");


// 1. CREATE COLLECTIONS


db.createCollection("flights");
db.createCollection("seats");
db.createCollection("bookings");

// 2. INSERT SAMPLE DATA


db.flights.updateOne(
    { _id: 101 },
    {
        $setOnInsert: {
            flightName: "Indigo 6E-101",
            source: "Chennai",
            destination: "Delhi"
        }
    },
    { upsert: true }
);

db.flights.updateOne(
    { _id: 102 },
    {
        $setOnInsert: {
            flightName: "Air India AI-202",
            source: "Mumbai",
            destination: "Bangalore"
        }
    },
    { upsert: true }
);

db.seats.createIndex(
    { flightID: 1, seatNumber: 1 },
    { unique: true }
);

db.bookings.createIndex(
    { flightID: 1, seatNumber: 1 },
    { unique: true }
);

// Insert seats without duplicating existing records
const sampleSeats = [
    { flightID: 101, seatNumber: "A1" },
    { flightID: 101, seatNumber: "A2" },
    { flightID: 101, seatNumber: "A3" },
    { flightID: 101, seatNumber: "A4" },
    { flightID: 102, seatNumber: "B1" },
    { flightID: 102, seatNumber: "B2" }
];

sampleSeats.forEach(seat => {
    db.seats.updateOne(
        {
            flightID: seat.flightID,
            seatNumber: seat.seatNumber
        },
        {
            $setOnInsert: {
                status: "Available"
            }
        },
        { upsert: true }
    );
});


// 3. MULTI-DOCUMENT TRANSACTION


const session = db.getMongo().startSession();

const airlineDB = session.getDatabase("AirlineBookingDB");

try {

    session.withTransaction(() => {

        const seats = airlineDB.seats;
        const bookings = airlineDB.bookings;

        const flightID = 101;
        const seatNumber = "A1";
        const passengerName = "Abdullah";
        const fare = 5000;

        // Check and reserve the available seat
        const seatUpdate = seats.updateOne(
            {
                flightID: flightID,
                seatNumber: seatNumber,
                status: "Available"
            },
            {
                $set: { status: "Booked" }
            }
        );

        if (seatUpdate.modifiedCount !== 1) {
            throw new Error("Seat is already booked");
        }

        // Insert booking document
        bookings.insertOne({
            passengerName: passengerName,
            flightID: flightID,
            seatNumber: seatNumber,
            fare: fare,
            bookingDate: new Date()
        });

    });

    print("Booking successful");

} catch (error) {

    print("Booking failed: " + error.message);
    print("Transaction aborted");

} finally {

    session.endSession();

}


// 4. DISPLAY SEAT DETAILS


print("SEAT DETAILS");

db.seats.find().forEach(printjson);


// 5. DISPLAY BOOKING DETAILS


print("BOOKING DETAILS");

db.bookings.find().forEach(printjson);


// 6. DISPLAY FLIGHT DETAILS


print("FLIGHT DETAILS");

db.flights.find().forEach(printjson);


// 7. TOTAL REVENUE PER FLIGHT


print("FLIGHT REVENUE");

db.bookings.aggregate([
    {
        $group: {
            _id: "$flightID",
            totalRevenue: { $sum: "$fare" }
        }
    },
    {
        $sort: { _id: 1 }
    }
]).forEach(printjson);

