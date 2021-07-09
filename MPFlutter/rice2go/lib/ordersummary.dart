import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:rice2go/mainscreen.dart';
import 'package:rice2go/orderdetails.dart';
import 'package:rice2go/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderSummary extends StatefulWidget {
  final User user;

  const OrderSummary({Key key, this.user}) : super(key: key);
  @override
  _OrderSummaryState createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  double screenHeight, screenWidth;

  // @override
  // void dispose() {
  //   _tabController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.yellow[50],
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.brown),
            onPressed: () {
              Navigator.pop(context,
                  MaterialPageRoute(builder: (content) => MainScreen()));
            },
          ),
          title:
              Text('Order Summary', style: TextStyle(color: Colors.brown[700])),
          backgroundColor: Colors.yellow[50],
          bottom: TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            controller: _tabController,
            indicatorWeight: 4,
            indicatorColor: Colors.brown,
            onTap: (index) {
              // _tabController.animateTo(index);
            },
            tabs: [
              Tab(
                  text: "Order",
                  icon: Icon(Icons.restaurant_outlined, color: Colors.brown)),
              Tab(
                  text: 'Completed',
                  icon: Icon(Icons.delivery_dining, color: Colors.brown)),
            ],
          ),
        ),
        body: TabBarView(
          physics: new NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            Page1(),
            Page2(),
          ],
        ),
      ),
    );
  }
}

class Page1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Page1State();
  }
}

class _Page1State extends State<Page1> with AutomaticKeepAliveClientMixin {
  List _orderlist;
  double screenHeight, screenWidth;
  String orderid;
  String totalprice;
  String totalquantity;
  String remark;
  String diningoption;
  @override
  void initState() {
    super.initState();
    _loadOrder("inprogress");
    print("Page 1 init");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(height: 20),
        _orderlist == null
            ? Flexible(
                child: Center(
                    child: ScalingText("Loading...",
                        style: TextStyle(fontSize: 16))))
            : Flexible(
                child: Center(
                  child: GridView.count(
                    crossAxisCount: 1,
                    childAspectRatio: 2.5 / 1,
                    children: List.generate(
                      _orderlist.length,
                      (index) {
                        return SwipeActionCell(
                          key: ValueKey(_orderlist[index]),
                          trailingActions: <SwipeAction>[
                            SwipeAction(
                                content: _getIconButton(
                                    Colors.orange, Icons.archive_rounded),
                                color: Colors.transparent,
                                onTap: (handler) async {
                                  _updatestatus(index);
                                  _orderlist.removeAt(index);
                                  setState(() {});
                                }),
                          ],
                          child: Column(
                            children: [
                              Container(
                                height: 160,
                                padding: EdgeInsets.all(0.1),
                                child: Container(
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                child: Row(
                                                  children: [
                                                    SizedBox(width: 5),
                                                    Text('ORDERID',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.brown)),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                child: Row(
                                                  children: [
                                                    SizedBox(width: 5),
                                                    Text(
                                                        _orderlist[index]
                                                                ['ordernumber']
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black)),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Container(
                                                child: Row(
                                                  children: [
                                                    SizedBox(width: 5),
                                                    Text('ORDERED ON',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.brown)),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                child: Row(
                                                  children: [
                                                    SizedBox(width: 5),
                                                    Text(
                                                        _orderlist[index]
                                                            ['orderdate'],
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black)),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 25),
                                              Row(
                                                children: [
                                                  SizedBox(width: 5),
                                                  Row(
                                                    children: [
                                                      Text(
                                                          'PAID BY: ' +
                                                              _orderlist[index][
                                                                      'paymentmethod']
                                                                  .toUpperCase(),
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .brown)),
                                                      SizedBox(width: 10),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                        width: 77,
                                                        height: 22,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color: Colors
                                                                .brown[100]),
                                                        child: Text(
                                                            _orderlist[index]
                                                                ['status'],
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  "TOTAL AMOUNT",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.brown),
                                                ),
                                                Text(
                                                    'RM ' +
                                                        _orderlist[index]
                                                            ['totalprice'],
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                                SizedBox(height: 38),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        orderid =
                                                            _orderlist[index]
                                                                ['ordernumber'];
                                                        totalprice =
                                                            _orderlist[index]
                                                                ['totalprice'];
                                                        totalquantity =
                                                            _orderlist[index][
                                                                'totalquantity'];
                                                        remark =
                                                            _orderlist[index]
                                                                ['remark'];
                                                        diningoption =
                                                            _orderlist[index][
                                                                'diningoption'];
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (content) =>
                                                                OrderDetails(
                                                              orderid: orderid,
                                                              totalprice:
                                                                  totalprice,
                                                              totalquantity:
                                                                  totalquantity,
                                                              remark: remark,
                                                              diningoption:
                                                                  diningoption,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        width: 30,
                                                        child: Icon(Icons
                                                            .arrow_forward_ios_outlined),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
      ],
    );
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
        color: Colors.black,
      ),
    );
  }

  void _updatestatus(index) {
    http.post(
        Uri.parse("https://hubbuddies.com/270552/rice2go/php/updatestatus.php"),
        body: {
          "ordernumber": _orderlist[index]['ordernumber'],
        }).then((response) {
      if (response.body == "success") {
        return;
      } else {
        // print(response.body);
      }
    });
  }

  void _loadOrder(String pageselect) {
    _orderlist = [];
    setState(() {});

    http.post(
        Uri.parse("https://hubbuddies.com/270552/rice2go/php/loadorder.php"),
        body: {
          "pageselect": pageselect,
        }).then((response) {
      if (response.body == "nodata") {
        // print(response.body);
        _orderlist = [];
        setState(() {});
        return;
      } else {
        var jsondata = json.decode(response.body);
        print(response.body);
        _orderlist = jsondata["order"];
        setState(() {});
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}

class Page2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Page2State();
  }
}

class _Page2State extends State<Page2> with AutomaticKeepAliveClientMixin {
  List _orderlist;
  double screenHeight, screenWidth;
  @override
  void initState() {
    super.initState();
    _loadOrder("completed");
    print("Page 2 init");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        TextButton(
          style: TextButton.styleFrom(
            primary: Colors.brown,
            textStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          onPressed: () {
            _clearSummary();
            _loadOrder("Completed");
          },
          child: Text('CLEAR ALL'),
        ),
      ]),
      _orderlist == null
          ? Flexible(
              child: Center(
                  child: ScalingText("Loading...",
                      style: TextStyle(fontSize: 16))))
          : Flexible(
              child: Center(
                  child: GridView.count(
                      crossAxisCount: 1,
                      childAspectRatio: 2.5 / 1,
                      children: List.generate(_orderlist.length, (index) {
                        return SwipeActionCell(
                            key: ValueKey(_orderlist[index]),
                            trailingActions: [
                              SwipeAction(
                                  color: Colors.transparent,
                                  content:
                                      _getIconButton(Colors.red, Icons.delete),
                                  onTap: (handler) async {
                                    _clearOrder(index);
                                    _orderlist.removeAt(index);

                                    setState(() {});
                                  }),
                            ],
                            child: Column(
                              children: [
                                Container(
                                    height: 160,
                                    padding: EdgeInsets.all(0.1),
                                    child: Container(
                                        child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      SizedBox(width: 5),
                                                      Text('ORDERID',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .brown)),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      SizedBox(width: 5),
                                                      Text(
                                                          _orderlist[index][
                                                                  'ordernumber']
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .black)),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      SizedBox(width: 5),
                                                      Text('ORDERED ON',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .brown)),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      SizedBox(width: 5),
                                                      Text(
                                                          _orderlist[index]
                                                              ['orderdate'],
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .black)),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 25),
                                                Row(
                                                  children: [
                                                    SizedBox(width: 5),
                                                    Row(
                                                      children: [
                                                        Text(
                                                            'PAID BY: ' +
                                                                _orderlist[index]
                                                                        [
                                                                        'paymentmethod']
                                                                    .toUpperCase(),
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .brown)),
                                                        SizedBox(width: 10),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                          width: 75,
                                                          height: 22,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .lightGreenAccent,
                                                                  width: 3),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              color: Colors
                                                                  .green[100]),
                                                          child: Text(
                                                              _orderlist[index]
                                                                  ['status'],
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .green)))
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text("TOTAL AMOUNT",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.brown)),
                                                  Text(
                                                      'RM ' +
                                                          _orderlist[index]
                                                              ['totalprice'],
                                                      style: TextStyle(
                                                          fontSize: 16)),
                                                  SizedBox(height: 25),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))),
                              ],
                            ));
                      })))),
    ]);
  }

  void _loadOrder(String pageselect) {
    _orderlist = [];
    setState(() {});

    http.post(
        Uri.parse("https://hubbuddies.com/270552/rice2go/php/loadorder.php"),
        body: {
          "pageselect": pageselect,
        }).then((response) {
      if (response.body == "nodata") {
        // print(response.body);
        _orderlist = [];
        setState(() {});
        return;
      } else {
        var jsondata = json.decode(response.body);
        // print(response.body);
        _orderlist = jsondata["order"];
        setState(() {});
      }
    });
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

  void _clearOrder(int index) {
    http.post(
        Uri.parse(
            "https://hubbuddies.com/270552/rice2go/php/delete_order_summary.php"),
        body: {
          "ordernumber": _orderlist[index]['ordernumber'],
        }).then((response) {
      if (response.body == "success") {
        setState(() {});
        print(response.body);

        return;
      } else {
        print(response.body);
      }
    });
  }

  void _clearSummary() {
    http.post(
        Uri.parse(
            "https://hubbuddies.com/270552/rice2go/php/clear_order_summary.php"),
        body: {}).then((response) {
      if (response.body == "success") {
        setState(() {});
        print(response.body);

        return;
      } else {
        print(response.body);
      }
    });
  }

  @override
  bool get wantKeepAlive => false;
}
