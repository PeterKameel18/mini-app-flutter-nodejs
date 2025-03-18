// controllers/itemController.js
const itemService = require("../services/itemService");
const { successResponse, errorResponse } = require("../utils/responseHandler");

class ItemController {
  async getItems(req, res) {
    try {
      const items = await itemService.getAllItems();
      return successResponse(res, 200, "Items retrieved successfully", items);
    } catch (error) {
      return errorResponse(res, 500, "Error retrieving items", error);
    }
  }
}

module.exports = new ItemController();
