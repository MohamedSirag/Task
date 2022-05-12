import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:task/views/screen/Settings.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    Future<void> _handleSignIn() async {
      try {
        await _googleSignIn.signIn();
      } catch (error) {
        print(error);
      }
    }

    return Scaffold(
        body: Column(children: [
      Container(
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () async {
                final LoginResult result = await FacebookAuth.instance
                    .login(); // by default we request the email and the public profile
// or FacebookAuth.i.login()
                if (result.status == LoginStatus.success) {
                  // you are logged
                  final AccessToken accessToken = result.accessToken;
                } else {
                  print(result.status);
                  print(result.message);
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.42,
                height: MediaQuery.of(context).size.height * (7 / 100),
                decoration: BoxDecoration(
                    color: Color(0xff4267b2),
                    borderRadius: BorderRadius.circular(8)),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Facebook",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        // fontFamily: "Tajawal",
                        fontStyle: FontStyle.normal,
                        fontSize: 18.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      GestureDetector(
        onTap: () async {
          try {
            await _googleSignIn.signIn();
          } catch (error) {
            print(error);
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.42,
          height: MediaQuery.of(context).size.height * (7 / 100),
          decoration: new BoxDecoration(
              color: Color(0xfff7f7f7), borderRadius: BorderRadius.circular(8)),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              "جوجل",
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 18.0),
            ),
          ),
        ),
      ),
      GestureDetector(
          onTap: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return Settings();
            }));
          },
          child: Icon(Icons.settings, size: 40))
    ]));
  }
}
