import 'package:flutter/material.dart';
import 'package:rice2go/mainscreen.dart';
import 'package:rice2go/paybill.dart';
import 'package:rice2go/user.dart';

class Amount extends StatefulWidget {
  final User user;
  final String title;
  const Amount({Key key, this.user, this.title}) : super(key: key);

  @override
  _AmountState createState() => _AmountState();
}

class _AmountState extends State<Amount> {
  TextEditingController accountnumController = new TextEditingController();
  TextEditingController amountController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.yellow[50],
        title: Text(widget.title, style: TextStyle(color: Colors.brown)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.brown),
          onPressed: () {
            Navigator.pop(
                context,
                MaterialPageRoute(
                    builder: (content) => MainScreen(user: widget.user)));
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
                children: [
                  SizedBox(width: 30),
                  Container(
                      width: 350,
                      child: Text("ACCOUNT NUMBER",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                ],
              ),
              Container(child: Divider(height: 10)),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Stack(children: [
                  Container(
                      width: 350,
                      child: TextFormField(
                          controller: accountnumController,
                          decoration: InputDecoration(
                            hintText: 'Account Number',
                            filled: true,
                            fillColor: Colors.brown[100],
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
                  Container(
                      child: Positioned(
                          right: 10,
                          bottom: 23,
                          child: GestureDetector(
                              child: Container(
                                child: Text("CLEAR"),
                              ),
                              onTap: () {
                                accountnumController.clear();
                              })))
                ]),
              ]),
              SizedBox(height: 25),
              Row(
                children: [
                  SizedBox(width: 30),
                  Container(
                      width: 350,
                      child: Text("AMOUNT (RM)",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                ],
              ),
              Container(child: Divider(height: 10)),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Stack(
                  children: [
                    Container(
                        width: 350,
                        child: TextFormField(
                            controller: amountController,
                            decoration: InputDecoration(
                              hintText: "Amount (RM)",
                              filled: true,
                              fillColor: Colors.brown[100],
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
                    Container(
                        child: Positioned(
                            right: 10,
                            bottom: 23,
                            child: GestureDetector(
                                child: Container(
                                  child: Text("CLEAR"),
                                ),
                                onTap: () {
                                  amountController.clear();
                                })))
                  ],
                ),
              ]),
              SizedBox(height: 30),
              GestureDetector(
                child: Container(
                  width: 350,
                  height: 60.0,
                  decoration: BoxDecoration(
                      color: Colors.brown,
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Center(
                      child: Text("CHECKOUT",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold))),
                ),
                onTap: () {
                  if (_formKey.currentState.validate()) {
                    print("Validated!");
                    String amount = amountController.text.toString();
                    String accnum = accountnumController.text.toString();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (content) => PayBill(
                                user: widget.user,
                                amount: amount,
                                accnum: accnum)));
                  }
                },
              ),
            ],
          ),
        ),
      ),
      
    );
  }
}
