import 'package:flutter/material.dart';

class NavDrawer extends StatefulWidget {
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: new Text("Pratap Kumar"),
            accountEmail: new Text("kprathap23@gmail.com"),
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new ExactAssetImage('assets/images/lake.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
            currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://randomuser.me/api/portraits/men/46.jpg")),
          ),
          new ListTile(
              leading: Icon(Icons.library_music),
              title: new Text("Music"),
              onTap: () {
                Navigator.pop(context);
              }),
          new ListTile(
              leading: Icon(Icons.movie),
              title: new Text("Movies"),
              onTap: () {
                Navigator.pop(context);
              }),
          new ListTile(
              leading: Icon(Icons.shopping_cart),
              title: new Text("Shopping"),
              onTap: () {
                Navigator.pop(context);
              }),
          new ListTile(
              leading: Icon(Icons.apps),
              title: new Text("Apps"),
              onTap: () {
                Navigator.pop(context);
              }),
          new ListTile(
              leading: Icon(Icons.dashboard),
              title: new Text("Docs"),
              onTap: () {
                Navigator.pop(context);
              }),
          new ListTile(
              leading: Icon(Icons.settings),
              title: new Text("Settings"),
              onTap: () {
                Navigator.pop(context);
              }),
          new Divider(),
          new ListTile(
              leading: Icon(Icons.info),
              title: new Text("About"),
              onTap: () {
                Navigator.pop(context);
              }),
          new ListTile(
              leading: Icon(Icons.power_settings_new),
              title: new Text("Logout"),
              onTap: () {
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }
}
