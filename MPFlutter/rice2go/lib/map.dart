import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rice2go/currentloc.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  double screenHeight, screenWidth;
  CurrentLoc location;
  Set<Marker> markers = Set();
  String _address = "No location selected";

  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _shopPosition = CameraPosition(
    target: LatLng(6.1171, 100.3771),
    zoom: 17,
  );

  @override
  void initState() {
    super.initState();
    showShopMarker();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        backgroundColor: Colors.yellow[50],
        elevation: 0.0,
        title:
            Text('Select Location', style: TextStyle(color: Colors.brown[700])),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.brown),
            onPressed: () {}),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Flexible(
                  flex: 7,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: _shopPosition,
                    markers: markers.toSet(),
                    onMapCreated: (controller) {
                      _controller.complete(controller);
                    },
                    onTap: (newLatLng) {
                      _loadAdd(newLatLng);
                    },
                  )),
              Divider(
                height: 25,
              ),
              Flexible(
                  flex: 2,
                  child: Container(
                      width: screenWidth * 0.895,
                      decoration: new BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          border: Border.all(color: Colors.brown)),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: 20),
                                Text("ADDRESS:",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.brown)),
                              ],
                            ),
                            SizedBox(height: 5),
                            Container(
                              padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 9,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            height: 70,
                                            child: Text(_address,
                                                style:
                                                    TextStyle(fontSize: 16))),
                                      ],
                                    ),
                                  ),

                                  Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                primary: Colors.brown,
                                                textStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(
                                                    context, location);
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(Icons.save_alt_rounded),
                                                  Text('SAVE'),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),

                                  //
                                ],
                              ),
                            ),
                          ],
                        ),
                      )))
            ],
          ),
        ),
      ),
    );
  }

  void showShopMarker() {
    MarkerId markerId1 = MarkerId("13");
    markers.add(Marker(
      markerId: markerId1,
      position: LatLng(6.1171, 100.3771),
      infoWindow: InfoWindow(
        title: 'Shop Location',
        snippet: "Rice2Go",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ));
  }

  void _loadAdd(LatLng newLatLng) async {
    MarkerId markerId1 = MarkerId("12");

    List<Placemark> newPlace =
        await placemarkFromCoordinates(newLatLng.latitude, newLatLng.longitude);

    Placemark placeMark = newPlace[0];
    String name = placeMark.name.toString();
    String subLocality = placeMark.subLocality.toString();
    String locality = placeMark.locality.toString();
    String administrativeArea = placeMark.administrativeArea.toString();
    String postalCode = placeMark.postalCode.toString();
    String country = placeMark.country.toString();
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
    markers.clear();
    markers.add(Marker(
      markerId: markerId1,
      position: LatLng(newLatLng.latitude, newLatLng.longitude),
      infoWindow: InfoWindow(
        title: 'Address',
        snippet: _address,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    ));

    location = CurrentLoc(_address, newLatLng);
    setState(() {});
  }
}
