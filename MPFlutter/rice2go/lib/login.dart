import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rice2go/mainscreen.dart';
import 'package:rice2go/register.dart';
import 'package:rice2go/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _rememberMe = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController foremailController = new TextEditingController();
  TextEditingController fornewpassController = new TextEditingController();
  TextEditingController forconpassController = new TextEditingController();
  TextEditingController forcodeController = new TextEditingController();
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Material App',
        home: Scaffold(
            backgroundColor: Colors.yellow[50],
            body: Center(
              child: SingleChildScrollView(
                  child: Form(
                key: _formKey,
                child: Container(
                  width: 350,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: 210,
                          margin: EdgeInsets.all(10),
                          child: Image.asset('assets/images/rice2go.png')),
                      Text("User Login",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                width: 350,
                                child: TextFormField(
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                        labelText: 'Email Address',
                                        icon: Icon(Icons.alternate_email)),
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return "*Required";
                                      } else
                                        return null;
                                    })),
                          ]),
                      SizedBox(height: 10),
                      Row(children: [
                        Container(
                            width: 350,
                            child: TextFormField(
                                controller: passController,
                                decoration: InputDecoration(
                                    labelText: 'Password',
                                    icon: Icon(Icons.lock_rounded)),
                                obscureText: true,
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return "*Required";
                                  } else
                                    return null;
                                })),
                      ]),
                      SizedBox(height: 20),
                      Row(children: [
                        Checkbox(
                            value: _rememberMe,
                            onChanged: (bool value) {
                              _onChanged(value);
                            }),
                        Text("Remember Me", style: TextStyle(fontSize: 16)),
                      ]),
                      Container(
                        width: 150,
                        height: 45,
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                            child: Text('Login',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            color: Colors.brown[400],
                            onPressed: () {
                              _onLogin(
                                  emailController.text, passController.text);
                            }),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have account? ",
                            style: TextStyle(fontSize: 14, color: Colors.black),
                            children: [
                              TextSpan(
                                text: "Create Account",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: _registerNewUser,
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        child: Text("Forgot password?",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline)),
                        onTap: _forgotPassword,
                      ),
                    ],
                  ),
                ),
              )),
            )));
  }

  void _onLogin(String email, String pass) {
    if (_formKey.currentState.validate()) {
      print("Validated!");
    } else {
      print("Not Validated");
    }

    if (email.isEmpty || pass.isEmpty) {
      Fluttertoast.showToast(
          msg: "Email/password is missing.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.brown,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    http.post(Uri.parse("https://hubbuddies.com/270552/rice2go/php/login.php"),
        body: {
          "email": email,
          "password": pass,
        }).then((response) {
      print(response.body);
      if (response.body == "failed") {
        Fluttertoast.showToast(
            msg: "Invalid email/password. ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.brown,
            textColor: Colors.white,
            fontSize: 16.0);
        emailController.clear();
        passController.clear();
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
          email: email,
          pass: pass,
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

  void _registerNewUser() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => Register()));
  }

  void _onChanged(bool value) {
    String _email = emailController.text.toString();
    String _pass = passController.text.toString();

    if (_email.isEmpty || _pass.isEmpty) {
      Fluttertoast.showToast(
          msg: "Email/password is missing",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.brown,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    setState(() {
      _rememberMe = value;
      savePreferences(value, _email, _pass);
    });
  }

  Future<void> savePreferences(bool value, String email, String pass) async {
    prefs = await SharedPreferences.getInstance();
    if (value) {
      await prefs.setString("email", email);
      await prefs.setString("password", pass);
      await prefs.setBool("rememberme", value);

      Fluttertoast.showToast(
          msg: "Preferences stored",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.brown,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else {
      await prefs.setString("email", '');
      await prefs.setString("password", '');
      await prefs.setBool("rememberme", value);

      Fluttertoast.showToast(
          msg: "Preferences removed",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.brown,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        _rememberMe = false;
      });
      return;
    }
  }

  Future<void> loadPref() async {
    prefs = await SharedPreferences.getInstance();
    String _email = prefs.getString("email") ?? '';
    String _password = prefs.getString("password") ?? '';
    _rememberMe = prefs.getBool("rememberme") ?? false;

    setState(() {
      emailController.text = _email;
      passController.text = _password;
    });
  }

  void _forgotPassword() {
    showDialog(
        context: context,
        builder: (ctxDialog) => SingleChildScrollView(child: forgetDialog()));
  }

  forgetDialog() {
    return AlertDialog(
      title: Text("Forgot your password?"),
      content: new Container(
          width: 400,
          height: 130,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(children: [
                Container(
                  width: 250,
                  child: Text(
                    "Enter your email for the verification process, we will send a verification code to email.",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                )
              ]),
              SizedBox(height: 15),
              Row(children: [
                Container(
                    width: 250,
                    child: TextField(
                      controller: foremailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: 'Email Address',
                          hintText: "eg. abc@example.com",
                          icon: Icon(Icons.alternate_email)),
                    ))
              ]),
            ],
          )),
      actions: [
        TextButton(
            child: Text("CANCEL"),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        TextButton(
            child: Text("SEND VERIFICATION CODE"),
            onPressed: () {
              _getVerifyCode(foremailController.text);
            }),
      ],
    );
  }

  // ignore: non_constant_identifier_names
  CodeDialog() {
    return AlertDialog(
      title: Text("Verify Account"),
      content: new Container(
          width: 400,
          height: 130,
          child: Column(
            children: [
              Row(children: [
                Container(
                  width: 250,
                  child: Text(
                    "A 4-digit verification code has been sent to your email. Please check it and fill in the field below.",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                ),
              ]),
              SizedBox(height: 15),
              Row(children: [
                Container(
                    width: 250,
                    child: TextField(
                      controller: forcodeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Verification Code',
                          icon: Icon(Icons.code_rounded)),
                    )),
              ]),
            ],
          )),
      actions: [
        TextButton(
            child: Text("RESEND"),
            onPressed: () {
              _getVerifyCode(foremailController.text);
            }),
        TextButton(
            child: Text("CONTINUE"),
            onPressed: () {
              _codeValidate(foremailController.text, forcodeController.text);
            }),
      ],
    );
  }

  // ignore: non_constant_identifier_names
  ResetDialog() {
    return AlertDialog(
      title: Text("Reset Password"),
      content: new Container(
          width: 400,
          height: 190,
          child: Column(
            children: [
              Row(children: [
                Container(
                  width: 250,
                  child: Text(
                    "Set the new password for your account.",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                ),
              ]),
              SizedBox(height: 15),
              Row(children: [
                Container(
                    width: 240,
                    child: TextField(
                      obscureText: true,
                      controller: fornewpassController,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        hintText: "At least 6-15 characters",
                        icon: Icon(
                          Icons.lock_rounded,
                        ),
                      ),
                    )),
              ]),
              SizedBox(height: 10),
              Row(children: [
                Container(
                    width: 250,
                    child: TextField(
                      obscureText: true,
                      controller: forconpassController,
                      decoration: InputDecoration(
                        labelText: 'Re-type Password',
                        icon: Icon(Icons.lock_rounded),
                      ),
                    )),
              ]),
            ],
          )),
      actions: [
        TextButton(
            child: Text("CANCEL"),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (content) => Login()));
            }),
        TextButton(
            child: Text("SUBMIT"),
            onPressed: () {
              _resetPassword(foremailController.text, fornewpassController.text,
                  forconpassController.text);
            }),
      ],
    );
  }

  void _getVerifyCode(String email) {
    http.post(
        Uri.parse(
            "https://hubbuddies.com/270552/rice2go/php/getverifycode.php"),
        body: {
          "email": email,
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Success. Please get your verification code via email.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.brown,
            textColor: Colors.white,
            fontSize: 16.0);
        FocusScope.of(context).unfocus();
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (ctxDialog) => SingleChildScrollView(child: CodeDialog()));
      } else {
        Fluttertoast.showToast(
            msg: "Sorry, please try again later",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.brown,
            textColor: Colors.white,
            fontSize: 16.0);

        foremailController.clear();
      }
    });
  }

  void _resetPassword(String foremail, String fornewpass, String forconpass) {
    http.post(
        Uri.parse("https://hubbuddies.com/270552/rice2go/php/resetpass.php"),
        body: {
          "foremail": foremail,
          "fornewpass": fornewpass,
          "forconpass": forconpass,
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Navigator.push(
            context, MaterialPageRoute(builder: (content) => Login()));
        Fluttertoast.showToast(
            msg: "Password successfully changed.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.brown,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (response.body == "failed1") {
        Fluttertoast.showToast(
            msg: "Password not matched.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.brown,
            textColor: Colors.white,
            fontSize: 16.0);
        fornewpassController.clear();
        forconpassController.clear();
      } else if (response.body == "failed2") {
        Fluttertoast.showToast(
            msg: "Password must be at least 6-15 characters.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.brown,
            textColor: Colors.white,
            fontSize: 16.0);
        fornewpassController.clear();
        forconpassController.clear();
      } else {
        Fluttertoast.showToast(
            msg: "Sorry, fail to change password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.brown,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.push(
            context, MaterialPageRoute(builder: (content) => Login()));
      }
    });
  }

  void _codeValidate(String foremail, String forcode) {
    http.post(
        Uri.parse("https://hubbuddies.com/270552/rice2go/php/verify_code.php"),
        body: {
          "foremail": foremail,
          "forverifycode": forcode,
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Success. ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.brown,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (ctxDialog) =>
                SingleChildScrollView(child: ResetDialog()));
      } else {
        Fluttertoast.showToast(
            msg: "Invalid verification code. ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.brown,
            textColor: Colors.white,
            fontSize: 16.0);
        forcodeController.clear();
      }
    });
  }
}
