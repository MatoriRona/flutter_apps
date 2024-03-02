import 'package:app_news/viewTab/category.dart';
import 'package:app_news/viewTab/home.dart';
import 'package:app_news/viewTab/news.dart';
import 'package:app_news/viewTab/profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainMenu extends StatefulWidget {
  final VoidCallback signOut;
  const MainMenu({Key? key, required this.signOut});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  String? username = "", email = "";
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
      email = preferences.getString("email");
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: ( ) {
                  signOut();
                },
                icon: Icon(Icons.lock_open))
          ],
        ),
        body: TabBarView(
          children: [
            Home(),
            News(),
            Profile(),
            Category(),
          ],
          // child: Text('Username : $username, \n Email : $email'),
        ),
        bottomNavigationBar: TabBar(
          labelColor: Colors.blue,
          tabs: [
            Tab(
              child: Text("Home"),
              icon: Icon(Icons.home),
            ),
            Tab(
              child: Text("News"),
              icon: Icon(Icons.new_releases),
            ),
            Tab(    
            child: Text("Category"),
            icon: Icon(Icons.category),
          ),
          Tab(    
            child: Text("Profile"),
            icon: Icon(Icons.perm_contact_calendar),
          ),
          ],
        ),
      ),
    );
  }
}
