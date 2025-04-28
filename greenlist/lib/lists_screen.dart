import 'package:flutter/material.dart';
import 'account_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      routes: {
        '/settings': (context) => SettingsScreen(),
        // Add other routes like /account if needed
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final List<Widget> pages = [
    ListsScreen(),
    AccountScreen(), // Placeholder, create as needed
  ];

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.green[400],
        unselectedItemColor: Colors.white70,
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 1) {
            // Navigate to AccountScreen directly
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AccountScreen()),
            );
          } else {
            setState(() => currentIndex = index);
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Lists"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
      ),
    );
  }
}

class ListsScreen extends StatefulWidget {
  const ListsScreen({super.key});

  @override
  _ListsScreenState createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
  List<String> lists = [];
  static const int maxLists = 10;

  void _addNewList() {
    if (lists.length >= maxLists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Maximum of $maxLists lists reached! Upgrade for more.")),
      );
      return;
    }

    TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("New List Name"),
          content: TextField(
            controller: nameController,
            autofocus: true,
            decoration: InputDecoration(hintText: "Enter list name"),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            TextButton(
              onPressed: () {
                String name = nameController.text.trim();
                if (name.isEmpty || lists.contains(name)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Invalid or duplicate list name!")),
                  );
                  return;
                }
                setState(() => lists.add(name));
                Navigator.pop(context);
              },
              child: Text("Create"),
            ),
          ],
        );
      },
    );
  }

  void _editList(int index) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit),
                title: Text("Rename List"),
                onTap: () {
                  Navigator.pop(context);
                  _renameList(index);
                },
              ),
              ListTile(
                leading: Icon(Icons.share),
                title: Text("Share List"),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Sharing feature coming soon!")),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text("Delete List", style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _renameList(int index) {
    TextEditingController nameController = TextEditingController(text: lists[index]);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Rename List"),
          content: TextField(controller: nameController, autofocus: true),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            TextButton(
              onPressed: () {
                String name = nameController.text.trim();
                if (name.isEmpty || lists.contains(name)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Invalid or duplicate list name!")),
                  );
                  return;
                }
                setState(() => lists[index] = name);
                Navigator.pop(context);
              },
              child: Text("Rename"),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Delete List"),
          content: Text("Are you sure you want to delete '${lists[index]}'?"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            TextButton(
              onPressed: () {
                setState(() => lists.removeAt(index));
                Navigator.pop(context);
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[500],
      appBar: AppBar(
        backgroundColor: Colors.green[500],
        elevation: 0,
        title: Text("Lists", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: lists.length,
          itemBuilder: (_, index) {
            return ListTile(
              title: Text(lists[index], style: TextStyle(color: Colors.white, fontSize: 18)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => GroceryListScreen(listName: lists[index])),
                );
              },
              trailing: IconButton(
                icon: Icon(Icons.more_vert, color: Colors.white),
                onPressed: () => _editList(index),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewList,
        label: Text("Create List"),
        icon: Icon(Icons.add),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
    );
  }
}

class GroceryListScreen extends StatefulWidget {
  final String listName;
  const GroceryListScreen({super.key, required this.listName});

  @override
  _GroceryListScreenState createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  List<Map<String, dynamic>> items = [];

  void _addItem() {
    TextEditingController nameController = TextEditingController();
    TextEditingController quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text("Add Item", style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Item name",
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.black54,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Quantity",
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.black54,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel", style: TextStyle(color: Colors.white))),
            TextButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty || quantityController.text.trim().isEmpty) return;
                setState(() {
                  items.add({"name": nameController.text, "quantity": int.tryParse(quantityController.text) ?? 1});
                });
                Navigator.pop(context);
              },
              child: Text("Add", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[500],
      appBar: AppBar(
        backgroundColor: Colors.green[500],
        elevation: 0,
        title: Text(widget.listName, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (_, index) {
            return ListTile(
              title: Text(items[index]["name"], style: TextStyle(color: Colors.white, fontSize: 18)),
              subtitle: Text("Quantity: ${items[index]["quantity"]}", style: TextStyle(color: Colors.grey)),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _removeItem(index),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addItem,
        label: Text("Add Item"),
        icon: Icon(Icons.add),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.green[500],
      ),
      body: Center(child: Text("Settings go here", style: TextStyle(color: Colors.white))),
    );
  }
}
