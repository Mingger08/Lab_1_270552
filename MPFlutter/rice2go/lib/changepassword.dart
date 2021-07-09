import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rice2go/mainscreen.dart';
import 'package:rice2go/user.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;

class ChangePassword extends StatefulWidget {
  final User user;
  const ChangePassword({Key key, this.user}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _passwordVisible = false;
  bool _confirmpassVisible = false;
  String _oldpass = "";
  String _newpass = "";
  String _compass = "";
  TextEditingController oldpassController = new TextEditingController();
  TextEditingController newpassController = new TextEditingController();
  TextEditingController confirmpassController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        backgroundColor: Colors.yellow[50],
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.yellow[50],
          title: Text('Change Password', style: TextStyle(color: Colors.brown)),
          leading: IconButton(
            icon: Icon(Icons.close_rounded, color: Colors.black),
            onPressed: () {
              Navigator.pop(context,
                  MaterialPageRoute(builder: (content) => MainScreen()));
            },
          ),
        ),
        body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 350,
                        child: TextFormField(
                            controller: oldpassController,
                            decoration: InputDecoration(
                              labelText: 'Old Password',
                              filled: true,
                              fillColor: Colors.brown[100],
                              prefixIcon:
                                  Icon(Icons.lock_rounded, color: Colors.brown),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                                borderSide:
                                    BorderSide(color: Colors.brown, width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide:
                                    BorderSide(color: Colors.brown, width: 2),
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
                SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    child: Stack(children: [
                      Container(
                          width: 350,
                          child: TextFormField(
                            obscureText: !_passwordVisible,
                            controller: newpassController,
                            decoration: InputDecoration(
                              labelText: 'New Password',
                              hintText: "Create a strong password",
                              filled: true,
                              fillColor: Colors.brown[100],
                              prefixIcon:
                                  Icon(Icons.lock_rounded, color: Colors.brown),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                                borderSide:
                                    BorderSide(color: Colors.brown, width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide:
                                    BorderSide(color: Colors.brown, width: 2),
                              ),
                            ),
                            validator: MultiValidator([
                              RequiredValidator(errorText: "*Required"),
                              MinLengthValidator(6,
                                  errorText:
                                      "Password should be at least 6-15 characters"),
                              MaxLengthValidator(15,
                                  errorText:
                                      "Password should not more than 15 characters"),
                            ]),
                          )),
                      Positioned(
                          right: 10,
                          bottom: 20.0,
                          child: GestureDetector(
                              onLongPress: () {
                                setState(() {
                                  _passwordVisible = true;
                                });
                              },
                              onLongPressUp: () {
                                setState(() {
                                  _passwordVisible = false;
                                });
                              },
                              child: _passwordVisible == false
                                  ? Icon(Icons.visibility_off_rounded,
                                      color: Colors.black)
                                  : Icon(Icons.visibility,
                                      color: Colors.black))),
                    ]),
                  ),
                ]),
                SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    child: Stack(children: [
                      Container(
                          width: 350,
                          child: TextFormField(
                              obscureText: !_confirmpassVisible,
                              controller: confirmpassController,
                              decoration: InputDecoration(
                                labelText: 'Re-type Password',
                                filled: true,
                                fillColor: Colors.brown[100],
                                prefixIcon: Icon(Icons.lock_rounded,
                                    color: Colors.brown),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                  borderSide:
                                      BorderSide(color: Colors.brown, width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  borderSide:
                                      BorderSide(color: Colors.brown, width: 2),
                                ),
                              ),
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return "*Required";
                                } else if (confirmpassController.text !=
                                    newpassController.text) {
                                  confirmpassController.clear();
                                  return "Password not matched";
                                }
                                return null;
                              })),
                      Positioned(
                          right: 10,
                          bottom: 20.0,
                          child: GestureDetector(
                              onLongPress: () {
                                setState(() {
                                  _confirmpassVisible = true;
                                });
                              },
                              onLongPressUp: () {
                                setState(() {
                                  _confirmpassVisible = false;
                                });
                              },
                              child: _confirmpassVisible == false
                                  ? Icon(Icons.visibility_off_rounded,
                                      color: Colors.black)
                                  : Icon(Icons.visibility,
                                      color: Colors.black))),
                    ]),
                  ),
                ]),
                SizedBox(height: 20),
                GestureDetector(
                  child: Container(
                    width: 300,
                    height: 50.0,
                    decoration: BoxDecoration(
                        color: Colors.brown,
                        borderRadius: BorderRadius.circular(25.0)),
                    child: Center(
                        child: Text("CHANGE PASSWORD",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold))),
                  ),
                  onTap: () {
                    _oldpass = oldpassController.text.toString();
                    _newpass = newpassController.text.toString();
                    _compass = confirmpassController.text.toString();
                    _changePassword(_oldpass, _newpass, _compass);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _changePassword(String oldpassword, String newpassword, String compass) {
    http.post(
        Uri.parse(
            "https://hubbuddies.com/270552/rice2go/php/updatepassword.php"),
        body: {
          "email": widget.user.email,
          "oldpass": oldpassword,
          "newpass": newpassword,
          "compass": compass,
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        setState(() {
          widget.user.pass = newpassword;
        });
        Fluttertoast.showToast(
            msg: "Password successfully changed.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.brown,
            textColor: Colors.white,
            fontSize: 16.0);
        oldpassController.clear();
        newpassController.clear();
        confirmpassController.clear();
        Navigator.pop(
            context, MaterialPageRoute(builder: (content) => MainScreen()));
      } else if (response.body == "compassnotsame") {
        setState(() {
          widget.user.pass = newpassword;
        });
        Fluttertoast.showToast(
            msg: "Password not matched.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.brown,
            textColor: Colors.white,
            fontSize: 16.0);
        newpassController.clear();
        confirmpassController.clear();
      } else {
        Fluttertoast.showToast(
            msg: "Sorry, fail to change password",
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
