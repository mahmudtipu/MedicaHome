import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicahome/constant.dart';
import 'package:medicahome/screens/order_screen.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final User user = FirebaseAuth.instance.currentUser!;
  List<DocumentSnapshot> documents = [];

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
        title: Text("Cart", style: TextStyle(color: Colors.black87),),
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Color(0xFF4BC0C8)
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("userdetails").doc(user.uid).collection("cart").snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if(!snapshot.hasData)
                    {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    documents = snapshot.data!.docs;

                    if(documents.length>0)
                      {
                        doc = documents;
                        return Column(
                          children: [
                            Expanded(
                              child: ListView(
                                children: documents.map((document){
                                  int a = int.parse(document['price'].toString());
                                  totalbill = totalbill+a;
                                  String price = document['price'].toString();
                                  return Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.blueGrey, width: 1),
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.all(Radius.circular(50)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Center(
                                          child: ListTile(
                                            onTap: ((){

                                            }),
                                            title: Padding(
                                              padding: const EdgeInsets.only(bottom: 3.0),
                                              child: Row(
                                                children: [
                                                  Text(document['name'],style: new TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0, color: Colors.black87)),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text("X "+document['quantity'].toString(),style: new TextStyle(fontSize: 18.0, color: Colors.black87)),
                                                  ),
                                                ],
                                              )
                                            ),
                                            subtitle: Row(
                                              children: [
                                                Icon(Icons.euro, color: Colors.black54,),
                                                Text(price,style: new TextStyle(color: Colors.black87)),
                                                Spacer(),
                                                InkWell(
                                                  onTap: ((){
                                                    FirebaseFirestore.instance.collection("userdetails").doc(user.uid).collection('cart')
                                                        .doc(document["id"].toString())
                                                        .delete();
                                                  }),
                                                  child: Container(
                                                    width: 100,
                                                    height: 25,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.black87, width: 1),
                                                      shape: BoxShape.rectangle,
                                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                                      gradient: LinearGradient(
                                                        colors: [Colors.black54, Colors.black54],
                                                        begin: Alignment.bottomRight,
                                                        end: Alignment.topLeft,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                          ("Delete"),
                                                          style: new TextStyle(color: Colors.white)
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            InkWell(
                              onTap: ((){
                                Get.to(OrderScreen());
                              }),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: double.infinity,
                                  color: Colors.black54,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(child: Text("Order now",style: new TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0, color: Colors.white))),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    else
                      {
                        return Center(
                          child: Text('Empty'),
                        );
                      }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
