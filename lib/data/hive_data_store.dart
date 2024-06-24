import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/models/task.dart';

/// All the [CRUD] operations for Hive DB
class HiveDataStore {
  /// Box Name - String
  static const String boxName = 'taskBox';

  /// Current Box
  final Box<Task> box = Hive.box<Task>(boxName);

  /// Add New Task
  Future<void> addTask({required Task task}) async {
    await box.put(task.id, task);
  }

  /// Show Task
  Future<Task?> getTask({required int id}) async {
    return box.get(id);
  }

  /// Update Task
  Future<void> updateTask({required Task task}) async {
    await task.save();
  }

  /// Delete Task
  Future<void> deleteTask({required Task task}) async {
    await task.delete();
  }

  /// Listen to Box Changes
  ValueListenable<Box<Task>> listenToTasks() => box.listenable();
}