import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/data/hive_data_store.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/views/home/home_view.dart';
// import 'package:todo_app/views/tasks/task_view.dart';

Future<void> main() async {
  /// Initialize Hive
  await Hive.initFlutter();

  /// Register Adapter
  Hive.registerAdapter<Task>(TaskAdapter());

  /// Open Box
  // ignore: unused_local_variable
  Box box = await Hive.openBox<Task>(HiveDataStore.boxName);

  // for (var task in box.values) {
  //   if (task.createdAtTime.day != DateTime.now().day) {
  //     task.delete();
  //   } else {
  //     /// Do nothing
  //   }
  // }

  runApp(BaseWidget(child: const MyApp()));
}

class BaseWidget extends InheritedWidget {
  BaseWidget({super.key, required this.child}) : super(child: child);

  final HiveDataStore dataStore = HiveDataStore();
  @override
  final Widget child;

  static BaseWidget of(BuildContext context) {
    final base = context.dependOnInheritedWidgetOfExactType<BaseWidget>();
    if (base != null) {
      return base;
    } else {
      throw StateError('Could not find ancestor widget of type BaseWidget.');
    }
  }
  
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    throw UnimplementedError();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: ThemeData(
          textTheme: const TextTheme(
              displayLarge: TextStyle(
                  color: Colors.black,
                  fontSize: 45,
                  fontWeight: FontWeight.bold),
              titleMedium: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w300),
              displayMedium: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              displaySmall: TextStyle(
                  color: Color.fromARGB(255, 234, 234, 234),
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
              headlineMedium: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              headlineSmall: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
              titleSmall:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
              titleLarge: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.w500))),
      home: const HomeView(),
      // home: const TaskView(),
    );
  }
}

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
