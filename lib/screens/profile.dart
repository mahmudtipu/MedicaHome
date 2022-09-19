import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:medicahome/screens/confirmed.dart';

import '../constant.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<ProfileScreen> {
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController numbercontroller = new TextEditingController();
  TextEditingController locationdetailscontroller = new TextEditingController();

  String phone = '';
  String lat = '';
  String lon = '';
  String address = '';
  String name = '';

  @override
  void initState(){
    super.initState();
    getPhone();
    determinePosition();
    fetchprof();
  }

  Future<void> fetchprof() async {
    String na='',add='',la='',lo='';
    await FirebaseFirestore.instance.collection("userdetails").get().then(
          (QuerySnapshot snapshot) =>
          snapshot.docs.forEach((f) {
            na= f.data()['name'];
            add= f.data()['address'];
            la= f.data()['latitude'];
            lo= f.data()['longitude'];
          }),
    );
    setState(() {
      name = na;
      address = add;
      lat = la;
      lon = lo;
    });
  }

  Future<void> GetAddressFromLatLong(Position position)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(()  {
    });
  }

  getPhone() async{
    User currentUser = await FirebaseAuth.instance.currentUser!;
    setState(() {
      phone=currentUser.phoneNumber!;
    });
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Turn on location'),
        behavior: SnackBarBehavior.floating,
      ));

      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              color: Color(0xFF4BC0C8)
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Profile", style: TextStyle(color: Colors.black87),),
      ),
      body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
              color: Color(0xFF4BC0C8)
          ),
          child: SingleChildScrollView(
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10,top: 20),
                    child: Text(
                      "Name : ",
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Colors.black87),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: namecontroller..text=name,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Adam Gabriel',
                      ),
                    ),
                  ),
                  Card(
                    color: Color(0xFF38B0B8),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Text(
                            "Mobile : ",
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: Colors.black87),
                          ),
                          Spacer(),
                          Text(
                            phone,
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: Color(0xFF38B0B8),
                    child: InkWell(
                        onTap: (() async {
                          Position posotion = await determinePosition();
                          GetAddressFromLatLong(posotion);
                          setState(() {
                            lat = '${posotion.latitude}';
                            lon = '${posotion.longitude}';
                          });
                        }),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Text(
                                'Location',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(color: Colors.black87),
                              ),
                              Spacer(),
                              Icon(
                                Icons.location_on,
                                color: Colors.red,
                              )
                            ],
                          ),
                        )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10,top: 20),
                    child: Text(
                      "Location Details : ",
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Colors.black87),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: locationdetailscontroller..text=address,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '4 place Maurice-Charretier, Charleville-mÉziÈres',
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (() {
                      FirebaseAuth auth = FirebaseAuth.instance;
                      String? uid = auth.currentUser?.uid.toString();

                      if(namecontroller.text.toString().isNotEmpty && locationdetailscontroller.text.toString().isNotEmpty)
                      {
                        DocumentReference userdetails = FirebaseFirestore.instance.collection('userdetails').doc(uid);
                        userdetails.set(
                            {
                              "name": namecontroller.text.toString(),
                              "mobile": phone,
                              "latitude": lat,
                              "longitude": lon,
                              "address": locationdetailscontroller.text.toString(),
                            }).then((value){

                        });
                        Get.back();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Profile updated'),
                          behavior: SnackBarBehavior.floating,
                        ));
                      }
                    }),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        width: double.infinity,
                        color: Colors.black54,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(child: Text("Update profile",style: new TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0, color: Colors.white))),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}
