import 'package:flutter/material.dart';
import 'package:task/constants/ConstSize.dart';
import 'package:task/views/screen/Home.dart';
import 'package:task/views/screen/WebView.dart';

class Splash extends StatelessWidget {
  const Splash({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
       Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return Home();
      }));
    });
    return Scaffold(
      body: Container(
          //  color: Colors.red,
          height: scrnH(context),
          width: scrnW(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: scrnH(context) * 0.2,
                  width: scrnW(context) * 0.87,
                  child: Text("EASACC")),
              const CircularProgressIndicator(),
            ],
          )),
    );
  }
}
