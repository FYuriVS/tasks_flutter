import 'package:flutter/material.dart';
import 'package:tasks_flutter/models/todo.dart';
import 'package:tasks_flutter/repository/todo_repository.dart';
import 'package:tasks_flutter/widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();


  List<Todo> todos = [];
  Todo? deletedTodo;
  int? deletedTodoPosition;

  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then((value) =>
    {
      setState(() {
        todos = value;
      })
    });
  }

    @override
    void dispose() {
      todoController.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return SafeArea(
        child: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: todoController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Adicione uma Tarefa',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          String text = todoController.text;
                          setState(() {
                            Todo newTodo =
                            Todo(title: text, dateTime: DateTime.now());
                            if (todoController.text.isNotEmpty) {
                              todos.add(newTodo);
                              todoController.clear();
                              todoRepository.saveTodoList(todos);
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            shape: const BeveledRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5)))),
                        child: const Icon(
                          Icons.add,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        for (Todo todo in todos)
                          TodoListItem(todo: todo, onDelete: onDelete),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                                    'Você possui ${todos
                                        .length} tarefas pendentes')),
                            const SizedBox(
                              width: 8,
                            ),
                            ElevatedButton(
                              onPressed: showDeleteTodosConfirmDialog,
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(12),
                                  shape: const BeveledRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(5)))),
                              child: const Text('Limpar Tudo'),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

    void onDelete(Todo todo) {
      deletedTodo = todo;
      deletedTodoPosition = todos.indexOf(todo);
      setState(() {
        todos.remove(todo);
        todoRepository.saveTodoList(todos);
      });

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Tarefa: ${todo.title} foi removida!",
            style: TextStyle(color: Theme
                .of(context)
                .primaryColor),
          ),
          backgroundColor: Colors.white,
          action: SnackBarAction(
            label: "Desfazer",
            textColor: Theme
                .of(context)
                .primaryColor,
            onPressed: () {
              setState(() {
                todos.insert(deletedTodoPosition!, deletedTodo!);
              });
            },
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    }

    void showDeleteTodosConfirmDialog() {
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text("Limpar tudo?"),
              content: Text("Você deseja limpar todas as tarefas?"),
              actions: [
                TextButton(onPressed: () {
                  Navigator.of(context).pop();
                }, child: Text("Cancelar")),
                TextButton(onPressed: () {
                  setState(() {
                    todos.clear();
                  });
                  Navigator.of(context).pop();
                }, child: Text("Limpar tudo"))
              ],
            ),
      );
    }
  }
