import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:rice2go/login.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController confirmPassController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _agreeTerms = false;
  bool _passwordVisible = false;
  bool _regdisable = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Material App',
        home: Scaffold(
            backgroundColor: Colors.yellow[50],
            body: Center(
                child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                        child: Container(
                            width: 350,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    height: 170,
                                    margin: EdgeInsets.all(0.5),
                                    child: Image.asset(
                                        'assets/images/rice2go.png')),
                                Text("Registration",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 5),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          width: 350,
                                          child: TextFormField(
                                              controller: usernameController,
                                              decoration: InputDecoration(
                                                  labelText: 'Username',
                                                  icon: Icon(
                                                      Icons.account_circle)),
                                              validator: (String value) {
                                                if (value.isEmpty) {
                                                  return "*Required";
                                                } else if (value.length < 3) {
                                                  return "Username should more than 3 characters";
                                                } else
                                                  return null;
                                              })),
                                    ]),
                                SizedBox(height: 10),
                                Row(children: [
                                  Container(
                                      width: 350,
                                      child: TextFormField(
                                          controller: phoneController,
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                              labelText: 'Phone Number',
                                              hintText: "eg. 0123456789",
                                              icon: Icon(Icons.call)),
                                          validator: (String value) {
                                            if (value.isEmpty) {
                                              return "*Required";
                                            } else if (value.length < 10 ||
                                                value.length > 15) {
                                              return "Invalid phone number";
                                            } else
                                              return null;
                                          })),
                                ]),
                                SizedBox(height: 10),
                                Row(children: [
                                  Container(
                                      width: 350,
                                      child: TextFormField(
                                          controller: emailController,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                              labelText: 'Email Address',
                                              hintText: "eg. abc@example.com",
                                              icon:
                                                  Icon(Icons.alternate_email)),
                                          validator: MultiValidator([
                                            RequiredValidator(
                                                errorText: "*Required"),
                                            EmailValidator(
                                                errorText:
                                                    "Enter a valid email"),
                                          ]))),
                                ]),
                                SizedBox(height: 10),
                                Row(children: [
                                  Container(
                                      width: 350,
                                      child: TextFormField(
                                        obscureText: !_passwordVisible,
                                        controller: passController,
                                        decoration: InputDecoration(
                                            labelText: 'Password',
                                            hintText:
                                                "Create a strong password",
                                            icon: Icon(
                                              Icons.lock_rounded,
                                            ),
                                            suffixIcon: GestureDetector(
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
                                              child: Icon(Icons.remove_red_eye),
                                            )),
                                        validator: MultiValidator([
                                          RequiredValidator(
                                              errorText: "*Required"),
                                          MinLengthValidator(6,
                                              errorText:
                                                  "Password should be at least 6-15 characters"),
                                          MaxLengthValidator(15,
                                              errorText:
                                                  "Password should not more than 15 characters"),
                                        ]),
                                      ))
                                ]),
                                SizedBox(height: 10),
                                Row(children: [
                                  Container(
                                      width: 350,
                                      child: TextFormField(
                                          obscureText: !_passwordVisible,
                                          controller: confirmPassController,
                                          decoration: InputDecoration(
                                              labelText: 'Re-type Password',
                                              icon: Icon(Icons.lock_rounded),
                                              suffixIcon: GestureDetector(
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
                                                child:
                                                    Icon(Icons.remove_red_eye),
                                              )),
                                          validator: (String value) {
                                            if (value.isEmpty) {
                                              return "*Required";
                                            } else if (confirmPassController
                                                    .text !=
                                                passController.text) {
                                              confirmPassController.clear();
                                              return "Password not matched";
                                            }
                                            return null;
                                          })),
                                ]),
                                SizedBox(height: 10),
                                Row(children: [
                                  Checkbox(
                                      value: _agreeTerms,
                                      onChanged: (bool value) {
                                        _onChanged(value);
                                      }),
                                  RichText(
                                    text: TextSpan(
                                      text: "I agree to the ",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text: "Terms and Conditions",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                                SizedBox(height: 5),
                                Container(
                                  width: 150,
                                  height: 45,
                                  // ignore: deprecated_member_use
                                  child: RaisedButton(
                                    child: Text('Register',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                    onPressed: _onRegister,
                                    color: Colors.brown[400],
                                  ),
                                ),
                                SizedBox(height: 20),
                                GestureDetector(
                                  child: RichText(
                                    text: TextSpan(
                                      text: "Already registered? ",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text: "Login",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: _LoginAccount,
                                ),
                                SizedBox(height: 10),
                              ],
                            )))))));
  }

  // ignore: non_constant_identifier_names
  void _LoginAccount() {
    Navigator.push(context, MaterialPageRoute(builder: (content) => Login()));
  }

  void _onRegister() {
    String _username = usernameController.text.toString();
    String _phone = phoneController.text.toString();
    String _email = emailController.text.toString();
    String _pass = passController.text.toString();

    if (_formKey.currentState.validate()) {
      print("Validated!");
      if (_regdisable == true) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("User Registration"),
                content: Text("Confirm to register?"),
                actions: [
                  TextButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _registerUser(_username, _phone, _email, _pass);
                      }),
                  TextButton(
                      child: Text("CANCEL"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ],
              );
            });
      } else {
        Fluttertoast.showToast(
            msg: "Please agree",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.brown,
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      }
    } else {
      print("Not Validated");

      Fluttertoast.showToast(
          msg: "Registration Failed! Something is missing/wrong.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.brown,
          textColor: Colors.white,
          fontSize: 16.0);
          
      return;
    }
  }

  void _registerUser(String username, String phone, String email, String pass) {
    http.post(
        Uri.parse("https://hubbuddies.com/270552/rice2go/php/register.php"),
        body: {
          "username": username,
          "phone": phone,
          "email": email,
          "password": pass,
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg:
                "Successfully registered. Please verify your account via email.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.brown,
            textColor: Colors.white,
            fontSize: 16.0);
        FocusScope.of(context).unfocus();
        Navigator.push(
            context, MaterialPageRoute(builder: (content) => Login()));
      } else {
        Fluttertoast.showToast(
            msg: "Failed to register. Please try again.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.brown,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  void _onChanged(bool value) {
    setState(() {
      _agreeTerms = value;
      if (_agreeTerms == true) {
        _regdisable = true;
      } else {
        _regdisable = false;
      }
    });
  }
}
