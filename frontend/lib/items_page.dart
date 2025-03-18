import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'basket_page.dart';
import 'login_page.dart';

class ItemsPage extends StatefulWidget {
  final String token;
  const ItemsPage({required this.token, Key? key}) : super(key: key);

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  late String email;
  late SharedPreferences prefs;
  List<Map<String, dynamic>> cart = [];

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['email'];
    initSharedPrefs();
  }

  void initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    loadCart();
  }

  void loadCart() {
    String? cartString = prefs.getString('cart_${widget.token}');
    if (cartString != null) {
      List<dynamic> decodedCart = jsonDecode(cartString);
      setState(() {
        cart = List<Map<String, dynamic>>.from(decodedCart);
      });
    }
  }

  void saveCart() {
    prefs.setString('cart_${widget.token}', jsonEncode(cart));
  }

  final List<Map<String, dynamic>> items = [
    {'name': '🍎 Apple', 'price': 1.5, 'iconCode': Icons.apple.codePoint},
    {
      'name': '🍌 Banana',
      'price': 1.0,
      'iconCode': Icons.breakfast_dining.codePoint,
    },
    {'name': '🍊 Orange', 'price': 1.2, 'iconCode': Icons.circle.codePoint},
    {'name': '🍇 Grapes', 'price': 2.0, 'iconCode': Icons.grain.codePoint},
    {'name': '🥭 Mango', 'price': 2.5, 'iconCode': Icons.food_bank.codePoint},
  ];

  void addToCart(Map<String, dynamic> item) {
    setState(() {
      cart.add(item);
      saveCart(); // Save cart after adding item
    });

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${item['name']} added to cart!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => CartPage(cart: cart, token: widget.token),
                ),
              ).then(
                (_) => loadCart(),
              ); // Reload cart when returning from CartPage
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Icon(
                IconData(items[index]['iconCode'], fontFamily: 'MaterialIcons'),
                color: Colors.green,
              ),
              title: Text(items[index]['name']),
              subtitle: Text('\$${items[index]['price']}'),
              trailing: IconButton(
                icon: const Icon(Icons.add_shopping_cart),
                onPressed: () => addToCart(items[index]),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          saveCart(); // Save cart before logging out
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
        label: const Text("Back to Login"),
        icon: const Icon(Icons.arrow_back),
      ),
    );
  }
}
