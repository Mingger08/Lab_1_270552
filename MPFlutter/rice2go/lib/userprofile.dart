import 'package:flutter/material.dart';
import 'package:rice2go/currentloc.dart';
import 'package:rice2go/mainscreen.dart';
import 'package:rice2go/map.dart';
import 'package:rice2go/user.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class UserProfile extends StatefulWidget {
  final User user;

  const UserProfile({Key key, this.user}) : super(key: key);
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  int _value;
  String birthDateInString;
  String gender;
  DateTime birthDate;
  bool isDateSelected = false;
  PickedFile _image;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  bool _takepicture = true;
  bool _takepicturelocal = false;
  String address = "";
  Position currentposition;

  TextEditingController nameController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController birthdateController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    nameController.text = widget.user.name;
    usernameController.text = widget.user.username;
    phoneController.text = widget.user.phone;
    emailController.text = widget.user.email;
    birthdateController.text = widget.user.birthdate;
    if (widget.user.gender == 'Male') {
      _value = 0;
    } else if (widget.user.gender == 'Female') {
      _value = 1;
    } else if (widget.user.gender == 'Other') {
      _value = 2;
    }
    address = widget.user.addressname +
        "," +
        widget.user.subLocality +
        "," +
        widget.user.locality +
        "," +
        widget.user.postalCode +
        "," +
        widget.user.administrativeArea +
        "," +
        widget.user.country;
    locationController.text = address;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.yellow[50],
          title: Text('Edit Profile', style: TextStyle(color: Colors.brown)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.brown),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => MainScreen(user: widget.user)));
            },
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.check, color: Colors.brown),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    print("Validated!");

                    String _username = usernameController.text.toString();
                    String _phone = phoneController.text.toString();
                    String _gender = _value.toString();
                    String _birthdate = birthdateController.text.toString();
                    String _address = locationController.text.toString();
                    String _name = nameController.text.toString();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Edit User Profile"),
                            content: Text("Confirm to edit your profile?"),
                            actions: [
                              TextButton(
                                  child: Text("CANCEL"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }),
                              TextButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _editprofileuser(
                                      _username,
                                      _phone,
                                      _gender,
                                      _birthdate,
                                      _address,
                                      _name,
                                    );
                                  }),
                            ],
                          );
                        });
                  }
                })
          ]),
      body: SingleChildScrollView(
          child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Center(
            child: Form(
                key: _formKey,
                child: Container(
                    width: 350,
                    child: Column(children: [
                      Stack(children: [
                        GestureDetector(
                            child: Column(
                          children: [
                            Visibility(
                              visible: _takepicture,
                              child: Stack(children: [
                                CircleAvatar(
                                  radius: 60.0,
                                  backgroundColor: Colors.brown[300],
                                  backgroundImage: NetworkImage(
                                      "https://hubbuddies.com/270552/rice2go/images/profile/${widget.user.email}.png"),
                                ),
                                Positioned(
                                    bottom: 15.0,
                                    right: 20.0,
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
                                        size: 22.0,
                                      ),
                                    ))
                              ]),
                            ),
                            Visibility(
                              visible: _takepicturelocal,
                              child: Stack(children: [
                                CircleAvatar(
                                    radius: 60.0,
                                    backgroundColor: Colors.brown[300],
                                    backgroundImage: _image == null
                                        ? AssetImage("assets/images/user.png")
                                        : FileImage(File(_image.path))),
                                Positioned(
                                    bottom: 15.0,
                                    right: 20.0,
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
                                        size: 22.0,
                                      ),
                                    ))
                              ]),
                            ),
                          ],
                        )),
                      ]),
                      SizedBox(height: 35),
                      Row(
                        children: [
                          Container(
                              width: 350,
                              child: TextFormField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    labelText: 'Name',
                                    prefixIcon: Icon(Icons.assignment_ind,
                                        color: Colors.brown),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      borderSide: BorderSide(
                                          color: Colors.brown, width: 2),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                          color: Colors.brown, width: 2),
                                    ),
                                  ),
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
                        children: [
                          Container(
                              width: 350,
                              child: TextFormField(
                                  controller: usernameController,
                                  decoration: InputDecoration(
                                    labelText: 'Username',
                                    prefixIcon: Icon(Icons.account_circle,
                                        color: Colors.brown),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      borderSide: BorderSide(
                                          color: Colors.brown, width: 2),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                          color: Colors.brown, width: 2),
                                    ),
                                  ),
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
                        children: [
                          Container(
                              width: 350,
                              height: 57,
                              padding: EdgeInsets.only(left: 10, right: 5),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.brown, width: 2),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      width: 20,
                                      child: Icon(Icons.people,
                                          color: Colors.brown)),
                                  SizedBox(width: 15),
                                  Container(
                                    width: 296,
                                    child: DropdownButton(
                                        hint: Row(
                                          children: [
                                            Container(
                                                child: Icon(Icons.people,
                                                    color: Colors.brown)),
                                            SizedBox(width: 12),
                                            Container(
                                              child: Text("Select gender",
                                                  style:
                                                      TextStyle(fontSize: 16)),
                                            ),
                                          ],
                                        ),
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
                                            child: Text('Male',
                                                style: TextStyle(fontSize: 16)),
                                            value: 0,
                                          ),
                                          DropdownMenuItem(
                                            child: Text('Female',
                                                style: TextStyle(fontSize: 16)),
                                            value: 1,
                                          ),
                                          DropdownMenuItem(
                                            child: Text('Other',
                                                style: TextStyle(fontSize: 16)),
                                            value: 2,
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
                      SizedBox(height: 25),
                      Row(
                        children: [
                          Container(
                              width: 350,
                              child: Stack(
                                  alignment: Alignment.centerRight,
                                  children: [
                                    TextFormField(
                                      controller: birthdateController,
                                      decoration: InputDecoration(
                                        labelText: 'Date of Birth',
                                        hintText: 'YYYY-MM-DD',
                                        prefixIcon: Icon(Icons.date_range,
                                            color: Colors.brown),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0)),
                                          borderSide: BorderSide(
                                              color: Colors.brown, width: 2),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide: BorderSide(
                                              color: Colors.brown, width: 2),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 15,
                                      child: GestureDetector(
                                          child: new Icon(
                                              Icons.calendar_today_rounded),
                                          onTap: () async {
                                            final datePick =
                                                await showDatePicker(
                                                    context: context,
                                                    initialDate:
                                                        new DateTime.now(),
                                                    firstDate:
                                                        new DateTime(1900),
                                                    lastDate:
                                                        new DateTime(2100));
                                            if (datePick != null &&
                                                datePick != birthDate) {
                                              setState(() {
                                                birthDate = datePick;
                                                isDateSelected = true;

                                                birthDateInString =
                                                    "${birthDate.year}-${birthDate.month}-${birthDate.day}";

                                                birthdateController.text =
                                                    birthDateInString;
                                              });
                                            }
                                          }),
                                    ),
                                  ])),
                        ],
                      ),
                      SizedBox(height: 25),
                      Row(
                        children: [
                          Container(
                              width: 350,
                              child: TextFormField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Phone Number',
                                    prefixIcon:
                                        Icon(Icons.call, color: Colors.brown),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      borderSide: BorderSide(
                                          color: Colors.brown, width: 2),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                          color: Colors.brown, width: 2),
                                    ),
                                  ),
                                  validator: (String value) {
                                    if (value.length < 10 ||
                                        value.length > 15) {
                                      return "Invalid phone number";
                                    } else
                                      return null;
                                  })),
                        ],
                      ),
                      SizedBox(height: 25),
                      Row(
                        children: [
                          Container(
                              width: 350,
                              child: TextFormField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    prefixIcon: Icon(Icons.alternate_email,
                                        color: Colors.brown),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      borderSide: BorderSide(
                                          color: Colors.brown, width: 2),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide: BorderSide(
                                          color: Colors.brown, width: 2),
                                    ),
                                  ),
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
                        children: [
                          Container(
                              width: 350,
                              height: 100,
                              child: Stack(
                                  alignment: Alignment.topCenter,
                                  children: [
                                    TextFormField(
                                      controller: locationController,
                                      keyboardType: TextInputType.multiline,
                                      minLines: 4,
                                      maxLines: 4,
                                      decoration: InputDecoration(
                                        labelText: 'Address',
                                        prefixIcon: Icon(Icons.home_filled,
                                            color: Colors.brown),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0)),
                                          borderSide: BorderSide(
                                              color: Colors.brown, width: 2),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide: BorderSide(
                                              color: Colors.brown, width: 2),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 5,
                                      bottom: 40,
                                      child: IconButton(
                                        icon: Icon(Icons.location_on_rounded,
                                            color: Colors.black),
                                        onPressed: () =>
                                            {_getCurrentUserLocation()},
                                      ),
                                    ),
                                    Positioned(
                                      right: 15,
                                      bottom: 20,
                                      child: GestureDetector(
                                        child: Icon(Icons.map_rounded),
                                        onTap: () async {
                                          CurrentLoc _adr =
                                              await Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Map()));
                                          setState(() {
                                            locationController.text =
                                                _adr.address;
                                          });
                                        },
                                      ),
                                    )
                                  ])),
                        ],
                      ),
                      SizedBox(height: 20),
                    ])))),
      )),
    );
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

  void _editprofileuser(username, phone, gender, birthdate, address, name) {
    if (_image != null) {
      final file = File(_image.path);

      String base64Image = base64Encode(file.readAsBytesSync());
      if (_value == 0) {
        gender = 'Male';
      } else if (_value == 1) {
        gender = 'Female';
      } else if (_value == 2) {
        gender = 'Other';
      }
      http.post(
          Uri.parse(
              "https://hubbuddies.com/270552/rice2go/php/update_user_profile.php"),
          body: {
            "username": widget.user.username,
            "phone": phone,
            "gender": gender,
            "birthdate": birthdate,
            "address": address,
            "name": name,
            "email": widget.user.email,
            "encoded_string": base64Image,
          }).then((response) {
        print(response.body);
        if (response.body == "failed") {
          Fluttertoast.showToast(
              msg: "Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.brown,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: "Success. ",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.brown,
              textColor: Colors.white,
              fontSize: 16.0);
          List userdata = response.body.split(",");
          User user = User(
            name: userdata[1],
            username: userdata[2],
            phone: userdata[3],
            gender: userdata[4],
            birthdate: userdata[5],
            addressname: userdata[6],
            subLocality: userdata[7],
            locality: userdata[8],
            postalCode: userdata[9],
            administrativeArea: userdata[10],
            country: userdata[11],
          );

          Navigator.push(context,
              MaterialPageRoute(builder: (content) => MainScreen(user: user)));
        }
      });
    } else {
      if (_value == 0) {
        gender = 'Male';
      } else if (_value == 1) {
        gender = 'Female';
      } else if (_value == 2) {
        gender = 'Other';
      }
      http.post(
          Uri.parse(
              "https://hubbuddies.com/270552/rice2go/php/update_user_profile.php"),
          body: {
            "username": widget.user.username,
            "phone": phone,
            "gender": gender,
            "birthdate": birthdate,
            "address": address,
            "name": name,
            "email": widget.user.email,
          }).then((response) {
        print(response.body);
        if (response.body == "failed") {
          Fluttertoast.showToast(
              msg: "Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.brown,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: "Success. ",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.brown,
              textColor: Colors.white,
              fontSize: 16.0);
          List userdata = response.body.split(",");
          User user = User(
            name: userdata[1],
            username: userdata[2],
            phone: userdata[3],
            gender: userdata[4],
            birthdate: userdata[5],
            addressname: userdata[6],
            subLocality: userdata[7],
            locality: userdata[8],
            postalCode: userdata[9],
            administrativeArea: userdata[10],
            country: userdata[11],
          );

          Navigator.push(context,
              MaterialPageRoute(builder: (content) => MainScreen(user: user)));
        }
      });
    }
  }

  _getCurrentUserLocation() async {
    await _determinePosition().then((value) => {_getPlace(value)});
    setState(() {});
  }

  void _getPlace(Position position) async {
    String _address = "";
    List<Placemark> newPlace =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = newPlace[0];
    String name = place.name.toString();
    String subLocality = place.subLocality.toString();
    String locality = place.locality.toString();
    String administrativeArea = place.administrativeArea.toString();
    String postalCode = place.postalCode.toString();
    String country = place.country.toString();

    _address = name +
        "," +
        subLocality +
        ",\n" +
        locality +
        "," +
        postalCode +
        ",\n" +
        administrativeArea +
        "," +
        country;
    locationController.text = _address;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(
          msg: "Please make sure your location is on.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.brown,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(
            msg: "Location permission is denied.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.brown,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg: "Location permission is denied.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.brown,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    return await Geolocator.getCurrentPosition();
  }
}
