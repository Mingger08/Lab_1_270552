import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:progress_indicators/progress_indicators.dart';
import 'package:rice2go/addmenu.dart';
import 'package:rice2go/editmenu.dart';
import 'package:rice2go/food.dart';
import 'dart:convert';

import 'package:rice2go/mainscreen.dart';

import 'package:rice2go/user.dart';

class ManageMenu extends StatefulWidget {
  final User user;
  final Food food;

  const ManageMenu({Key key, this.user, this.food}) : super(key: key);

  @override
  _ManageMenuState createState() => _ManageMenuState();
}

class _ManageMenuState extends State<ManageMenu> {
  double screenHeight, screenWidth;
  var inputText = "";
  List _menuList;
  bool canEdited = true;
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
        title: Text('Manage Menu', style: TextStyle(color: Colors.brown[700])),
        backgroundColor: Colors.yellow[50],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.brown),
          onPressed: () {
            Navigator.pop(
                context,
                MaterialPageRoute(
                    builder: (content) => MainScreen(user: widget.user)));
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: Colors.brown),
            onPressed: () {
              _loadMenu('all');
            },
          ),
        ],
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
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          _menuList == null
              ? Flexible(
                  child: Center(
                      child: ScalingText("Loading...",
                          style: TextStyle(fontSize: 16))))
              : Flexible(
                  child: Center(
                      child: GridView.count(
                          crossAxisCount: 1,
                          childAspectRatio: 3.5 / 1,
                          children: List.generate(_menuList.length, (index) {
                            return SwipeActionCell(
                                key: ValueKey(_menuList[index]),
                                //performsFirstActionWithFullSwipe: true,
                                trailingActions: <SwipeAction>[
                                  SwipeAction(
                                    nestedAction: SwipeNestedAction(
                                        title: "Confirm Delete"),
                                    title: "Delete",
                                    onTap: (CompletionHandler handler) async {
                                      _deleteMenu(index);
                                      _menuList.removeAt(index);
                                      setState(() {});
                                    },
                                    color: Colors.red,
                                  ),
                                  SwipeAction(
                                      title: "Edit",
                                      onTap: (CompletionHandler handler) async {
                                        Food food = Food(
                                          _menuList[index]['menuid'].toString(),
                                          _menuList[index]['name'].toString(),
                                          _menuList[index]['description']
                                              .toString(),
                                          _menuList[index]['price'].toString(),
                                          _menuList[index]['category']
                                              .toString(),
                                        );

                                        FocusScope.of(context)
                                            .requestFocus(new FocusNode());
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (content) => EditMenu(
                                                      food: food,
                                                    )));

                                        await handler(false);
                                      },
                                      color: Colors.orange),
                                ],
                                child: Padding(
                                    padding: EdgeInsets.all(0.5),
                                    child: Container(
                                        child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors
                                                                .transparent),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20.0)),
                                                        image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(
                                                              "https://hubbuddies.com/270552/rice2go/images/menu/${_menuList[index]['menuid']}.png"),
                                                        )),
                                                  ),
                                                ),
                                                Container(
                                                    height: 100,
                                                    child: VerticalDivider(
                                                        color: Colors.brown)),
                                                Expanded(
                                                  flex: 5,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            _menuList[index]
                                                                ['name'],
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        SizedBox(height: 10),
                                                        Text(
                                                            "RM " +
                                                                _menuList[index]
                                                                    ['price'],
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )))
                                    //)
                                    ));
                          })))),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddMenu()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.brown,
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
              Navigator.pop(context,
                  MaterialPageRoute(builder: (content) => ManageMenu(user:widget.user)));

              inputText = "";
            });
          });
    } else {
      return null;
    }
  }

  Future<void> _deleteMenu(int index) async {
    http.post(
        Uri.parse("https://hubbuddies.com/270552/rice2go/php/deletemenu.php"),
        body: {"menuid": _menuList[index]['menuid']}).then((response) {
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
        _loadMenu('all');
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
}
