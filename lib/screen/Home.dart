import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskify/model/todo.dart';
import 'package:taskify/viewmodel/AuthViewModel.dart';
import 'package:taskify/viewmodel/GlobalUIViewModel.dart';
import 'package:taskify/widget/TodoList.dart';
import '../constants/colors.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _todoController = TextEditingController();

  late GlobalUIViewModel _ui = GlobalUIViewModel();
  late AuthViewModel _auth = AuthViewModel();

  void logout() async {
    _ui.loadState(true);
    try {
      await _auth.logout();
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      _ui.loadState(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'To-Do List',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('todos')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return CircularProgressIndicator();
                              default:
                                final todos = snapshot.data!.docs;
                                return ListView.builder(
                                  itemCount: todos.length,
                                  itemBuilder: (context, index) {
                                    final todo = todos[index];
                                    return ToDoItem(
                                      todo: ToDo.fromMap(
                                          todo.data() as Map<String, dynamic>),
                                      onToDoChanged: _handleToDoChange,
                                      onDeleteItem: _deleteToDoItem,
                                      onUpdateItem: _updateToDoItem,
                                    );
                                  },
                                );
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                            bottom: 20,
                            right: 20,
                            left: 20,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 0.0),
                                blurRadius: 10.0,
                                spreadRadius: 0.0,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: _todoController,
                            decoration: InputDecoration(
                              hintText: 'Add a new todo item',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          bottom: 20,
                          right: 20,
                        ),
                        child: ElevatedButton(
                          child: Text(
                            '+',
                            style: TextStyle(
                              fontSize: 40,
                            ),
                          ),
                          onPressed: () {
                            _addToDoItem(_todoController.text);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: tdBlue,
                            minimumSize: Size(60, 60),
                            elevation: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleToDoChange(ToDo todo) {
    FirebaseFirestore.instance
        .collection('todos')
        .doc(todo.id)
        .update({'isDone': !todo.isDone});
  }

  void _addToDoItem(String toDo) {
    if (toDo.trim().isNotEmpty) {
      String id = FirebaseFirestore.instance.collection('todos').doc().id; // Generate a new id
      FirebaseFirestore.instance.collection('todos').doc(id).set({
        'id': id,
        'todoText': toDo,
        'isDone': false,
      });
      _todoController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid todo item')));
    }
  }


  void _deleteToDoItem(String? id) {
    if (id != null && id.isNotEmpty) {
      FirebaseFirestore.instance.collection('todos').doc(id).delete().then((_) {
        print('Todo item deleted successfully');
      }).catchError((error) {
        print('Failed to delete todo item: $error');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete todo item')));
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Invalid todo item')));
    }
  }


  void _updateToDoItem(String id, String newToDoText) {
    if (id.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('todos')
          .doc(id)
          .update({'todoText': newToDoText}).then((_) {
        print('Todo item updated successfully');
      }).catchError((error) {
        print('Failed to update todo item: $error');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update todo item')));
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Invalid todo item')));
    }
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: tdAppBar,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PopupMenuButton(
            iconSize: 40,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: ListTile(
                    leading: IconTheme(
                      data: IconTheme.of(context).copyWith(
                        color: Colors.brown, // Set the color of the icon
                      ),
                      child: Icon(Icons.logout),
                    ),
                    title: Text('Logout'),
                    onTap: logout,
                  ),
                ),
              ];
            },
          ),
          Spacer(),
          Image.asset(
            'assets/images/TaskifyLogo.png',
            height: 80,
            width: 80,
          ),
          Spacer(),
          Container(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/images/avatar.png'),
            ),
          ),
        ],
      ),
    );
  }
}
