import 'package:daraz_app/screens/addProduct.dart';
import 'package:daraz_app/screens/checkout.dart';
import 'package:daraz_app/screens/home.dart';
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

import 'package:shared_preferences/shared_preferences.dart';

const LoginRoute = "/";
const DashboardRoute = "/dashboard";
const RegisterRoute = "/register";
const MyProductsRoute = "/myproducts";
const AddProductRoute = "/addproduct";
const ShoppingCartRoute = "/shoppingcart";
const CheckoutRoute = "/checkout";
const HomeRoute = "/home";

class CartItem {
  final String name;
  int quantity;
  final double price;

  CartItem({required this.name, required this.quantity, required this.price});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      name: json['name'],
      quantity: json['quantity'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() =>
      {"name": name, "quantity": quantity, "price": price};
}

class AppState {
  List _products;
  List<CartItem> _shoppingcart;

  List get products => _products;
  List<CartItem> get shoppingcart => _shoppingcart;

  AppState(this._products, this._shoppingcart);

  AppState.initialState()
      : _products = [],
        _shoppingcart = [];

  Future<void> loadShoppingCartFromSharedPreferences() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String>? cartData = prefs.getStringList('shoppingCart');

      if (cartData != null) {
        _shoppingcart = cartData
            .map((data) => CartItem.fromJson(data as Map<String, dynamic>))
            .toList() as List<CartItem>;
      }
    } catch (e) {
      print("Failed to load cart !");
    }
  }
}

Future<void> saveShoppingCartToSharedPreferences(List<CartItem> cart) async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> cartData =
        cart.map((item) => item.toJson()).toList() as List<String>;

    await prefs.setStringList('shoppingCart', cartData);
  } catch (e) {
    print("Failed to save shooping cart");
  }
}

class FetchShoppingCartAction {
  final List<CartItem> _shoppingcart;

  List<CartItem> get shoppingcart => _shoppingcart;

  FetchShoppingCartAction(this._shoppingcart);
}

class AddCartItemAction {
  final CartItem _product;

  CartItem get product => _product;

  AddCartItemAction(this._product);
}

class RemoveCartItemAction {
  final CartItem _product;

  CartItem get product => _product;

  RemoveCartItemAction(this._product);
}

class IncrementCartItemAction {
  final CartItem _product;

  CartItem get product => _product;

  IncrementCartItemAction(this._product);
}

class DecrementCartItemAction {
  final CartItem _product;

  CartItem get product => _product;

  DecrementCartItemAction(this._product);
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
    return AppState(action.products, prev.shoppingcart);
  } else if (action is AddProductsAction) {
    final products = prev.products.toList();
    products.add(action.product);
    return AppState(products, prev.shoppingcart);
  } else if (action is DeleteProductsAction) {
    final products =
        prev.products.where((product) => product["_id"] != action.id).toList();
    return AppState(products, prev.shoppingcart);
  } else if (action is UpdateProductAction) {
    final products = prev.products.map((product) {
      if (product["_id"] == action.product["_id"]) {
        return action.product;
      } else {
        return product;
      }
    }).toList();

    return AppState(products, prev.shoppingcart);
  } else if (action is FetchShoppingCartAction) {
    return AppState(prev._products, action.shoppingcart);
  } else if (action is AddCartItemAction) {
    List<CartItem> cart = prev._shoppingcart;
    bool add = true;
    for (CartItem cartItem in cart) {
      if (cartItem.name == action._product.name) {
        cartItem.quantity++;
        add = false;
        break;
      }
    }
    if (add) {
      cart.add(action._product);
    }
    saveShoppingCartToSharedPreferences(cart);
    return AppState(prev._products, cart);
  } else if (action is RemoveCartItemAction) {
    List<CartItem> cart = prev._shoppingcart;
    cart.remove(action._product);
    saveShoppingCartToSharedPreferences(cart);

    return AppState(prev._products, cart);
  } else if (action is IncrementCartItemAction) {
    List<CartItem> cart = prev._shoppingcart;
    cart[cart.indexOf(action._product)].quantity++;
    saveShoppingCartToSharedPreferences(cart);

    return AppState(prev._products, cart);
  } else if (action is DecrementCartItemAction) {
    List<CartItem> cart = prev._shoppingcart;
    if (cart[cart.indexOf(action._product)].quantity > 1) {
      cart[cart.indexOf(action._product)].quantity--;
    }
    saveShoppingCartToSharedPreferences(cart);

    return AppState(prev._products, cart);
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

ThunkAction<AppState> fetchShoppingCart = (
  Store<AppState> store,
) async {
  List<CartItem> cartItems = [
    CartItem(name: 'Item 1', quantity: 1, price: 10.0),
    CartItem(name: 'Item 2', quantity: 2, price: 15.0),
    CartItem(name: 'Item 3', quantity: 3, price: 8.0),
  ];
  store.dispatch(FetchShoppingCartAction(cartItems));
};

ThunkAction<AppState> addItemInShoppingCart(CartItem cartItem) {
  return (Store<AppState> store) async {
    store.dispatch(AddCartItemAction(cartItem));
  };
}

ThunkAction<AppState> removeItemFromShoppingCart(CartItem cartItem) {
  return (Store<AppState> store) async {
    store.dispatch(RemoveCartItemAction(cartItem));
  };
}

ThunkAction<AppState> incrementItemInShoppingCart(CartItem cartItem) {
  return (Store<AppState> store) async {
    store.dispatch(IncrementCartItemAction(cartItem));
  };
}

ThunkAction<AppState> decrementItemInShoppingCart(CartItem cartItem) {
  return (Store<AppState> store) async {
    store.dispatch(DecrementCartItemAction(cartItem));
  };
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
  final Store<AppState> store;

  App({required this.store});

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
        case HomeRoute:
          screen = HomePage();
          break;
        default:
          return null;
      }
      return MaterialPageRoute(builder: (BuildContext context) => screen);
    };
  }
}
