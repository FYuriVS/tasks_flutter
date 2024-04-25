import 'package:flutter/material.dart';
import 'package:tasks_flutter/pages/todo_list_page.dart';

void main() => runApp( MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Retrieve Text Input',
      home: TodoListPage(),
    );
  }
}

