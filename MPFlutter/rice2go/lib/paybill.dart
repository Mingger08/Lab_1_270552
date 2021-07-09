import 'dart:async';
import 'package:rice2go/mainscreen.dart';
import 'package:rice2go/user.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

class PayBill extends StatefulWidget {
  final User user;
  final String amount, accnum;
  PayBill({this.user, this.amount, this.accnum});

  @override
  _PayBillState createState() => _PayBillState();
}

class _PayBillState extends State<PayBill> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('PAYMENT', style: TextStyle(color: Colors.brown)),
          backgroundColor: Colors.yellow[50],
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.brown),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.home, color: Colors.brown),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => MainScreen(user: widget.user)));
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: WebView(
                initialUrl:
                    'https://hubbuddies.com/270552/rice2go/php/payment.php?email=' +
                        widget.user.email +
                        '&phone=' +
                        widget.user.phone +
                        '&name=' +
                        widget.user.name.toUpperCase() +
                        '&amount=' +
                        widget.amount +
                        '&accnum=' +
                        widget.accnum,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
              ),
            )
          ],
        ));
  }
}
