import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:midtermstiw2044myshop/main.dart';
import 'package:image_picker/image_picker.dart';

class NewProduct extends StatefulWidget {
  @override
  _NewProductState createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  int _itemCount = 0;
  PickedFile _image;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = new TextEditingController();
  TextEditingController typeController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  TextEditingController quantityController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Add Product'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_outlined, color: Colors.white),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyApp()));
            },
          ),
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Container(
                        width: 350,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(children: [
                                CircleAvatar(
                                    radius: 100.0,
                                    backgroundImage: _image == null
                                        ? AssetImage(
                                            "assets/images/addphoto.png")
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
                                            labelText: 'Product Name',
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
                                          controller: typeController,
                                          decoration: InputDecoration(
                                            labelText: 'Type',
                                            icon: Icon(Icons.category_outlined),
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
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 120,
                                    child: Text("Quantity",
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  _itemCount != 0
                                      ? new IconButton(
                                          icon: new Icon(Icons.remove),
                                          onPressed: () =>
                                              setState(() => _itemCount--),
                                        )
                                      : new Container(),
                                  new Text(_itemCount.toString()),
                                  new IconButton(
                                      icon: new Icon(Icons.add),
                                      onPressed: () =>
                                          setState(() => _itemCount++))
                                ],
                              ),
                              SizedBox(height: 20),
                              Container(
                                width: 150,
                                height: 45,
                                child: MaterialButton(
                                  child: Text('Add',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                  onPressed: _addProduct,
                                  color: Colors.blue,
                                ),
                              ),
                            ]))))),
      ),
    );
  }

  void _addProduct() {
    final file = File(_image.path);
    String base64Image = base64Encode(file.readAsBytesSync());
    String prname = nameController.text.toString();
    String prtype = typeController.text.toString();
    String prprice = priceController.text.toString();
    String prqty = _itemCount.toString();

    if (_formKey.currentState.validate()) {
      print("Validated!");

      http.post(
          Uri.parse("https://hubbuddies.com/270552/myshop/php/newproduct.php"),
          body: {
            "prname": prname,
            "prtype": prtype,
            "prprice": prprice,
            "prqty": prqty,
            "encoded_string": base64Image,
          }).then((response) {
        print(response.body);
        if (response.body == "success") {
          Fluttertoast.showToast(
              msg: "Product is successfully added.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.blue,
              textColor: Colors.black,
              fontSize: 16.0);
          setState(() {
            _image = null;
            nameController.text = "";
            typeController.text = "";
            priceController.text = "";
            _itemCount = 0;
          });
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyApp()));
        } else {
            Fluttertoast.showToast(
                msg: "Sorry, please try again later",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.blue,
                textColor: Colors.black,
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
                icon: Icon(Icons.camera, size: 35),
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                label: Text("Camera", style: TextStyle(fontSize: 16)),
              ),
              TextButton.icon(
                icon: Icon(Icons.image, size: 35),
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                label: Text("Gallery", style: TextStyle(fontSize: 16)),
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
