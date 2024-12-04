import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  late Box _todoBox;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  void _openBox() async {
    _todoBox = await Hive.openBox('todoBox');
    setState(() {});
  }

  void _addTodoItem() {
    final String newTask = _controller.text;
    if (newTask.isNotEmpty) {
      _todoBox.add(newTask);
      _controller.clear();
      setState(() {});
    }
  }

  void _deleteTodoItem(int index) {
    _todoBox.deleteAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
      ),
      body: _todoBox.isOpen
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter a task...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _addTodoItem,
                  child: const Text('Add Task'),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _todoBox.length,
                    itemBuilder: (context, index) {
                      final task = _todoBox.getAt(index);
                      return ListTile(
                        title: Text(task),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteTodoItem(index),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
