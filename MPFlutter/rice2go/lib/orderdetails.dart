import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rice2go/ordersummary.dart';

class OrderDetails extends StatefulWidget {
  final String orderid;
  final String totalprice;
  final String totalquantity;
  final String remark;
  final String diningoption;
  const OrderDetails(
      {Key key,
      this.orderid,
      this.totalprice,
      this.totalquantity,
      this.remark,
      this.diningoption})
      : super(key: key);
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  List _orderList = [];
  double screenHeight, screenWidth;
  bool _takeaway = false;
  bool _dinein = false;
  String _orderid = "";
  @override
  void initState() {
    super.initState();
    _orderid = widget.orderid;
    _loadOrderList(_orderid);
    if (widget.diningoption == "Take Away") {
      _takeaway = true;
      _dinein = false;
    } else if (widget.diningoption == "Dine-in") {
      _dinein = true;
      _takeaway = false;
    }
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
            Navigator.pop(context,
                MaterialPageRoute(builder: (content) => OrderSummary()));
          },
        ),
        title: Text('Order', style: TextStyle(color: Colors.brown[700])),
        backgroundColor: Colors.yellow[50],
      ),
      backgroundColor: Colors.orange[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: screenHeight * 0.48,
              child: Column(
                children: [
                  Stack(children: [
                    Row(
                      children: [
                        Container(
                          height: 40,
                          width: 300,
                          child: Text(
                              "OrderID: # " + widget.orderid.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.brown,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: _takeaway,
                      child: Container(
                        child: Positioned(
                          right: 60,
                          child: Container(
                              height: 19,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.yellow[50]),
                              child: Text(widget.diningoption,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown))),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _dinein,
                      child: Container(
                        child: Positioned(
                          right: 80,
                          child: Container(
                              height: 19,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.yellow[50]),
                              child: Text(widget.diningoption,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown))),
                        ),
                      ),
                    ),
                  ]),
                  Flexible(
                      child: GridView.count(
                          crossAxisCount: 1,
                          childAspectRatio: 3.3 / 1,
                          children: List.generate(_orderList.length, (index) {
                            return Padding(
                                padding: EdgeInsets.all(0.1),
                                child: Container(
                                    color: Colors.white,
                                    child: Card(
                                        elevation: 0.5,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(height: 5),
                                                  Container(
                                                    height: 105,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors
                                                                .transparent),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10.0)),
                                                        image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(
                                                              "https://hubbuddies.com/270552/rice2go/images/menu/${_orderList[index]['ordermenuid']}.png"),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                                height: 100,
                                                child: VerticalDivider(
                                                    color: Colors.grey)),
                                            Expanded(
                                              flex: 6,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            _orderList[index]
                                                                ['ordername'],
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(
                                                          "RM " +
                                                              (int.parse(_orderList[
                                                                              index]
                                                                          [
                                                                          'orderquantity']) *
                                                                      double.parse(
                                                                          _orderList[index]
                                                                              [
                                                                              'orderprice']))
                                                                  .toStringAsFixed(
                                                                      2),
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 22),
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            "x " +
                                                                _orderList[
                                                                        index][
                                                                    'orderquantity'],
                                                            style: TextStyle(
                                                                fontSize: 16)),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ))));
                          }))),
                ],
              ),
            ),
            SizedBox(height: 15),
            Container(
              width: 350,
              height: 90,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.brown, width: 3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("REMARK:\n",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown)),
                  Text(widget.remark.toUpperCase(),
                      style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
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
                    trailing: Text(widget.totalquantity,
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                  ),
                  Container(height: 20, child: Divider(color: Colors.grey)),
                  ListTile(
                    leading: Text("TOTAL PRICE (RM)",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    trailing: Text(widget.totalprice,
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loadOrderList(String orderid) {
    http.post(
        Uri.parse(
            "https://hubbuddies.com/270552/rice2go/php/loadorderdetail.php"),
        body: {
          "orderid": orderid,
        }).then((response) {
      if (response.body == "nodata") {
        // print(response.body);
        _orderList = [];
        setState(() {});
        return;
      } else {
        var jsondata = json.decode(response.body);
        print(response.body);
        _orderList = jsondata["orderdata"];
        setState(() {});
      }
    });
  }
}
