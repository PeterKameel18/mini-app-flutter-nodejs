const ShoppingListModel = require("../model/shoppingList.model");

class ShoppingListService {
  static async addItem(userId, itemData) {
    try {
      let cart = await ShoppingListModel.findOne({ userId });

      if (!cart) {
        cart = new ShoppingListModel({
          userId,
          items: [itemData],
        });
      } else {
        cart.items.push(itemData);
      }

      cart.totalAmount = cart.items.reduce(
        (total, item) => total + item.price * item.quantity,
        0
      );
      return await cart.save();
    } catch (error) {
      throw error;
    }
  }

  static async getCart(userId) {
    try {
      return await ShoppingListModel.findOne({ userId });
    } catch (error) {
      throw error;
    }
  }

  static async removeItem(userId, itemId) {
    try {
      const cart = await ShoppingListModel.findOne({ userId });
      if (!cart) throw new Error("Cart not found");

      cart.items = cart.items.filter((item) => item._id.toString() !== itemId);
      cart.totalAmount = cart.items.reduce(
        (total, item) => total + item.price * item.quantity,
        0
      );
      return await cart.save();
    } catch (error) {
      throw error;
    }
  }
}

module.exports = ShoppingListService;
