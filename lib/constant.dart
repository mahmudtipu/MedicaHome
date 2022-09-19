import 'package:cloud_firestore/cloud_firestore.dart';

String pharmacyname = "";
String id = "";

//add to cart items

String cartimage = '';
String cartname = '';
String cartprice = '';
String cartdesc = '';
List<DocumentSnapshot> doc = [];

int index = 0;
int totalbill = 0;