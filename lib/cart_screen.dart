import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Column(
        children: [
          CartTotal(cart: cart),
          const SizedBox(height: 10),
          Expanded(
            child: cart.items.isEmpty
                ? const Center(child: Text('Your cart is empty'))
                : ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (ctx, i) {
                      var cartItem = cart.items.values.toList()[i];
                      var productId = cart.items.keys.toList()[i];
                      return CartItemWidget(
                        id: cartItem.id,
                        productId: productId,
                        title: cartItem.title,
                        quantity: cartItem.quantity,
                        price: cartItem.price,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class CartTotal extends StatelessWidget {
  final Cart cart;

  const CartTotal({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "\$${cart.totalAmount.toStringAsFixed(2)}",
            style: const TextStyle(color: Colors.black),
          ),
          TextButton(
            onPressed: cart.items.isEmpty
                ? null
                : () {
                    // Handle buying action here
                  },
            child: const Text('Buy Now'),
          ),
        ],
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  const CartItemWidget({
    super.key,
    required this.id,
    required this.productId,
    required this.title,
    required this.quantity,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        final cart = Provider.of<Cart>(context, listen: false);

        cart.removeItem(productId);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Removed $title from cart.'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                cart.addItem(productId, price, title);
              },
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: FittedBox(child: Text('\$$price')),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${(price * quantity).toStringAsFixed(2)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Provider.of<Cart>(context, listen: false)
                        .addItem(productId, price, title);
                  },
                ),
                Text('$quantity'),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    Provider.of<Cart>(context, listen: false)
                        .removeSingleItem(productId);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
