import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final String token;

  const CartPage({super.key, required this.cart, required this.token});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late SharedPreferences prefs;
  List<Map<String, dynamic>> userCart = [];

  @override
  void initState() {
    super.initState();
    initSharedPrefs();
  }

  void initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    loadUserCart();
  }

  void loadUserCart() {
    String? cartString = prefs.getString('cart_${widget.token}');
    if (cartString != null) {
      List<dynamic> decodedCart = jsonDecode(cartString);
      setState(() {
        userCart = List<Map<String, dynamic>>.from(decodedCart);
        // Merge with any new items from widget.cart
        for (var item in widget.cart) {
          if (!userCart.any(
            (element) =>
                element['name'] == item['name'] &&
                element['price'] == item['price'],
          )) {
            userCart.add(item);
          }
        }
      });
    } else {
      setState(() {
        userCart = [...widget.cart];
      });
    }
    saveUserCart();
  }

  void saveUserCart() {
    prefs.setString('cart_${widget.token}', jsonEncode(userCart));
  }

  double getTotalPrice() {
    return userCart.fold(0, (sum, item) => sum + (item['price'] as num));
  }

  void checkout() {
    if (userCart.isNotEmpty) {
      setState(() {
        userCart.clear();
        saveUserCart();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Checkout successful! Thank you for your purchase.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty! Add items before checking out.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void removeItem(int index) {
    setState(() {
      userCart.removeAt(index);
      saveUserCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shopping Basket')),
      body:
          userCart.isEmpty
              ? const Center(child: Text('Your cart is empty!'))
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: userCart.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(userCart[index]['name']),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) => removeItem(index),
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          child: ListTile(
                            leading: Icon(
                              IconData(
                                userCart[index]['iconCode'],
                                fontFamily: 'MaterialIcons',
                              ),
                              color: Colors.green,
                            ),
                            title: Text(userCart[index]['name']),
                            subtitle: Text('\$${userCart[index]['price']}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () => removeItem(index),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Total: \$${getTotalPrice().toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: checkout,
                          icon: const Icon(Icons.payment),
                          label: const Text("Checkout"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pop(context);
        },
        label: const Text("Back to Items"),
        icon: const Icon(Icons.arrow_back),
      ),
    );
  }
}
