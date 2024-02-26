import 'package:flutter/material.dart';
import '../model/todo.dart';
import '../constants/colors.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final Function(ToDo) onToDoChanged;
  final Function(String?) onDeleteItem;
  final Function(String, String) onUpdateItem;

  const ToDoItem({
    Key? key,
    required this.todo,
    required this.onToDoChanged,
    required this.onDeleteItem,
    required this.onUpdateItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          // Call the onToDoChanged function when tapped
          onToDoChanged(todo);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Colors.white,
        leading: Icon(
          todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
          color: tdBlue,
        ),
        title: Text(
          todo.todoText!,
          style: TextStyle(
            fontSize: 16,
            color: tdBlack,
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Call the _showEditDialog method to edit the todo item
                _showEditDialog(context, todo);
              },
            ),
            SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Call the onDeleteItem function to delete the todo item
                onDeleteItem(todo.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Function to show the edit dialog
  void _showEditDialog(BuildContext context, ToDo todo) {
    String updatedText = todo.todoText!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Todo'),
          content: TextField(
            onChanged: (value) {
              updatedText = value;
            },
            controller: TextEditingController(text: todo.todoText),
            decoration: InputDecoration(hintText: 'Enter new todo'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (todo.id != null && todo.id!.isNotEmpty) {
                  // Check if the document ID is valid before updating
                  onUpdateItem(todo.id!, updatedText);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Invalid todo item')));
                }
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
