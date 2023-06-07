import 'package:daraz_app/app.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appState = AppState.initialState();
  await appState.loadShoppingCartFromSharedPreferences();

  final store = Store<AppState>(
    reducer,
    initialState: appState,
    middleware: [thunkMiddleware],
  );

  runApp(App(store: store));
}
