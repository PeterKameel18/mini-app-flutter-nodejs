const mongoose = require("mongoose");
const connection = mongoose
  .createConnection(
    "mongodb+srv://peterboles06:f7vfMoXYcxCZ3RiT@shoppingapp.mlufp.mongodb.net/Shopping"
  )
  .on("open", () => console.log("Connected to MongoDB"))
  .on("error", (err) => console.log("Error connecting to MongoDB", err));
module.exports = connection;
