import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rice2go/addmenu.dart';
import 'package:http/http.dart' as http;
import 'package:progress_indicators/progress_indicators.dart';
import 'package:rice2go/homedrawer.dart';
import 'dart:convert';

import 'package:rice2go/user.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var inputText = "";

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
              icon:
                  Icon(Icons.shopping_cart_outlined, color: Colors.brown[700]),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddMenu()));
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
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
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
                          primary:
                              isselected1 ? Colors.brown[800] : Colors.grey),
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
                          primary:
                              isselected2 ? Colors.brown[800] : Colors.grey),
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
                          primary:
                              isselected3 ? Colors.brown[800] : Colors.grey),
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
                          primary:
                              isselected4 ? Colors.brown[800] : Colors.grey),
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
                              childAspectRatio:
                                  (screenWidth / screenHeight) / 0.85,
                              children:
                                  List.generate(_menuList.length, (index) {
                                return Padding(
                                    padding: EdgeInsets.all(0.5),
                                    child: Card(
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
                                                      Row(children: [
                                                        Container(
                                                          height: 10,
                                                          width: 190,
                                                          child: IconButton(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              icon: Icon(
                                                                  Icons
                                                                      .shopping_cart_outlined,
                                                                  color: Colors
                                                                      .black),
                                                              onPressed: () {}),
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
                                    ));
                              }))))
            ]),
          ),
        ));
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
      print(response.body);
      if (response.body == "nodata") {
        return;
      } else {
        var jsondata = json.decode(response.body);
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
                  MaterialPageRoute(builder: (content) => MainScreen()));

              inputText = "";
            });
          });
    } else {
      return null;
    }
  }
}
