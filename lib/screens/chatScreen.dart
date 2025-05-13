import 'dart:ffi';

import 'package:flutter/material.dart';

class chatScreen extends StatefulWidget {
  const chatScreen({super.key});

  @override
  State<chatScreen> createState() => _chatScreenState();
}

class _chatScreenState extends State<chatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3a2144),
      body: Container(margin: EdgeInsets.only(top: 50.0,left: 20.0,right: 20.0),
        child: Column(
          children: [
            Row(
              children: [Icon(Icons.arrow_back_ios_new_outlined,color: Colors.purple,),
              SizedBox(width: 90.0,),
              Text(
          'Jacob Korsgaard',
          style: TextStyle(
              color: Color(0xffc199cd), fontSize: 20.0, fontWeight: FontWeight.w500),
        ),],
            ),
            SizedBox(height: 30.0,)
,            Container(
              width: MediaQuery.of(context).size.width,
              height:  MediaQuery.of(context).size.height / 1.15,
              decoration: BoxDecoration(color:Colors.white ),)
          ],
        ),
      ),
    );
  }
}
