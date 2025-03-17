import 'package:flutter/material.dart';

class ListOfItemsPage extends StatefulWidget {
  @override
  _ListOfItemsPageState createState() => _ListOfItemsPageState();
}

class _ListOfItemsPageState extends State<ListOfItemsPage> {
  final List<Map<String, dynamic>> items = [
    {'name': 'Item 1', 'icon': Icons.laptop, 'price': 100.0},
    {'name': 'Item 2', 'icon': Icons.phone, 'price': 50.0},
    {'name': 'Item 3', 'icon': Icons.watch, 'price': 75.0},
    {'name': 'Item 4', 'icon': Icons.headphones, 'price': 30.0},
    {'name': 'Item 5', 'icon': Icons.camera, 'price': 150.0},
  ];

  final List<Map<String, dynamic>> shoppingBasket = [];

  void addItemToBasket(Map<String, dynamic> item) {
    setState(() {
      shoppingBasket.add(item);
    });
  }

  double calculateTotalPrice() {
    return shoppingBasket.fold(0.0, (sum, item) => sum + item['price']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Items'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_basket),
            onPressed: () {
              // Navigate to shopping basket page or show a dialog with the basket items
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Shopping Basket'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...shoppingBasket.map((item) => ListTile(
                            leading: Icon(item['icon']),
                            title: Text(item['name']),
                            trailing: Text('\$${item['price']}'),
                          )),
                      Divider(),
                      Text('Total: \$${calculateTotalPrice()}'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(items[index]['icon'], size: 40),
            title: Text(items[index]['name']),
            subtitle: Text('\$${items[index]['price']}'),
            trailing: IconButton(
              icon: Icon(Icons.add_shopping_cart),
              onPressed: () => addItemToBasket(items[index]),
            ),
          );
        },
      ),
    );
  }
}