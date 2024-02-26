import 'dart:convert';

class ToDo {
  String? id;
  String? todoText;
  bool isDone;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
  });

  factory ToDo.fromJson(String str) => ToDo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ToDo.fromMap(Map<String, dynamic> map) {
    return ToDo(
      id: map['id'],
      todoText: map['todoText'],
      isDone: map['isDone'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id, // Ensure id is included in the map
      'todoText': todoText,
      'isDone': isDone,
    };
  }
}
