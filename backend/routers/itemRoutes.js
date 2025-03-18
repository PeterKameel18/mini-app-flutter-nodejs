const express = require("express");
const router = express.Router();
const itemController = require("../controller/itemController");

router.get("/items", itemController.getItems);

module.exports = router;
