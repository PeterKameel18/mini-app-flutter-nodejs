import 'package:flutter/material.dart';
import 'basket_page.dart';
import 'login.dart';

class ItemsPage extends StatefulWidget {
  @override
  _ItemsPageState createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  final List<Map<String, dynamic>> items = [
    {'name': '🍎 Apple', 'price': 1.5},
    {'name': '🍌 Banana', 'price': 1.0},
    {'name': '🍊 Orange', 'price': 1.2},
    {'name': '🍇 Grapes', 'price': 2.0},
    {'name': '🥭 Mango', 'price': 2.5},
  ];

  final List<Map<String, dynamic>> cart = [];

  void addToCart(Map<String, dynamic> item) {
    setState(() {
      cart.add(item);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item['name']} added to cart!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Items List'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(cart: cart),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Icon(items[index]['icon'], color: Colors.green),
              title: Text(items[index]['name']),
              subtitle: Text('\$${items[index]['price']}'),
              trailing: IconButton(
                icon: Icon(Icons.add_shopping_cart),
                onPressed: () => addToCart(items[index]),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
        label: Text("Back to Login"),
        icon: Icon(Icons.arrow_back),
      ),
    );
  }
}
