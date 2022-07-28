import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:password_manager/db/password_database.dart';
import 'package:password_manager/encrypt/encrypter.dart';
import 'package:password_manager/model/password_model.dart';
import 'package:password_manager/screens/add_password_screen.dart';
import 'package:password_manager/screens/password_generator_screen.dart';
import 'package:password_manager/screens/password_viewer_screen.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/screens/security_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Password> passwords = [];
  late int selectedIndex = -1;
  bool showMenu = false;
  bool isLoading = false;
  int weakPasswordCount = 0;
  int strongPasswordCount = 0;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    this.passwords = await PasswordDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  String weakPasswordCounter() {
    for (var password in passwords) {
      if (password.password.length < 8) {
        weakPasswordCount++;
      } else {}
    }
    return '$weakPasswordCount';
  }

  String strongPasswordCounter() {
    for (var password in passwords) {
      if (password.password.length >= 8) {
        strongPasswordCount++;
      } else {}
    }
    return '$strongPasswordCount';
  }

  Widget noPasswordsFound() {
    return Container(
      height: MediaQuery.of(context).size.height - 200.0,
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 30.0,
            ),
            Icon(
              Icons.password_rounded,
              size: 50.0,
              color: Colors.white,
            ),
            Text(
              'No Passwords Added',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SF'),
            ),
            Text(
              "Click on the '+' icon to add",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add new password',
        child: Container(
          width: 60,
          height: 60,
          child: Icon(
            Icons.add,
            size: 35,
          ),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff0091Ea)),
        ),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AddTask(
                      refershPasswords: refreshNotes,
                    ))),
      ),
      backgroundColor: Color(0xffffffff),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            brightness: Brightness.dark,
            backgroundColor: Color(0xff0091Ea),
            title: Text('Secure Vault',
                style: TextStyle(color: Colors.white)),
            actions: [
              IconButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => PasswordGeneratoe())),
                  icon: Icon(Icons.auto_fix_high, color: Colors.white)),
              IconButton(
                  onPressed: () => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => SecurityScreen())),
                  icon: Icon(Icons.settings, color: Colors.white)),
            ],
          ),
          SliverPadding(
            padding: EdgeInsets.only(left: 14.0),
            sliver: SliverToBoxAdapter(
                child: Text('Your Passwords[${passwords.length}]',
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    ))),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 10.0)),
          passwords.length == 0
              ? SliverToBoxAdapter(
                  child: noPasswordsFound(),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate((buildContext, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    child: ListTile(
                      trailing: Icon(Icons.navigate_next,color: Colors.black,),
                        //shape: RoundedRectangleBorder(
                        //  side: BorderSide(color: Colors.black, width: 1),

                        //),
                        tileColor: Colors.orange.shade100,
                        title: Text(Encrypt.instance.encryptOrDecryptText(passwords[index].title, false),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 26.0,
                                fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          passwords[index].username == ''
                              ? 'No Username'
                              : Encrypt.instance.encryptOrDecryptText(passwords[index].username, false),
                          style: TextStyle(
                              color: Colors.black87, fontWeight: FontWeight.w500),
                        ),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => PasswordViewer(
                                    title: Encrypt.instance.encryptOrDecryptText(passwords[index].title, false),
                                    username: Encrypt.instance.encryptOrDecryptText(passwords[index].username, false),
                                    password: Encrypt.instance.encryptOrDecryptText(passwords[index].password, false),
                                    index: index,
                                    id: passwords[index].id!,
                                    refresh: refreshNotes))),
                      ),
                  );
                }, childCount: passwords.length))
        ],
      ),
    );
  }
}
