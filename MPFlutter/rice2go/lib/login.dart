import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rice2go/mainscreen.dart';
import 'package:rice2go/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _rememberMe = false;
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController foremailController = new TextEditingController();
  TextEditingController fornewpassController = new TextEditingController();
  TextEditingController forconpassController = new TextEditingController();
  TextEditingController forcodeController = new TextEditingController();
  SharedPreferences prefs;
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
                                keyboardType: TextInputType.emailAddress,
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
                            onPressed: _onLogin,
                            color: Colors.brown[400]),
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

  void _onLogin() {
    if (_formKey.currentState.validate()) {
      // print("Validated!");
    } else {
      // print("Not Validated");
    }
    String _email = emailController.text.toString();
    String _pass = passController.text.toString();

    if (_email.isEmpty || _pass.isEmpty) {
      Fluttertoast.showToast(
          msg: "Login Failed! Email/password is missing.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.brown,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => MainScreen()));
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
      await prefs.setBool("rememberme", false);

      Fluttertoast.showToast(
          msg: "Preferences removed",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.brown,
          textColor: Colors.white,
          fontSize: 16.0);
    }
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
              Navigator.of(context).pop();
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
              showDialog(
                  context: context,
                  builder: (ctxDialog) =>
                      SingleChildScrollView(child: ResetDialog()));
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
          height: 210,
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
                  width: 250,
                  child: TextField(
                      obscureText: !_passwordVisible,
                      controller: fornewpassController,
                      decoration: InputDecoration(
                          labelText: 'New Password',
                          hintText: "Create a strong password",
                          icon: Icon(
                            Icons.lock_rounded,
                          ),
                          suffixIcon: IconButton(
                              icon: Icon(
                                Icons.remove_red_eye,
                                color: _passwordVisible
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() => this._passwordVisible =
                                    !this._passwordVisible);
                              }))),
                ),
              ]),
              SizedBox(height: 15),
              Row(children: [
                Container(
                    width: 250,
                    child: TextField(
                      obscureText: !this._passwordVisible,
                      controller: forconpassController,
                      decoration: InputDecoration(
                          labelText: 'Re-type Password',
                          icon: Icon(Icons.lock_rounded),
                          suffixIcon: IconButton(
                              icon: Icon(
                                Icons.remove_red_eye,
                                color: this._passwordVisible
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() => this._passwordVisible =
                                    !this._passwordVisible);
                              })),
                    )),
              ]),
            ],
          )),
      actions: [
        TextButton(
            child: Text("BACK"),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        TextButton(
            child: Text("SUBMIT"),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (content) => Login()));
              _resetPassword(foremailController.text, fornewpassController.text,
                  forconpassController.text, forcodeController.text);
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
        showDialog(
            context: context,
            builder: (ctxDialog) => SingleChildScrollView(child: CodeDialog()));
      } else {
        Navigator.of(context).pop();
        foremailController.clear();
        Fluttertoast.showToast(
            msg: "Sorry, please try again later",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.brown,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  void _resetPassword(
      String foremail, String fornewpass, String forconpass, String forcode) {
    http.post(
        Uri.parse("https://hubbuddies.com/270552/rice2go/php/resetpass.php"),
        body: {
          "foremail": foremail,
          "fornewpass": fornewpass,
          "forconpass": forconpass,
          "forverifycode": forcode,
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
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
            msg: "Sorry, confirm password not same.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.brown,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (response.body == "failed2") {
        Fluttertoast.showToast(
            msg: "Sorry, verify code not correct.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.brown,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Sorry. fail to change pass",
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
