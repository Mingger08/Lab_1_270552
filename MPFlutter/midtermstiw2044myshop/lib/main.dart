import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:midtermstiw2044myshop/newproduct.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      home: MyPage(),
    );
  }
}

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  List _productList;
  double screenHeight, screenWidth;
  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
        home: Builder(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text('My Shop'),
        ),
        body: Center(
          child: Container(
              child: Column(
            children: [
              _productList == null
                  ? Flexible(
                      child: Center(
                          child: Text("There is no products displayed yet.")))
                  : Flexible(
                      child: Center(
                          child: GridView.count(
                              crossAxisCount: 2,
                              childAspectRatio:
                                  (screenWidth / screenHeight) / 0.8,
                              children:
                                  List.generate(_productList.length, (index) {
                                return Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Card(
                                      color: Colors.blue[50],
                                      child: SingleChildScrollView(
                                        child: Column(children: [
                                          SizedBox(height: 10),
                                          Container(
                                            height: screenWidth / 2.5,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "https://hubbuddies.com/270552/myshop/images/product/${_productList[index]['productid']}.png",
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
                                            height: screenWidth / 2.5,
                                            child: Column(
                                              children: [
                                                Container(
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                          child: Row(children: [
                                                        Container(
                                                            child: Text(
                                                                'Product Name: ')),
                                                        Expanded(
                                                            child: Text(
                                                          _productList[index]
                                                              ['productname'],
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textDirection:
                                                              TextDirection.rtl,
                                                          textAlign:
                                                              TextAlign.justify,
                                                        )),
                                                      ])),
                                                      Container(
                                                          child: Row(children: [
                                                        Container(
                                                            child: Text(
                                                                'Product Type:')),
                                                        Expanded(
                                                            child: Text(
                                                          _productList[index]
                                                              ['producttype'],
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textDirection:
                                                              TextDirection.rtl,
                                                          textAlign:
                                                              TextAlign.justify,
                                                        )),
                                                      ])),
                                                      Container(
                                                          child: Row(children: [
                                                        Container(
                                                            child: Text(
                                                                'Product Price: RM')),
                                                        Expanded(
                                                            child: Text(
                                                          _productList[index]
                                                              ['productprice'],
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textDirection:
                                                              TextDirection.rtl,
                                                          textAlign:
                                                              TextAlign.justify,
                                                        )),
                                                      ])),
                                                      Container(
                                                          child: Row(children: [
                                                        Container(
                                                            child: Text(
                                                                'Product Quantity: ')),
                                                        Expanded(
                                                            child: Text(
                                                          _productList[index]
                                                              ['productqty'],
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textDirection:
                                                              TextDirection.rtl,
                                                          textAlign:
                                                              TextAlign.justify,
                                                        )),
                                                      ])),
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
            ],
          )),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NewProduct()));
            },
            label: Text("Add Product",
                style: TextStyle(fontWeight: FontWeight.bold)),
            icon: Icon(Icons.add_circle)),
      ),
    ));
  }

  void _loadProduct() {
    http.post(
        Uri.parse("https://hubbuddies.com/270552/myshop/php/loadproducts.php"),
        body: {}).then((response) {
      if (response.body == "nodata") {
        return;
      } else {
        var jsondata = json.decode(response.body);
        _productList = jsondata["products"];
        setState(() {});
      }
    });
  }
}
