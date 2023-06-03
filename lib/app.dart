import 'package:daraz_app/screens/addProduct.dart';
import 'package:daraz_app/screens/checkout.dart';
import 'package:daraz_app/screens/shoppingcart.dart';
import 'package:daraz_app/widgets/navigator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daraz_app/screens/login.dart';
import 'package:daraz_app/screens/register.dart';
import 'package:daraz_app/screens/myproducts.dart';
import 'package:daraz_app/screens/addProduct.dart';
import 'package:daraz_app/screens/checkout.dart';

import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import "package:redux_thunk/redux_thunk.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';

const LoginRoute = "/";
const DashboardRoute = "/dashboard";
const RegisterRoute = "/register";
const MyProductsRoute = "/myproducts";
const AddProductRoute = "/addproduct";
const ShoppingCartRoute = "/shoppingcart";
const CheckoutRoute = "/checkout";

class AppState {
  final List _products;

  List get products => _products;

  AppState(this._products);

  AppState.initialState() : _products = [];
}

class FetchProductsAction {
  final List _products;

  List get products => _products;

  FetchProductsAction(this._products);
}

class AddProductsAction {
  final Map _product;

  Map get product => _product;

  AddProductsAction(this._product);
}

class DeleteProductsAction {
  final String _id;

  String get id => _id;

  DeleteProductsAction(this._id);
}

class UpdateProductAction {
  final Map _product;

  Map get product => _product;

  UpdateProductAction(this._product);
}

AppState reducer(AppState prev, dynamic action) {
  if (action is FetchProductsAction) {
    return AppState(action.products);
  } else if (action is AddProductsAction) {
    final products = prev.products.toList();
    products.add(action.product);
    return AppState(products);
  } else if (action is DeleteProductsAction) {
    final products =
        prev.products.where((product) => product["_id"] != action.id).toList();
    return AppState(products);
  } else if (action is UpdateProductAction) {
    final products = prev.products.map((product) {
      if (product["_id"] == action.product["_id"]) {
        return action.product;
      } else {
        return product;
      }
    }).toList();
    return AppState(products);
  } else {
    return prev;
  }
}

Future<List?> fetchProductsfromAPI() async {
  // url request
  // get data from url
  var url = Uri.parse('http://localhost:5000/api/products');

  var response = await http.get(url);

  if (response.statusCode == 200) {
    // Request successful
    List<dynamic> data = jsonDecode(response.body) as List;
    return data;
  } else {
    // Request failed
    print('Request failed with status: ${response.statusCode}.');
    return null;
  }
}

Future<Map> addProductAPI(product) async {
  var url = Uri.parse('http://localhost:5000/api/products');

  var response = await http.post(url, body: jsonEncode(product), headers: {
    'Content-Type': 'application/json',
  });

  if (response.statusCode == 200) {
    // Request successful
    print('Response body: ${response.body}');
  } else {
    // Request failed
    print('Request failed with status: ${response.statusCode}.');
  }
  return product;
}

Future<bool> deleteProductAPI(String id) async {
  var url = Uri.parse('http://localhost:5000/api/products/' + id);
  print(url);

  var response = await http.delete(url);

  if (response.statusCode == 200) {
    // Request successful
    print('Response body: ${response.body}');
  } else {
    // Request failed
    print('Request failed with status: ${response.statusCode}.');
  }

  return true;
}

Future<Map> updateProductAPI(product) async {
  var url = Uri.parse('http://localhost:5000/api/products/' + product["_id"]);

  var response = await http.put(url, body: jsonEncode(product), headers: {
    'Content-Type': 'application/json',
  });

  if (response.statusCode == 200) {
    // Request successful
    print('Response body: ${response.body}');
  } else {
    // Request failed
    print('Request failed with status: ${response.statusCode}.');
  }
  return product;
}

ThunkAction<AppState> addProduct(Map product) {
  return (Store<AppState> store) async {
    final addedProduct = await addProductAPI(product);
    store.dispatch(AddProductsAction(addedProduct));

    final products = await fetchProductsfromAPI();
    store.dispatch(FetchProductsAction(products!));
  };
}

ThunkAction<AppState> fetchProducts = (
  Store<AppState> store,
) async {
  final products = await fetchProductsfromAPI();
  store.dispatch(FetchProductsAction(products!));
};

ThunkAction<AppState> deleteProduct(String id) {
  print(id);
  return (Store<AppState> store) async {
    final deleteProduct = await deleteProductAPI(id);
    store.dispatch(DeleteProductsAction(id));
  };
}

ThunkAction<AppState> updateProduct(Map product) {
  return (Store<AppState> store) async {
    final updatedProduct = await updateProductAPI(product);
    store.dispatch(UpdateProductAction(updatedProduct));
  };
}

class App extends StatelessWidget {
  final store = Store<AppState>(reducer,
      initialState: AppState.initialState(), middleware: [thunkMiddleware]);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: GetMaterialApp(
        onGenerateRoute: _routes(),
        darkTheme: ThemeData.dark().copyWith(primaryColor: Colors.black),
        themeMode: ThemeMode.light,
      ),
    );
  }

  RouteFactory _routes() {
    return (settings) {
      // final Map<String, dynamic> arguments =
      //     settings.arguments as Map<String, dynamic>;

      Widget screen;
      switch (settings.name) {
        case LoginRoute:
          screen = LoginPage();
          break;
        case DashboardRoute:
          screen = DashboardPage();
          break;
        case RegisterRoute:
          screen = RegisterPage();
          break;
        case MyProductsRoute:
          screen = MyProductsPage();
          break;
        case AddProductRoute:
          screen = AddProductPage();
          break;
        case ShoppingCartRoute:
          screen = ShoppingCartPage();
          break;
        case CheckoutRoute:
          screen = CheckoutPage();
          break;
        default:
          return null;
      }
      return MaterialPageRoute(builder: (BuildContext context) => screen);
    };
  }
}
