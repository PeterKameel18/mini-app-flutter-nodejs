const mongoose = require("mongoose");
const connection = mongoose
  .createConnection("mongodb://localhost:27017/newToDO")
  .on("open", () => console.log("Connected to MongoDB"))
  .on("error", (err) => console.log("Error connecting to MongoDB", err));
module.exports = connection;
