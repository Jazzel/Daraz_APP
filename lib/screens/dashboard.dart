import 'package:flutter/material.dart';
import "package:daraz_app/app.dart";

import "package:flutter_redux/flutter_redux.dart";

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

typedef FetchProduct = void Function();
typedef FetchShoppingCart = void Function();

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            InkWell(
              child: Text(
                "Hello User Dave !",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {},
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            StoreConnector<AppState, FetchProduct>(converter: (store) {
              return () async {
                store.dispatch(fetchProducts);
                Navigator.of(context).pushNamed(MyProductsRoute);
              };
            }, builder: (_, fetchProductsCallback) {
              return InkWell(
                child: Container(
                  color: Colors.black,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "My Profile",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Icon(Icons.supervised_user_circle, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                onTap: fetchProductsCallback,
              );
            }),
            Padding(padding: EdgeInsets.only(top: 10)),
            StoreConnector<AppState, FetchProduct>(converter: (store) {
              return () async {
                store.dispatch(fetchProducts);
                Navigator.of(context).pushNamed(MyProductsRoute);
              };
            }, builder: (_, fetchProductsCallback) {
              return InkWell(
                child: Container(
                  color: Colors.black,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Products List",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Icon(Icons.supervised_user_circle, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                onTap: fetchProductsCallback,
              );
            }),
            Padding(padding: EdgeInsets.only(top: 10)),
            StoreConnector<AppState, FetchShoppingCart>(converter: (store) {
              return () async {
                store.dispatch(fetchShoppingCart);
                Navigator.of(context).pushNamed(ShoppingCartRoute);
              };
            }, builder: (_, fetchProductsCallback) {
              return InkWell(
                child: Container(
                  color: Colors.black,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Shopping Cart",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Icon(Icons.supervised_user_circle, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                onTap: fetchProductsCallback,
              );
            }),
          ]),
        ),
      ),
    );
  }
}
