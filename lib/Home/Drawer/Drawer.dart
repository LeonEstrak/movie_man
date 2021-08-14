import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_man/Services/Authentication.dart';

/// Profile Page that is rendered on the Drawer
class ProfileDrawer extends StatefulWidget {
  const ProfileDrawer({Key? key, required this.scaffoldKey}) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  _ProfileDrawerState createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  User user = Authentication.auth.currentUser!;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "You're Logged in as ",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.indigo),
            ),
            Container(
              padding: EdgeInsets.all(12),
              child: user.photoURL != null
                  ? CircleAvatar(
                      foregroundImage: Image.network(
                        user.photoURL!,
                        fit: BoxFit.cover,
                      ).image,
                      radius: 30,
                    )
                  : CircleAvatar(
                      child: Icon(Icons.person),
                    ),
            ),
            Text(
              user.email!,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: ElevatedButton.icon(
                  onPressed: () => Authentication.signOut(),
                  icon: Icon(Icons.logout),
                  label: Text("Logout")),
            )
          ],
        ),
      ),
    );
  }
}
