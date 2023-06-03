import 'dart:html';
import 'package:flutter/material.dart';
import 'package:daraz_app/screens/payment.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutPage> {
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expMonthController = TextEditingController();
  final TextEditingController expYearController = TextEditingController();
  final TextEditingController cvcController = TextEditingController();

  void pay() {
    final cardNumber = cardNumberController.text;
    final expMonth = expMonthController.text;
    final expYear = expYearController.text;
    final cvc = cvcController.text;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentSuccessPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              child: TextField(
                controller: cardNumberController,
                decoration: InputDecoration(
                  labelText: 'Card Number',
                ),
              ),
            ),
            Container(
              width: 300,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: expMonthController,
                      decoration: InputDecoration(
                        labelText: 'Expiry Month',
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: expYearController,
                      decoration: InputDecoration(
                        labelText: 'Expiry Year',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 300,
              child: TextField(
                controller: cvcController,
                decoration: InputDecoration(
                  labelText: 'CVC',
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: pay,
              child: Text('Pay Now'),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
