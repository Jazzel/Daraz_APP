import 'package:daraz_app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:random_string/random_string.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

typedef AddProduct = void Function();

class _AddProductState extends State<AddProductPage> {
  TextEditingController productName = new TextEditingController();
  TextEditingController productPicture = new TextEditingController();
  TextEditingController productPrice = new TextEditingController();
  TextEditingController productDescription = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    productPicture.text = "https://picsum.photos/250?image=11";
    productName.text = "TestProduct";
    productPrice.text = "100";
    productDescription.text = "Description";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Add Product"),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 100, horizontal: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    controller: productName,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      fillColor: Colors.lightBlueAccent,
                      labelText: 'Product Name',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    controller: productPrice,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      fillColor: Colors.lightBlueAccent,
                      labelText: 'Product Price',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    controller: productPicture,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      fillColor: Colors.lightBlueAccent,
                      labelText: 'Product Picture',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    controller: productDescription,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      fillColor: Colors.lightBlueAccent,
                      labelText: 'Product Description',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    maxLines: 3,
                  ),
                ),
              ),
              StoreConnector<AppState, AddProduct>(
                converter: (store) {
                  return () async {
                    // generate random string
                    String randomString = randomAlphaNumeric(10);

                    final Map product = {
                      "_id": randomString,
                      "name": productName.text.toString(),
                      "image": productPicture.text.toString(),
                      "price": int.parse(productPrice.text),
                      "description": productDescription.text.toString(),
                    };
                    store.dispatch(addProduct(product));
                    Navigator.of(context).pushNamed(MyProductsRoute);
                  };
                },
                builder: (_, addProductCallback) {
                  return InkWell(
                    child: Container(
                      color: Colors.red,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Save",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: addProductCallback,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
