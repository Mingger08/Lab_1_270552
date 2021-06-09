import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:rice2go/mainscreen.dart';
import 'package:rice2go/user.dart';

class AddMenu extends StatefulWidget {
  final User user;

  const AddMenu({Key key, this.user}) : super(key: key);
  @override
  _AddMenuState createState() => _AddMenuState();
}

class _AddMenuState extends State<AddMenu> {
  int _value;
  PickedFile _image;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = new TextEditingController();
  TextEditingController descController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        backgroundColor: Colors.yellow[50],
        appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.yellow[50],
            title: Text('Add Menu', style: TextStyle(color: Colors.black)),
            leading: IconButton(
              icon: Icon(Icons.close_rounded, color: Colors.black),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctxDialog) =>
                        SingleChildScrollView(child: confirmExitDialog()));
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.check, color: Colors.black),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    print("Validated!");
                    showDialog(
                        context: context,
                        builder: (ctxDialog) =>
                            SingleChildScrollView(child: confirmAddDialog()));
                  }
                },
              ),
            ]),
        body: Center(
            child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Container(
                      width: 350,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Stack(children: [
                              CircleAvatar(
                                  radius: 100.0,
                                  backgroundColor: Colors.white,
                                  backgroundImage: _image == null
                                      ? AssetImage("assets/images/addphoto.png")
                                      : FileImage(File(_image.path))),
                              Positioned(
                                  bottom: 25.0,
                                  right: 45.0,
                                  child: InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: ((builder) => choosePhoto()),
                                      );
                                    },
                                    child: Icon(
                                      Icons.add_a_photo_sharp,
                                      color: Colors.white,
                                      size: 28.0,
                                    ),
                                  ))
                            ]),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Container(
                                    width: 350,
                                    child: TextFormField(
                                        controller: nameController,
                                        decoration: InputDecoration(
                                          labelText: 'Name',
                                          icon: Icon(Icons.add_box_outlined),
                                        ),
                                        validator: (String value) {
                                          if (value.isEmpty) {
                                            return "*Required";
                                          } else
                                            return null;
                                        })),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Container(
                                    width: 350,
                                    child: TextFormField(
                                        controller: descController,
                                        maxLength: 100,
                                        decoration: InputDecoration(
                                          labelText: 'Description',
                                          icon: Icon(Icons.edit_outlined),
                                        ),
                                        validator: (String value) {
                                          if (value.isEmpty) {
                                            return "*Required";
                                          } else
                                            return null;
                                        })),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                    width: 350,
                                    child: TextFormField(
                                        controller: priceController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            prefixText: 'RM',
                                            labelText: 'Price',
                                            icon: Icon(
                                                Icons.attach_money_rounded)),
                                        validator: (String value) {
                                          if (value.isEmpty) {
                                            return "*Required";
                                          } else
                                            return null;
                                        })),
                              ],
                            ),
                            SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 20,
                                  child: Icon(Icons.category_outlined,
                                      color: Colors.black45),
                                ),
                                Container(
                                    width: 310,
                                    padding:
                                        EdgeInsets.only(left: 16, right: 16),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey, width: 1),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: DropdownButton(
                                        hint: Text("Select category",
                                            style: TextStyle(fontSize: 16)),
                                        dropdownColor: Colors.brown[200],
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 36,
                                        isExpanded: true,
                                        underline: SizedBox(),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 12),
                                        value: _value,
                                        items: [
                                          DropdownMenuItem(
                                            child: Text('Food',
                                                style: TextStyle(fontSize: 16)),
                                            value: 0,
                                          ),
                                          DropdownMenuItem(
                                            child: Text('Beverages',
                                                style: TextStyle(fontSize: 16)),
                                            value: 1,
                                          ),
                                          DropdownMenuItem(
                                            child: Text('Weekly Special Menu',
                                                style: TextStyle(fontSize: 16)),
                                            value: 2,
                                          ),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            _value = value;
                                          });
                                        }))
                              ],
                            ),
                            SizedBox(height: 30),
                          ])))),
        )),
      ),
    );
  }

  confirmAddDialog() {
    return AlertDialog(
      title: Text("Add New Menu?"),
      content: new Container(
          width: 400,
          height: 50,
          child: Column(
            children: [
              Row(children: [
                Container(
                  width: 250,
                  child: Text(
                    "Are you sure to add this menu?",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ]),
              SizedBox(height: 10),
            ],
          )),
      actions: [
        TextButton(
            child: Text("CANCEL"),
            onPressed: () {
              Navigator.pop(
                context,
              );
            }),
        TextButton(
            child: Text("SUBMIT"),
            onPressed: () {
              _addNewMenu();
              Navigator.of(context).pop();
            }),
      ],
    );
  }

  confirmExitDialog() {
    return AlertDialog(
      title: Text("Confirm Exit?"),
      content: new Container(
          width: 400,
          height: 50,
          child: Column(
            children: [
              Row(children: [
                Container(
                  width: 250,
                  child: Text(
                    "Are you sure to exit? Any changes made will not be saved.",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ]),
              SizedBox(height: 10),
            ],
          )),
      actions: [
        TextButton(
            child: Text("NO"),
            onPressed: () {
              Navigator.pop(
                context,
              );
            }),
        TextButton(
            child: Text("YES"),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (content) => MainScreen()));
            }),
      ],
    );
  }

  void _addNewMenu() {
    final file = File(_image.path);
    String base64Image = base64Encode(file.readAsBytesSync());
    String name = nameController.text.toString();
    String desc = descController.text.toString();
    String category = _value.toString();
    String price = priceController.text.toString();

    if (_value == 0) {
      category = 'Food';
    } else if (_value == 1) {
      category = 'Beverages';
    } else if (_value == 2) {
      category = 'Weekly Special Menu';
    }

    http.post(
        Uri.parse("https://hubbuddies.com/270552/rice2go/php/add_new_menu.php"),
        body: {
          "name": name,
          "desc": desc,
          "category": category,
          "price": price,
          "encoded_string": base64Image,
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "New menu is successfully created.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.brown,
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {
          _image = null;
          nameController.text = "";
          descController.text = "";
          _value = null;
          priceController.text = "";
        });
      } else {
        Fluttertoast.showToast(
            msg: "Sorry, please try again later",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.brown,
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      }
    });
  }

  choosePhoto() {
    return Container(
        height: 100.0,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: [
            Text("Please select a photo", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              TextButton.icon(
                icon: Icon(Icons.camera, size: 30, color: Colors.brown),
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                label: Text("Camera",
                    style: TextStyle(fontSize: 16, color: Colors.brown)),
              ),
              TextButton.icon(
                icon: Icon(Icons.image, size: 30, color: Colors.brown),
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                label: Text("Gallery",
                    style: TextStyle(fontSize: 16, color: Colors.brown)),
              ),
            ])
          ],
        ));
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _image = pickedFile;
      Navigator.of(context).pop();
    });
  }
}
