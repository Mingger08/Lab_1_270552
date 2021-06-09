import 'package:flutter/material.dart';
import 'package:rice2go/addmenu.dart';
import 'package:rice2go/login.dart';

import 'package:rice2go/mainscreen.dart';
import 'package:rice2go/user.dart';

class HomeDrawer extends StatefulWidget {
  final User user;

  const HomeDrawer({Key key, this.user}) : super(key: key);

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.brown[700]),
            accountEmail: (Text(widget.user.email)),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage("assets/images/user.png"),
            ),
            accountName: Text(widget.user.username),
          ),
          ListTile(
            title: Text("Home",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            leading: Icon(Icons.home, color: Colors.brown),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => MainScreen(user: widget.user)));
            },
          ),
          ListTile(
              title: Text("Manage Product",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              leading: Icon(Icons.admin_panel_settings, color: Colors.brown),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(context,
                    MaterialPageRoute(builder: (content) => AddMenu()));
              }),
          SizedBox(height: 25),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 1.0,
                ),
              ),
            ),
          ),
          ListTile(
              title: Text("Logout",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              leading: Icon(Icons.logout, color: Colors.brown),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context, MaterialPageRoute(builder: (content) => Login()));
              })
        ],
      ),
    );
  }
}
