const express = require("express");
const router = express.Router();
const itemController = require("../controller/itemController");

router.get("/items", itemController.getItems);
router.post("/items", itemController.createItem);

module.exports = router;
