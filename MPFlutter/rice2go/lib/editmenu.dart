import 'package:flutter/material.dart';
import 'package:rice2go/food.dart';
import 'package:rice2go/managemenu.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

class EditMenu extends StatefulWidget {
  final Food food;

  const EditMenu({
    Key key,
    this.food,
  }) : super(key: key);

  @override
  _EditMenuState createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  int _value;
  PickedFile _image;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  bool _takepicture = true;
  bool _takepicturelocal = false;

  TextEditingController nameController = new TextEditingController();
  TextEditingController descController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    nameController.text = widget.food.name;
    descController.text = widget.food.description;
    priceController.text = widget.food.price;

    if (widget.food.category == 'Food') {
      _value = 0;
    } else if (widget.food.category == 'Beverages') {
      _value = 1;
    } else if (widget.food.category == 'Weekly Special Menu') {
      _value = 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        backgroundColor: Colors.yellow[50],
        appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.yellow[50],
            title: Text('Edit Menu', style: TextStyle(color: Colors.brown)),
            leading: IconButton(
              icon: Icon(Icons.close_rounded, color: Colors.brown),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctxDialog) =>
                        SingleChildScrollView(child: confirmExitDialog()));
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.check, color: Colors.brown),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    print("Validated!");

                    showDialog(
                        context: context,
                        builder: (ctxDialog) =>
                            SingleChildScrollView(child: confirmEditDialog()));
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
                              GestureDetector(
                                  child: Column(
                                children: [
                                  Visibility(
                                    visible: _takepicture,
                                    child: Stack(children: [
                                      Container(
                                        height: 250,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.transparent),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0)),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  "https://hubbuddies.com/270552/rice2go/images/menu/${widget.food.id}.png"),
                                            )),
                                      ),
                                      Positioned(
                                          bottom: 15.0,
                                          right: 20.0,
                                          child: InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                builder: ((builder) =>
                                                    choosePhoto()),
                                              );
                                            },
                                            child: Icon(
                                              Icons.add_a_photo_sharp,
                                              color: Colors.white,
                                              size: 29.0,
                                            ),
                                          ))
                                    ]),
                                  ),
                                  Visibility(
                                    visible: _takepicturelocal,
                                    child: Stack(children: [
                                      Container(
                                          height: 250,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.transparent),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0)),
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: _image == null
                                                    ? AssetImage(
                                                        "assets/images/addphoto.png")
                                                    : FileImage(
                                                        File(_image.path))),
                                          )),
                                      Positioned(
                                          bottom: 15.0,
                                          right: 20.0,
                                          child: InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                builder: ((builder) =>
                                                    choosePhoto()),
                                              );
                                            },
                                            child: Icon(
                                              Icons.add_a_photo_sharp,
                                              color: Colors.white,
                                              size: 29.0,
                                            ),
                                          ))
                                    ]),
                                  ),
                                ],
                              )),
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
                                          icon: Icon(Icons.add_box_outlined,
                                              color: Colors.brown),
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
                                          icon: Icon(Icons.edit_outlined,
                                              color: Colors.brown),
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
                                                Icons.attach_money_rounded,
                                                color: Colors.brown)),
                                        validator: (String value) {
                                          if (value.isEmpty) {
                                            return "*Required";
                                          } else
                                            return null;
                                        })),
                              ],
                            ),
                            SizedBox(height: 25),
                            FormField(
                              builder: (state) {
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 20,
                                          child: Icon(Icons.category_outlined,
                                              color: Colors.brown),
                                        ),
                                        Container(
                                            width: 310,
                                            padding: EdgeInsets.only(
                                                left: 16, right: 16),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black45,
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: DropdownButton(
                                                hint: Text("Select category",
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                                dropdownColor:
                                                    Colors.brown[200],
                                                icon:
                                                    Icon(Icons.arrow_drop_down),
                                                iconSize: 36,
                                                isExpanded: true,
                                                underline: SizedBox(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12),
                                                value: _value,
                                                items: [
                                                  DropdownMenuItem(
                                                    child: Text('Food',
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                    value: 0,
                                                  ),
                                                  DropdownMenuItem(
                                                    child: Text('Beverages',
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                    value: 1,
                                                  ),
                                                  DropdownMenuItem(
                                                    child: Text(
                                                        'Weekly Special Menu',
                                                        style: TextStyle(
                                                            fontSize: 16)),
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
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: 310,
                                          child: Text(
                                            state.errorText ?? '',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              },
                            ),
                            SizedBox(height: 30),
                          ])))),
        )),
      ),
    );
  }

  confirmEditDialog() {
    return AlertDialog(
      title: Text("Edit Menu?"),
      content: new Container(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(children: [
                Container(
                  width: 250,
                  child: Text(
                    "Are you sure to edit this menu?",
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
            child: Text("NO"),
            onPressed: () {
              Navigator.pop(
                context,
              );
            }),
        TextButton(
            child: Text("YES"),
            onPressed: () {
              Navigator.pop(
                context,
              );
              _editMenu();
              Navigator.pop(context,
                  MaterialPageRoute(builder: (content) => ManageMenu()));
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
              Navigator.pop(
                context,
              );
              Navigator.pop(context,
                  MaterialPageRoute(builder: (content) => ManageMenu()));
            }),
      ],
    );
  }

  void _editMenu() {
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
    if (_image != null) {
      final file = File(_image.path);
      String base64Image = base64Encode(file.readAsBytesSync());
      http.post(
          Uri.parse(
              "https://hubbuddies.com/270552/rice2go/php/update_food_details.php"),
          body: {
            "menuid": widget.food.id,
            "name": name,
            "desc": desc,
            "category": category,
            "price": price,
            "encoded_string": base64Image,
          }).then((response) {
        print(response.body);
        if (response.body == "successsuccesssuccesssuccesssuccess") {
          Fluttertoast.showToast(
              msg: "Success.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.brown,
              textColor: Colors.white,
              fontSize: 16.0);
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
    } else {
      http.post(
          Uri.parse(
              "https://hubbuddies.com/270552/rice2go/php/update_food_details.php"),
          body: {
            "menuid": widget.food.id,
            "name": name,
            "desc": desc,
            "category": category,
            "price": price,
          }).then((response) {
        print(response.body);
        if (response.body == "successsuccesssuccesssuccess") {
          Fluttertoast.showToast(
              msg: "Success.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.brown,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: "Failed",
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
      _takepicture = false;
      _takepicturelocal = true;
    });
  }
}
