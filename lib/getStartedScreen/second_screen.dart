import 'package:flutter/material.dart';
import 'package:password_manager/db/user_database.dart';
import 'package:password_manager/encrypt/encrypter.dart';
import 'package:password_manager/model/user_info_model.dart';
import 'package:password_manager/screens/home_screen.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final String message =
      "You will be asked to enter this password each time you open the app. Later on, you can also disable this from app settings.";
  bool requiredLogin = true;
  TextEditingController masterPassword = TextEditingController();

  String getText() {
    if (requiredLogin == true) {
      return 'Yes';
    } else {
      return 'No';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Enter Master Password',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                style: TextStyle(color: Colors.black),
                maxLength: 60,
                controller: masterPassword,
                onFieldSubmitted: (value) {
                  masterPassword.text = value;
                },
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    hintText: 'Enter Master Password',
                    counterStyle: TextStyle(color: Colors.black),
                    hintStyle: TextStyle(color: Colors.black)),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                message,
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
              SizedBox(
                height: 10.0,
              ),
              /*Container(
                height: 60.0,
                width: MediaQuery.of(context).size.width - 10.0,
                decoration: BoxDecoration(
                    color: Color(0xff2E3647),
                    borderRadius: BorderRadius.circular(8.0)),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Require Login At Startup',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0),
                      ),
                      Switch(
                        value: requiredLogin,
                        onChanged: (value) {
                          setState(() {
                            requiredLogin = value;
                          });
                        },
                        activeTrackColor: Colors.green[500],
                        activeColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),*/
              SizedBox(
                height: 5.0,
              ),
              SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          var user = User(
                              loginRequired: requiredLogin,
                              masterpswd: Encrypt.instance.encryptOrDecryptText(masterPassword.text, true));
                          UserDatabase.instance.create(user);
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (_) => HomeScreen()));
                        },
                        child: Container(
                          height: 60.0,
                          //width: 200.0,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Center(
                            child: Text(
                              'Done',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
