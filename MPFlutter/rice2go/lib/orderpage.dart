import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:rice2go/mainscreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rice2go/paymentpage.dart';

import 'package:rice2go/user.dart';
import 'package:random_string/random_string.dart';
import 'package:rice2go/order.dart';
import 'package:intl/intl.dart';

class OrderPage extends StatefulWidget {
  final User user;

  const OrderPage({Key key, this.user}) : super(key: key);
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  Order order;
  List _cartList = [];
  double screenHeight, screenWidth;
  double _totalprice = 0.0;
  double _totalquantity = 0.0;
  String pr = "";
  String qu = "";
  String sre = "";
  String re = "";
  String orderid = "";
  String dop = "";
  TextEditingController remarkController = new TextEditingController();
  TextEditingController ordernumController = new TextEditingController();
  int selectedRadio;
  
  @override
  void initState() {
    super.initState();
    _loadCart();
    selectedRadio = 0;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.brown),
          onPressed: () {
            Navigator.pop(
                context, MaterialPageRoute(builder: (content) => MainScreen()));
          },
        ),
        title: Text('Order', style: TextStyle(color: Colors.brown[700])),
        backgroundColor: Colors.yellow[50],
      ),
      backgroundColor: Colors.yellow[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: screenHeight * 0.38,
              child: Column(
                children: [
                  SizedBox(height: 15),
                  _cartList.isEmpty
                      ? Flexible(
                          child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/cart.png"))),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 200,
                                    height: 20,
                                    child: Text("Sorry, cart is empty for now.",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ))
                      : Flexible(
                          child: GridView.count(
                              crossAxisCount: 1,
                              childAspectRatio: 3.5 / 1,
                              children:
                                  List.generate(_cartList.length, (index) {
                                return SwipeActionCell(
                                    key: ValueKey(_cartList[index]),
                                    trailingActions: [
                                      SwipeAction(
                                          nestedAction: SwipeNestedAction(
                                            content: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: Colors.red,
                                              ),
                                              width: 160,
                                              height: 60,
                                              child: OverflowBox(
                                                maxWidth: double.infinity,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.delete,
                                                      color: Colors.white,
                                                    ),
                                                    Text('Confirm Delete',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          color: Colors.transparent,
                                          content: _getIconButton(
                                              Colors.red, Icons.delete),
                                          onTap: (handler) async {
                                            _deleteCart(index);
                                            _cartList.removeAt(index);

                                            setState(() {});
                                          }),
                                      SwipeAction(
                                          content: _getIconButton(
                                              Colors.orange, Icons.close),
                                          color: Colors.transparent,
                                          onTap: (handler) {
                                            handler(false);
                                          }),
                                    ],
                                    child: Padding(
                                        padding: EdgeInsets.all(2),
                                        child: Container(
                                            child: Card(
                                                child: Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    "https://hubbuddies.com/270552/rice2go/images/menu/${_cartList[index]['menuid']}.png",
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    new Transform.scale(
                                                        scale: 0.5,
                                                        child:
                                                            CircularProgressIndicator()),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        new Icon(
                                                  Icons.broken_image,
                                                  size: screenWidth / 3,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Container(
                                                height: 100,
                                                child: VerticalDivider(
                                                    color: Colors.grey)),
                                            Expanded(
                                              flex: 5,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        _cartList[index]
                                                            ['name'],
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        IconButton(
                                                          icon: Icon(
                                                              Icons.remove),
                                                          onPressed: () {
                                                            _modQty(index,
                                                                "minusqty");
                                                          },
                                                        ),
                                                        Text(_cartList[index]
                                                            ['quantity']),
                                                        IconButton(
                                                          icon: Icon(Icons.add),
                                                          onPressed: () {
                                                            _modQty(index,
                                                                "addqty");
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      "RM " +
                                                          (int.parse(_cartList[
                                                                          index]
                                                                      [
                                                                      'quantity']) *
                                                                  double.parse(
                                                                      _cartList[
                                                                              index]
                                                                          [
                                                                          'price']))
                                                              .toStringAsFixed(
                                                                  2),
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )))));
                              }))),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        width: screenWidth * 0.9,
                        height: 60,
                        child: TextField(
                            controller: remarkController,
                            decoration: InputDecoration(
                                hintText: "Enter remark here",
                                filled: true,
                                fillColor: Colors.brown[200],
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20),
                                )))),
                    Container(
                      width: 350,
                      child: Column(
                        children: [
                          ListTile(
                            leading: Text("TOTAL ITEM (S)",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            trailing: Text(
                                "" + _totalquantity.toStringAsFixed(0),
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                          ),
                          Container(
                              height: 20, child: Divider(color: Colors.grey)),
                          ListTile(
                            leading: Text("TOTAL PRICE (RM)",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            trailing: Text("" + _totalprice.toStringAsFixed(2),
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          height: 45,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Please select:",
                                  style: TextStyle(fontSize: 16)),
                              ButtonBar(
                                  alignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        Radio(
                                          value: 1,
                                          groupValue: selectedRadio,
                                          activeColor: Colors.brown,
                                          onChanged: (val) {
                                            setSelectedRadio(val);
                                          },
                                        ),
                                        Text("Dine-in",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Radio(
                                          value: 2,
                                          groupValue: selectedRadio,
                                          activeColor: Colors.brown,
                                          onChanged: (val) {
                                            setSelectedRadio(val);
                                          },
                                        ),
                                        Text("Take Away",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ]),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      child: Container(
                        width: 350,
                        height: 60.0,
                        decoration: BoxDecoration(
                            color: Colors.brown[400],
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Center(
                            child: Text("PLACE ORDER",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))),
                      ),
                      onTap: () {
                        _loadCart();
                        _updateorderno();

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (content) => PaymentPage(
                                      user: widget.user,
                                      order: order,
                                      orderid: orderid,
                                    )));
                      },
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      child: Container(
                        width: 350,
                        height: 60.0,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Center(
                            child: Text("CANCEL ORDER",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))),
                      ),
                      onTap: () {
                        _cancelOrder();
                        _cartList = [];
                        Navigator.pop(
                            context,
                            MaterialPageRoute(
                                builder: (content) => MainScreen()));
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
    if (selectedRadio == 1) {
      dop = "Dine-in";
    } else {
      dop = "Take Away";
    }
  }

  Widget _getIconButton(color, icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: color,
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }

  void _loadCart() {
    http.post(
        Uri.parse("https://hubbuddies.com/270552/rice2go/php/load_cart.php"),
        body: {}).then((response) {
      if (response.body == "nodata") {
        return;
      } else {
        var jsondata = json.decode(response.body);
        _cartList = jsondata["cart"];
        _totalprice = 0.0;
        _totalquantity = 0.0;
        for (int i = 0; i < _cartList.length; i++) {
          _totalprice = _totalprice +
              double.parse(_cartList[i]['price']) *
                  int.parse(_cartList[i]['quantity']);
          _totalquantity = _totalquantity + int.parse(_cartList[i]['quantity']);
        }
      }

      setState(() {
        pr = _totalprice.toString();
        qu = _totalquantity.toString();
      });
    });
  }

  Future<void> _modQty(int index, String selection) async {
    http.post(
        Uri.parse(
            "https://hubbuddies.com/270552/rice2go/php/updatecartqty.php"),
        body: {
          "selection": selection,
          "menuid": _cartList[index]['menuid'],
          "quantity": _cartList[index]['quantity']
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        _loadCart();
      } else {}
    });
  }

  Future<void> _deleteCart(int index) async {
    http.post(
        Uri.parse("https://hubbuddies.com/270552/rice2go/php/deletecart.php"),
        body: {"menuid": _cartList[index]['menuid']}).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.brown,
            textColor: Colors.white,
            fontSize: 16.0);
        _loadCart();
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.brown,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  String generateOrderid() {
    var now = new DateTime.now();
    var formatter = new DateFormat('ddMMyyyy-');
    orderid = widget.user.email.substring(1, 4) +
        "-" +
        formatter.format(now) +
        randomAlphaNumeric(6);
    return orderid;
  }

  void _updateorderno() {
    String orid = generateOrderid();
    sre = remarkController.text.toString();
    re = sre;
    order = Order(
      totalitem: qu,
      totalprice: pr,
      remark: re,
      diningoption: dop,
    );

    http.post(
        Uri.parse(
            "https://hubbuddies.com/270552/rice2go/php/updateorderno.php"),
        body: {
          "orderid": orid,
        }).then((response) {
      print(response.body);
      if (response.body == "failed") {
        print("Failed to update");
        return;
      } else {
        print("Success to update");
      }
    });
  }

  void _cancelOrder() {
    http.post(
        Uri.parse("https://hubbuddies.com/270552/rice2go/php/cancelorder.php"),
        body: {}).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Order deleted successfully.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.brown,
            textColor: Colors.white,
            fontSize: 16.0);
        _loadCart();
      } else {
        Fluttertoast.showToast(
            msg: "failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.brown,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }
}
