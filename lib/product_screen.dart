import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/cart_provider.dart';
import 'package:shopping_cart/cart_screen.dart';
import 'package:shopping_cart/data.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CartScreen(),
              ),
            ),
            icon: const Padding(
              padding: EdgeInsets.only(right: 25.0),
              child: Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: PRODUCTS_DATA.length,
        itemBuilder: (context, i) => ProductTile(
          id: PRODUCTS_DATA[i]['id'] as String,
          title: PRODUCTS_DATA[i]['title'] as String,
          price: PRODUCTS_DATA[i]['price'] as double,
        ),
      ),
    );
  }
}

class ProductTile extends StatelessWidget {
  final String id;
  final String title;
  final double price;

  const ProductTile({
    super.key,
    required this.id,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text("\$$price"),
        trailing: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            Provider.of<Cart>(context, listen: false).addItem(id, price, title);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Added $title to cart!"),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),
      ),
    );
  }
}
