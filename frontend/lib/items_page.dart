import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/config.dart';
import 'dart:convert';
import 'basket_page.dart';
import 'login_page.dart';

class ItemsPage extends StatefulWidget {
  final String token;
  const ItemsPage({required this.token, super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  late String email;
  late SharedPreferences prefs;
  List<Map<String, dynamic>> cart = [];
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['email'];
    initSharedPrefs();
    fetchItems();    
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

  Future<void> fetchItems() async {
    try {
      final response = await http.get(Uri.parse(getItems));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          items = List<Map<String, dynamic>>.from(jsonData);
        });
      } else {
        throw Exception("Failed to load items");
      }
    } catch (e) {
      print("Error fetching items: $e");
    }
  }

  void addToCart(Map<String, dynamic> item) {
    setState(() {
      cart.add(item);
      saveCart(); 
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
      body: items.isEmpty
          ? const Center()
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
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
