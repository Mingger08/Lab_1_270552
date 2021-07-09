import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rice2go/food.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rice2go/mainscreen.dart';
import 'package:rice2go/user.dart';
import 'package:http/http.dart' as http;

class MenuDetails extends StatefulWidget {
  final Food food;
  final User user;
  const MenuDetails({Key key, this.food, this.user}) : super(key: key);
  @override
  _MenuDetailsState createState() => _MenuDetailsState();
}

class _MenuDetailsState extends State<MenuDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      body: Center(
          child: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
            leading: IconButton(
              icon:
                  Icon(Icons.arrow_back_ios_outlined, color: Colors.brown[300]),
              onPressed: () {
                Navigator.pop(context,
                    MaterialPageRoute(builder: (content) => MainScreen()));
              },
            ),
            elevation: 0.0,
            backgroundColor: Colors.yellow[50],
            expandedHeight: 350.0,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl:
                    "https://hubbuddies.com/270552/rice2go/images/menu/${widget.food.id}.png",
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => new Transform.scale(
                    scale: 1.0, child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => new Icon(
                  Icons.broken_image,
                ),
              ),
            )),
        SliverFixedExtentList(
            itemExtent: 60.0,
            delegate: SliverChildListDelegate([
              Text(widget.food.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text(widget.food.description,
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 18,
                  )),
              Text("RM" + widget.food.price,
                  style: TextStyle(
                    fontSize: 18,
                  )),
              GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.brown[400],
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Center(
                      child: Text("ADD TO CART",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold))),
                ),
                onTap: () {
                  _addToCart();
                    Navigator.pop(context,
                    MaterialPageRoute(builder: (content) => MainScreen()));
                },
              ),
            ]))
      ])),
    );
  }

  _addToCart() {
    http.post(
        Uri.parse("https://hubbuddies.com/270552/rice2go/php/add_to_cart.php"),
        body: {
          "email": widget.user.email,
          "menuid": widget.food.id,
        }).then((response) {
      if (response.body == "failed") {
        print(response.body);
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.brown,
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.brown,
            textColor: Colors.white,
            fontSize: 16.0);

        return;
      }
    });
  }
}
