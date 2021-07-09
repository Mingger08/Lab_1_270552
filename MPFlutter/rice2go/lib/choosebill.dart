import 'package:flutter/material.dart';
import 'package:rice2go/amount.dart';
import 'package:rice2go/mainscreen.dart';
import 'package:rice2go/user.dart';

class ChooseBillPage extends StatefulWidget {
  final User user;

  const ChooseBillPage({Key key, this.user}) : super(key: key);
  @override
  _ChooseBillPageState createState() => _ChooseBillPageState();
}

class _ChooseBillPageState extends State<ChooseBillPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.yellow[50],
        title: Text('Bills', style: TextStyle(color: Colors.brown)),
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
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: <Widget>[
          Card(
            color: Colors.brown[300],
            elevation: 10.0,
            child: ListTile(
                title: Text("Tenaga Nasional Berhad (TNB)",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                subtitle: Text("Electricity"),
                leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage("assets/images/tnb1.png")),
                trailing: GestureDetector(
                  onTap: () {
                    String title = "Electricity";
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (content) =>
                                Amount(user: widget.user, title: title)));
                  },
                  child: Icon(Icons.arrow_forward_ios_outlined,
                      color: Colors.brown[100]),
                )),
          ),
          Card(
            color: Colors.brown[300],
            child: ListTile(
                title: Text("Syarikat Air Darul Aman Sdn Bhd (SADA)",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                subtitle: Text("Water"),
                leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage("assets/images/sada2.png")),
                trailing: GestureDetector(
                  onTap: () {
                    String title = "Water";
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (content) =>
                                Amount(user: widget.user, title: title)));
                  },
                  child: Icon(Icons.arrow_forward_ios_outlined,
                      color: Colors.brown[100]),
                )),
          ),
          Card(
            color: Colors.brown[300],
            child: ListTile(
                title: Text("Indah Water",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                subtitle: Text("Sewerage"),
                leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        AssetImage("assets/images/indahwater.png")),
                trailing: GestureDetector(
                  onTap: () {
                    String title = "Sewerage";
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (content) =>
                                Amount(user: widget.user, title: title)));
                  },
                  child: Icon(Icons.arrow_forward_ios_outlined,
                      color: Colors.brown[100]),
                )),
          ),
        ],
      ),
    );
  }
}
