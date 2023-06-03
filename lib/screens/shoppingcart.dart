import 'package:daraz_app/app.dart';
import 'package:flutter/material.dart';

class ShoppingCartPage extends StatefulWidget {
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class CartItem {
  final String name;
  int quantity;
  final double price;

  CartItem({required this.name, required this.quantity, required this.price});
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  List<CartItem> cartItems = [
    CartItem(name: 'Item 1', quantity: 1, price: 10.0),
    CartItem(name: 'Item 2', quantity: 2, price: 15.0),
    CartItem(name: 'Item 3', quantity: 3, price: 8.0),
  ];

  double calculateTotal() {
    double total = 0.0;
    for (CartItem item in cartItems) {
      total += item.price * item.quantity;
    }
    return total;
  }

  void incrementQuantity(CartItem item) {
    setState(() {
      item.quantity++;
    });
  }

  void decrementQuantity(CartItem item) {
    setState(() {
      if (item.quantity > 1) {
        item.quantity--;
      }
    });
  }

  void removeItem(CartItem item) {
    setState(() {
      cartItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (BuildContext context, int index) {
                CartItem item = cartItems[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price: \$${item.price.toStringAsFixed(2)}'),
                      Text('Quantity: ${item.quantity}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () => decrementQuantity(item),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => incrementQuantity(item),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => removeItem(item),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${calculateTotal().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          InkWell(
            onTap: () {
              // Handle checkout logic here
              Navigator.of(context).pushNamed(CheckoutRoute);
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Text(
                  'Checkout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
