import 'package:daraz_app/app.dart';
import 'package:daraz_app/screens/addProduct.dart';
import 'package:daraz_app/screens/updateProduct.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class MyProductsPage extends StatefulWidget {
  @override
  _MyProductsPageState createState() => _MyProductsPageState();
}

typedef DeleteProduct = void Function();

class _MyProductsPageState extends State<MyProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Products"),
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (_, state) {
            return ListView(
              children: state.products.map((product) {
                return Card(
                  child: ListTile(
                    leading: Image.network(product["image"] as String),
                    title: Text(product["name"] as String),
                    subtitle: Text(product["description"] as String),
                    trailing: Text(product["price"].toString() + "\$"),
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return StoreConnector<AppState, DeleteProduct>(
                            builder: (_, deleteCallBack) {
                              return AlertDialog(
                                title: Text("Actions"),
                                content:
                                    Text("Actions for the current product?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              UpdateProductPage(
                                            product: product,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text("Update"),
                                  ),
                                  TextButton(
                                    onPressed: deleteCallBack,
                                    child: Text("Delete"),
                                  ),
                                ],
                              );
                            },
                            converter: (store) {
                              return () async {
                                store.dispatch(
                                    deleteProduct(product["_id"] as String));
                                Navigator.of(context).pop();
                              };
                            },
                          );
                        },
                      );
                    },
                    onTap: () {},
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
      floatingActionButton: SizedBox(
        width: 200,
        child: FloatingActionButton(
          onPressed: () => Navigator.of(context)
              .pushNamed(AddProductRoute, arguments: {"product": {}}),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.black,
          mini: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add),
              Text("Add Product"),
            ],
          ),
        ),
      ),
    );
  }
}
