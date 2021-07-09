import 'package:flutter/material.dart';
import 'package:rice2go/changepassword.dart';
import 'package:rice2go/choosebill.dart';
import 'package:rice2go/login.dart';
import 'package:rice2go/mainscreen.dart';
import 'package:rice2go/managemenu.dart';
import 'package:rice2go/ordersummary.dart';
import 'package:rice2go/user.dart';
import 'package:rice2go/userprofile.dart';

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
            accountEmail:
                (Text(widget.user.email, style: TextStyle(fontSize: 14))),
            currentAccountPicture: InkWell(
                child: CircleAvatar(
                  backgroundColor: Colors.brown[300],
                  backgroundImage: NetworkImage(
                      "https://hubbuddies.com/270552/rice2go/images/profile/${widget.user.email}.png"),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) =>
                              UserProfile(user: widget.user)));
                }),
            accountName:
                Text(widget.user.username, style: TextStyle(fontSize: 14)),
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
              title: Text("Manage Menu",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              leading: Icon(Icons.restaurant_menu_rounded, color: Colors.brown),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => ManageMenu(user: widget.user)));
              }),
          ListTile(
              title: Text("Order Summary",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              leading: Icon(Icons.list_rounded, color: Colors.brown),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => OrderSummary(user: widget.user)));
              }),
          ListTile(
              title: Text("Pay Bill",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              leading: Icon(Icons.receipt_long_outlined, color: Colors.brown),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) =>
                            ChooseBillPage(user: widget.user)));
              }),
          ListTile(
              title: Text("Change Password",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              leading: Icon(Icons.security_outlined, color: Colors.brown),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) =>
                            ChangePassword(user: widget.user)));
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
