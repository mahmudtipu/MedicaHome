import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:medicahome/screens/home_screen.dart';

class ThanksScreen extends StatefulWidget {
  const ThanksScreen({Key? key}) : super(key: key);

  @override
  _ThanksScreenState createState() => _ThanksScreenState();
}

class _ThanksScreenState extends State<ThanksScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Get.offAll(HomeScreen());
    });

    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
            color: Color(0xFF4BC0C8)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.check_circle_rounded, color: Colors.green,size: 60,),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Thanks for your order",style: new TextStyle(fontWeight: FontWeight.w500, fontSize: 25.0, color: Colors.black87)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0,left: 20,right: 20),
              child: Text("Our rider will deliver your products soon at your door step.",textAlign: TextAlign.center,style: new TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0, color: Colors.black87)),
            ),
          ],
        ),
      ),
    );
  }
}
