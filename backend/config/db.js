const mongoose = require("mongoose");
const connection = mongoose
  .createConnection(
    "mongodb+srv://project:project123@shoppingapp.mlufp.mongodb.net/Shopping"
  )
  .on("open", () => console.log("Connected to MongoDB"))
  .on("error", (err) => console.log("Error connecting to MongoDB", err));
module.exports = connection;
