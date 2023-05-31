import 'package:flutter/material.dart';
import "package:daraz_app/app.dart";

import "package:flutter_redux/flutter_redux.dart";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

typedef FetchProduct = void Function();

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BizzHome'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Column(children: [
          InkWell(
            child: Text("This is a button"),
            onTap: () {},
          ),
          Text("This is demo text"),
          Padding(padding: EdgeInsets.only(top: 20)),
          StoreConnector<AppState, FetchProduct>(converter: (store) {
            return () async {
              store.dispatch(fetchProducts);
              Navigator.of(context).pushNamed(MyProductsRoute);
            };
          }, builder: (_, fetchProductsCallback) {
            return InkWell(
              child: Container(
                color: Colors.red,
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
          Row(
            children: [Text("This is demo text")],
          )
        ]),
      ),
    );
  }
}
