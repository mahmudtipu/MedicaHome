import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:medicahome/constant.dart';
import 'package:medicahome/screens/nav_bar.dart';
import 'package:medicahome/screens/pharmacy_screen.dart';

import 'cart.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  List<DocumentSnapshot> documents = [];

  String searchText = '';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        drawer: NavBar(),
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                color: Color(0xFF4BC0C8)
            ),
          ),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.remove_red_eye_sharp,
                  color: Colors.black87, // Change Custom Drawer Icon Color
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          title: TextField(
            showCursor: false,
            //enableInteractiveSelection: false,
            focusNode: FocusNode(),
            controller: searchController,
            onChanged: (value) {
              setState(() {
                searchText = value;
              });
            },
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.search),
              labelText: "Search shop",
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add_shopping_cart_rounded,
                color: Colors.black87,
              ),
              onPressed: () {
                Get.to(Cart());
              },
            ),
          ],
        ),
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
                    Color(0xFF4BC0C8),
                    Color(0xFF4BC0C8),
                    Color(0xFF4BC0C8),
                  ]
              )
          ),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("category").snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                      if(!snapshot.hasData)
                      {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      documents = snapshot.data!.docs;
                      if (searchText.length > 0) {
                        documents = documents.where((element) {
                          return element
                              .get('name')
                              .toString()
                              .toLowerCase()
                              .contains(searchText.toLowerCase());
                        }).toList();
                      }
                      return ListView(
                        children: documents.map((document){
                          return Padding(
                            padding: const EdgeInsets.all(14),
                            child: InkWell(
                              onTap: ((){
                                pharmacyname = document['name'];
                                id = document['id'];
                                Get.to(Pharmacy());
                              }),
                              child: Container(
                                decoration: BoxDecoration(
                                  //border: Border.all(color: Colors.blueGrey, width: 1),
                                  shape: BoxShape.rectangle,
                                  //borderRadius: BorderRadius.all(Radius.circular(50)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Image.network(document['image'], height: 200,width: double.infinity,fit:BoxFit.fill),
                                        Container(
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  colors: [
                                                    Colors.black54,
                                                    Colors.black54,
                                                    Colors.black54,
                                                  ]
                                              )
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 5.0,left: 8, bottom: 2),
                                                child: Text(document['name'],style: new TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0, color: Colors.white)),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 5.0),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.location_on, color: Colors.red,),
                                                    Text(document['address'],style: new TextStyle(color: Colors.white)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}