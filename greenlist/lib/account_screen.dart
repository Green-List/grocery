import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AccountScreen(),
    );
  }
}

class AccountScreen extends StatelessWidget {
  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.green[500],
    appBar: AppBar(
      backgroundColor: Colors.green[500],
      elevation: 0,
      title: Text("Account", style: TextStyle(color: Colors.white)),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    ),
    body: Container(
      width: double.infinity, // make it full width
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Username: John Doe", style: TextStyle(color: Colors.white, fontSize: 20)),
          SizedBox(height: 20),
          Text("Email: JDoe@examplemail.com", style: TextStyle(color: Colors.white70)),
          SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
            icon: Icon(Icons.logout),
            label: Text("Log Out"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );
}
}
