import 'package:flutter/material.dart';
import 'package:rice2go/mainscreen.dart';

import 'package:http/http.dart' as http;
import 'package:rice2go/user.dart';
import 'package:rice2go/order.dart';

class PaymentPage extends StatefulWidget {
  final Order order;
  final User user;
  final String orderid;

  const PaymentPage({Key key, this.user, this.order, this.orderid})
      : super(key: key);
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  List<bool> isSelected = [true, false, false];
  double _cr = 0.00;
  double _totalprice = 0.0;
  double _cashrefund = 0.0;
  double _totalquantity = 0.0;
  String _pm = "Cash";
  String _re = "";
  String _orderid = "";
  String status = "In Progress";
  String dop = "Dine-in";
  int _value;
  int _wvalue;
  bool _cash = true;
  bool _card = false;
  bool _wallet = false;
  TextEditingController cashreceivedController = new TextEditingController();
  TextEditingController cardnameController = new TextEditingController();
  TextEditingController cardnumController = new TextEditingController();

  @override
  initState() {
    super.initState();
    _totalprice = double.parse(widget.order.totalprice);
    _totalquantity = double.parse(widget.order.totalitem);
    _re = widget.order.remark;
    _orderid = widget.orderid;
    dop = widget.order.diningoption;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text('Select Payment Method',
            style: TextStyle(color: Colors.brown[700])),
        backgroundColor: Colors.yellow[50],
      ),
      backgroundColor: Colors.yellow[50],
      body: Center(
        child: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: ToggleButtons(
                      isSelected: isSelected,
                      selectedColor: Colors.brown[100],
                      color: Colors.black,
                      fillColor: Colors.brown[400],
                      borderRadius: BorderRadius.circular(15.0),
                      children: [
                        Container(
                          width: 130,
                          height: 110,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.attach_money_rounded,
                                size: 46,
                              ),
                              SizedBox(height: 10),
                              Text("Cash"),
                            ],
                          ),
                        ),
                        Container(
                          width: 130,
                          height: 110,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.credit_card,
                                size: 46,
                              ),
                              SizedBox(height: 10),
                              Text("Credit/Debit Card"),
                            ],
                          ),
                        ),
                        Container(
                          width: 130,
                          height: 110,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.account_balance_wallet_rounded,
                                size: 46,
                              ),
                              SizedBox(height: 10),
                              Text("E-Wallet"),
                            ],
                          ),
                        ),
                      ],
                      onPressed: (int newIndex) {
                        setState(() {
                          for (int index = 0;
                              index < isSelected.length;
                              index++) {
                            if (index == newIndex) {
                              isSelected[index] = true;
                            } else {
                              isSelected[index] = false;
                            }
                          }
                          if (newIndex == 0) {
                            _cash = true;
                            _card = false;
                            _wallet = false;
                            _pm = "Cash";
                          } else if (newIndex == 1) {
                            _cash = false;
                            _card = true;
                            _wallet = false;
                            if (_value == 0) {
                              _pm = "Debit Card";
                            } else {
                              _pm = "Credit Card";
                            }
                          } else if (newIndex == 2) {
                            _cash = false;
                            _card = false;
                            _wallet = true;
                            if (_wvalue == 0) {
                              _pm = "TouchNGo";
                            } else if (_wvalue == 1) {
                              _pm = "Boost";
                            } else {
                              _pm = "GrabPay";
                            }
                          }
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Visibility(
                    visible: _cash,
                    child: Container(
                        width: 400,
                        height: 65,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          color: Colors.brown[200],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 220,
                              child: Text("TOTAL AMOUNT RECEIVED (RM):",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Container(
                                width: 100,
                                child: TextField(
                                  controller: cashreceivedController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Enter Amount',
                                    hintText: 'RM',
                                    border: InputBorder.none,
                                  ),
                                )),
                            Container(
                              width: 30,
                              child: IconButton(
                                  icon: Icon(Icons.money_rounded),
                                  onPressed: () {
                                    loadchange();
                                  }),
                            )
                          ],
                        )),
                  ),
                  SizedBox(height: 20),
                  Visibility(
                    visible: _cash,
                    child: Container(
                      width: 400,
                      decoration: BoxDecoration(
                        // border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        color: Colors.brown[200],
                      ),
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
                              height: 20, child: Divider(color: Colors.brown)),
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
                          ),
                          Container(
                              height: 20, child: Divider(color: Colors.brown)),
                          ListTile(
                            leading: Text("TOTAL AMOUNT RECEIVED (RM)",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            trailing: Text("" + _cr.toStringAsFixed(2),
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                          ),
                          Container(
                              height: 20, child: Divider(color: Colors.brown)),
                          ListTile(
                            leading: Text("TOTAL CHANGE AMOUNT (RM)",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            trailing: Text("" + _cashrefund.toStringAsFixed(2),
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(visible: _cash, child: SizedBox(height: 30)),
                  Visibility(
                    visible: _cash,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 180,
                            child: TextButton(
                              child: Text("CANCEL",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  )),
                              onPressed: () {
                                Navigator.pop(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) => MainScreen()));
                              },
                            ),
                          ),
                          Container(
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              color: Colors.brown[400],
                            ),
                            child: TextButton(
                              child: Text("PAY",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  )),
                              onPressed: () {
                                submit();
                                Navigator.pop(context);
                                Navigator.pop(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) => MainScreen()));
                              },
                            ),
                          ),
                        ]),
                  ),
                  Visibility(
                      visible: _card,
                      child: Column(
                        children: [
                          Container(
                              width: 400,
                              height: 65,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                color: Colors.brown[200],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: 250,
                                    child: Text("TOTAL AMOUNT RECEIVED (RM):",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                      width: 100,
                                      child: TextField(
                                        controller: cashreceivedController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'Enter Amount',
                                          hintText: 'RM',
                                          border: InputBorder.none,
                                        ),
                                      )),
                                ],
                              )),
                          SizedBox(height: 30),
                          Row(
                            children: [
                              SizedBox(width: 5),
                              Container(
                                  child: Text("CARD TYPE",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold))),
                            ],
                          ),
                          Divider(height: 20, color: Colors.brown),
                          Row(
                            children: [
                              Container(
                                  width: 395,
                                  height: 57,
                                  padding: EdgeInsets.only(left: 10, right: 5),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.brown, width: 2),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 30,
                                          child: Icon(Icons.credit_card_sharp,
                                              color: Colors.brown)),
                                      SizedBox(width: 10),
                                      Container(
                                        width: 330,
                                        child: DropdownButton(
                                            hint: Row(
                                              children: [
                                                Container(
                                                  width: 200,
                                                  child: Text(
                                                      "Select Card Type",
                                                      style: TextStyle(
                                                          fontSize: 16)),
                                                ),
                                              ],
                                            ),
                                            dropdownColor: Colors.brown[200],
                                            icon: Icon(Icons.arrow_drop_down),
                                            iconSize: 36,
                                            isExpanded: true,
                                            underline: SizedBox(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12),
                                            value: _value,
                                            items: [
                                              DropdownMenuItem(
                                                child: Text('Debit Card',
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                                value: 0,
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Credit Card',
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                                value: 1,
                                              ),
                                            ],
                                            onChanged: (value) {
                                              setState(() {
                                                _value = value;
                                              });
                                            }),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              SizedBox(width: 5),
                              Container(
                                  child: Text("CARDHOLDER NAME",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold))),
                            ],
                          ),
                          Divider(height: 20, color: Colors.brown),
                          Row(children: [
                            Container(
                                width: 395,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  color: Colors.brown[200],
                                ),
                                child: TextField(
                                  controller: cardnameController,
                                  decoration: InputDecoration(
                                    fillColor: Colors.brown,
                                    labelText: 'Enter Cardholder Name',
                                    prefixIcon: Icon(Icons.account_box_outlined,
                                        color: Colors.black),
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      borderSide: BorderSide(
                                          color: Colors.brown, width: 2),
                                    ),
                                  ),
                                )),
                          ]),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              SizedBox(width: 5),
                              Container(
                                  child: Text("CARD NUMBER",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold))),
                            ],
                          ),
                          Divider(height: 20, color: Colors.brown),
                          Row(
                            children: [
                              Container(
                                  width: 395,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    color: Colors.brown[200],
                                  ),
                                  child: TextField(
                                    controller: cardnumController,
                                    decoration: InputDecoration(
                                      fillColor: Colors.brown,
                                      labelText: 'Enter Card No.',
                                      prefixIcon: Icon(
                                          Icons.credit_card_outlined,
                                          color: Colors.black),
                                      border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                        borderSide: BorderSide(
                                            color: Colors.brown, width: 2),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                          SizedBox(height: 30),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 180,
                                  child: TextButton(
                                    child: Text("CANCEL",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        )),
                                    onPressed: () {
                                      Navigator.pop(
                                          context,
                                          MaterialPageRoute(
                                              builder: (content) =>
                                                  MainScreen()));
                                    },
                                  ),
                                ),
                                Container(
                                  width: 200,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    color: Colors.brown[400],
                                  ),
                                  child: TextButton(
                                    child: Text("SUBMIT",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        )),
                                    onPressed: () {
                                      submit();
                                      Navigator.pop(context);
                                      Navigator.pop(
                                          context,
                                          MaterialPageRoute(
                                              builder: (content) =>
                                                  MainScreen()));
                                    },
                                  ),
                                ),
                              ]),
                        ],
                      )),
                  Visibility(
                      visible: _wallet,
                      child: Column(
                        children: [
                          Container(
                              width: 400,
                              height: 65,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                color: Colors.brown[200],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: 250,
                                    child: Text("TOTAL AMOUNT RECEIVED (RM):",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                      width: 100,
                                      child: TextField(
                                        controller: cashreceivedController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'Enter Amount',
                                          hintText: 'RM',
                                          border: InputBorder.none,
                                        ),
                                      )),
                                ],
                              )),
                          SizedBox(height: 30),
                          Row(
                            children: [
                              SizedBox(width: 5),
                              Container(
                                  child: Text("E-WALLET TYPE",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold))),
                            ],
                          ),
                          Divider(height: 20, color: Colors.brown),
                          Row(
                            children: [
                              Container(
                                  width: 395,
                                  height: 57,
                                  padding: EdgeInsets.only(left: 10, right: 5),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.brown, width: 2),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 30,
                                          child: Icon(
                                              Icons
                                                  .account_balance_wallet_outlined,
                                              color: Colors.brown)),
                                      SizedBox(width: 10),
                                      Container(
                                        width: 330,
                                        child: DropdownButton(
                                            hint: Row(
                                              children: [
                                                Container(
                                                  width: 200,
                                                  child: Text(
                                                      "Select E-Wallet Type",
                                                      style: TextStyle(
                                                          fontSize: 16)),
                                                ),
                                              ],
                                            ),
                                            dropdownColor: Colors.brown[200],
                                            icon: Icon(Icons.arrow_drop_down),
                                            iconSize: 36,
                                            isExpanded: true,
                                            underline: SizedBox(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12),
                                            value: _wvalue,
                                            items: [
                                              DropdownMenuItem(
                                                child: Text('TouchNGo',
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                                value: 0,
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Boost',
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                                value: 1,
                                              ),
                                              DropdownMenuItem(
                                                child: Text('GrabPay',
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                                value: 2,
                                              ),
                                            ],
                                            onChanged: (value) {
                                              setState(() {
                                                _wvalue = value;
                                              });
                                            }),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                          SizedBox(height: 50),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 180,
                                  child: TextButton(
                                    child: Text("CANCEL",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        )),
                                    onPressed: () {
                                      Navigator.pop(
                                          context,
                                          MaterialPageRoute(
                                              builder: (content) =>
                                                  MainScreen()));
                                    },
                                  ),
                                ),
                                Container(
                                  width: 200,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    color: Colors.brown[400],
                                  ),
                                  child: TextButton(
                                    child: Text("SUBMIT",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        )),
                                    onPressed: () {
                                      submit();
                                      Navigator.pop(context);
                                      Navigator.pop(
                                          context,
                                          MaterialPageRoute(
                                              builder: (content) =>
                                                  MainScreen()));
                                    },
                                  ),
                                ),
                              ]),
                        ],
                      )),
                  SizedBox(height: 160),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  loadchange() {
    String sdr = cashreceivedController.text.toString();
    _cr = double.parse(sdr);
    double cr = double.parse(sdr);
    _cashrefund = (cr - _totalprice);
    setState(() {});
  }

  void submit() {
    print("All");
    print("Result of Payment Page:");
    print(_orderid);
    print(_totalquantity);
    print(_totalprice);
    print(_re);
    print(_pm);
    print(status);
    print(dop);
    print("All");
    http.post(
        Uri.parse("https://hubbuddies.com/270552/rice2go/php/addorder.php"),
        body: {
          "on": _orderid,
          "tp": _totalprice.toString(),
          "tq": _totalquantity.toString(),
          "pm": _pm,
          "re": _re,
          "status": status,
          "dop": dop,
        }).then((response) {
      if (response.body == "success") {
        print("All success");
      } else {
        print("All " + response.body);
      }
    });
  }
}
