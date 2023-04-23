import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var amountController = TextEditingController();
  Razorpay _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    log('Payment Done');
    showAlertDialog(context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    log('Payment Failed');
    showAlertDialog(context, "Payment Failed", "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    log('Payment with external wallet');
    showAlertDialog(context, "External Wallet Selected", "${response.walletName}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Razorpay Pay'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: amountController,
              decoration: const InputDecoration(
                hintText: 'Enter your amount',
                border: OutlineInputBorder(borderSide: BorderSide()),
              ),
            ),
          ),
          
          ElevatedButton(
              onPressed: () {
                // Make payment
                var options = {
                  'key': 'rzp_test_i5UWAIC9SjXysl',
                  'amount': int.parse(amountController.text)*100, // amount will be multiple in 100, so its pay 500
                  'name': 'Dharmendra Pandey',
                  // 'order_id': 'order_52154873',
                  'description': 'Testing Mode',
                  'timeout': 300, // in seconds
                  'prefill': {
                    'contact': '9865421548',
                    'email': 'dharmendrapandey@gmail.com'
                  }
                };
                _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
                _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
                _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
                _razorpay.open(options);
              },
              child: const Text('Pay Amount')
          ),
        ],
      ),
    );
  }

  void showAlertDialog(BuildContext context, String title, String message){
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed:  () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}
