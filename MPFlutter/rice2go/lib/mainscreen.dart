import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progress_indicators/progress_indicators.dart';
import 'package:rice2go/food.dart';
import 'package:rice2go/homedrawer.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rice2go/menudetails.dart';
import 'package:rice2go/orderpage.dart';

import 'package:rice2go/user.dart';

class MainScreen extends StatefulWidget {
  final User user;
  final Food food;

  const MainScreen({Key key, this.user, this.food}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var inputText = "";

  String email = "";

  double screenHeight, screenWidth;

  bool isselected1 = true;
  bool isselected2 = false;
  bool isselected3 = false;
  bool isselected4 = false;
  bool issearch = false;
  List _menuList;
  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMenu("all");
  
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text('Rice2Go', style: TextStyle(color: Colors.brown[700])),
        backgroundColor: Colors.yellow[50],
        iconTheme: IconThemeData(color: Colors.brown[700]),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: Colors.brown),
            onPressed: () {
              _loadMenu('all');
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, color: Colors.brown[700]),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OrderPage(user: widget.user)));
            },
          ),
        ],
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.yellow[50],
        ),
        child: HomeDrawer(user: widget.user),
      ),
      body: Center(
        child: Column(children: [
          Row(
            children: [
              Container(
                  width: screenWidth * 0.925,
                  child: TextField(
                      controller: searchController,
                      onChanged: (text) {
                        setState(() {
                          inputText = text;
                        });
                      },
                      decoration: InputDecoration(
                          prefixIcon: hidingIcon2(),
                          suffixIcon: hidingIcon(),
                          hintText: "Search Food/Beverages",
                          filled: true,
                          fillColor: Colors.brown[200],
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20),
                          )))),
              Container(
                width: screenWidth * 0.075,
                child: IconButton(
                  icon: Icon(Icons.search_outlined),
                  color: Colors.black,
                  onPressed: () {
                    _loadMenu(searchController.text);
                    isselected1 = true;
                    isselected2 = false;
                    isselected3 = false;
                    isselected4 = false;
                  },
                ),
              ),
            ],
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                      primary: isselected1 ? Colors.brown[800] : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _loadMenu("all");
                      isselected1 = true;
                      isselected2 = false;
                      isselected3 = false;
                      isselected4 = false;
                    });
                  },
                  child: Text(
                    "All",
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      primary: isselected2 ? Colors.brown[800] : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _loadMenu("food");
                      isselected1 = false;
                      isselected2 = true;
                      isselected3 = false;
                      isselected4 = false;
                    });
                  },
                  child: Text(
                    "Food",
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      primary: isselected3 ? Colors.brown[800] : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _loadMenu("bev");
                      isselected1 = false;
                      isselected2 = false;
                      isselected3 = true;
                      isselected4 = false;
                    });
                  },
                  child: Text(
                    "Beverages",
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      primary: isselected4 ? Colors.brown[800] : Colors.grey),
                  onPressed: () {
                    setState(() {
                      _loadMenu("spec");
                      isselected1 = false;
                      isselected2 = false;
                      isselected3 = false;
                      isselected4 = true;
                    });
                  },
                  child: Text(
                    "Weekly Special Menu",
                  ),
                ),
              ],
            ),
          ),
          _menuList == null
              ? Flexible(
                  child: Center(
                      child: ScalingText("Loading...",
                          style: TextStyle(fontSize: 16))))
              : Flexible(
                  child: Center(
                      child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: (screenWidth / screenHeight) / 0.85,
                          children: List.generate(_menuList.length, (index) {
                            return Padding(
                                padding: EdgeInsets.all(0.5),
                                child: GestureDetector(
                                    onTap: () {
                                      Food food = Food(
                                        _menuList[index]['menuid'].toString(),
                                        _menuList[index]['name'].toString(),
                                        _menuList[index]['description']
                                            .toString(),
                                        _menuList[index]['price'].toString(),
                                        _menuList[index]['category'].toString(),
                                      );
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (content) => MenuDetails(
                                                    food: food,
                                                    user: widget.user,
                                                  )));
                                    },
                                    child: Card(
                                      elevation: 5.0,
                                      color: Colors.white,
                                      child: SingleChildScrollView(
                                        child: Column(children: [
                                          SizedBox(height: 5),
                                          Container(
                                            width: screenHeight / 4,
                                            height: screenWidth / 2.5,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "https://hubbuddies.com/270552/rice2go/images/menu/${_menuList[index]['menuid']}.png",
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
                                          SizedBox(height: 10),
                                          Container(
                                            height: screenWidth / 4.5,
                                            child: Column(
                                              children: [
                                                Container(
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                          child: Row(children: [
                                                        Container(
                                                            child: Center(
                                                          child: Text(
                                                            _menuList[index]
                                                                ['name'],
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        )),
                                                      ])),
                                                      SizedBox(height: 5),
                                                      Container(
                                                          child: Row(children: [
                                                        Flexible(
                                                          child: Text(
                                                            _menuList[index]
                                                                ['description'],
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textDirection:
                                                                TextDirection
                                                                    .ltr,
                                                          ),
                                                        ),
                                                      ])),
                                                      SizedBox(height: 5),
                                                      Container(
                                                          child: Row(children: [
                                                        Container(
                                                            child: Text('RM')),
                                                        Text(
                                                          _menuList[index]
                                                              ['price'],
                                                        ),
                                                      ])),
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            SizedBox(width: 20),
                                                            Container(
                                                              height: 25,
                                                              width: 50,
                                                              child: IconButton(
                                                                  icon: Icon(
                                                                      Icons
                                                                          .add_shopping_cart_rounded,
                                                                      color: Colors
                                                                          .black),
                                                                  onPressed:
                                                                      () {
                                                                    _addToCart(
                                                                        index);
                                                                  }),
                                                            ),
                                                          ]),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]),
                                      ),
                                    )));
                          })))),
        ]),
      ),
    );
  }

  void _loadMenu(String catselection) {
    if (catselection.isEmpty) {
      _loadMenu('all');
    }
    http.post(
        Uri.parse("https://hubbuddies.com/270552/rice2go/php/loadmenu.php"),
        body: {
          "catselection": catselection,
        }).then((response) {
      if (response.body == "nodata") {
        print(response.body);

        return;
      } else {
        var jsondata = json.decode(response.body);
        print(response.body);
        _menuList = jsondata["menu"];
        setState(() {});
      }
    });
  }

  Widget hidingIcon() {
    if (inputText.length > 0) {
      return IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              searchController.clear();

              _loadMenu("all");
              isselected1 = true;
              isselected2 = false;
              isselected3 = false;
              isselected4 = false;
              inputText = "";
            });
          });
    } else {
      return null;
    }
  }

  Widget hidingIcon2() {
    if (inputText.length > 0) {
      return IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              searchController.clear();
              Navigator.push(context,
                  MaterialPageRoute(builder: (content) => MainScreen(user:widget.user)));

              inputText = "";
            });
          });
    } else {
      return null;
    }
  }

  _addToCart(int index) {
    String menuid = _menuList[index]["menuid"];
    http.post(
        Uri.parse("https://hubbuddies.com/270552/rice2go/php/add_to_cart.php"),
        body: {"email": widget.user.email, "menuid": menuid}).then((response) {
      if (response.body == "failed") {
        print(response.body);
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.brown,
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.brown,
            textColor: Colors.white,
            fontSize: 16.0);

        return;
      }
    });
  }
}
