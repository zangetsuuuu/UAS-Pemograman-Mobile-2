import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_app/extensions/space_exs.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/utils/app_colors.dart';
import 'package:todo_app/utils/app_str.dart';
import 'package:todo_app/views/home/components/home_app_bar.dart';
import 'package:todo_app/views/home/components/slider_drawer.dart';
import 'package:todo_app/utils/constants.dart';
import 'package:todo_app/views/home/components/fab.dart';
import 'package:todo_app/views/home/widget/task_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GlobalKey<SliderDrawerState> drawerKey = GlobalKey<SliderDrawerState>();

  /// Circle indicator
  dynamic valueOfIndicator(List<Task> task) {
    if (task.isNotEmpty) {
      return task.length;
    } else {
      return 3;
    }
  }

  /// Chechk done task
  int checkDoneTask(List<Task> tasks) {
    int i = 0;
    for (Task doneTask in tasks) {
      if (doneTask.isCompleted) {
        i++;
      }
    }
    return i;
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    final base = BaseWidget.of(context);

    return ValueListenableBuilder(
        valueListenable: base.dataStore.listenToTasks(),
        builder: (ctx, Box<Task> box, Widget? child) {
          var tasks = box.values.toList();

          tasks.sort((a, b) => a.createdAtTime.compareTo(b.createdAtTime));

          return Scaffold(
            backgroundColor: Colors.white,

            /// FAB
            floatingActionButton: const Fab(),

            /// Body
            body: SliderDrawer(
              key: drawerKey,
              isDraggable: false,
              animationDuration: 500,

              /// Drawer
              slider: CustomerDrawer(),

              appBar: HomeAppBar(
                drawerKey: drawerKey,
              ),

              /// Main Body
              child: _buildHomeBody(textTheme, base, tasks),
            ),
          );
        });
  }

  /// Home Body
  Widget _buildHomeBody(
      TextTheme textTheme, BaseWidget base, List<Task> tasks) {
    return SizedBox.expand(
      // width: double.infinity,
      // height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            /// Custom App Bar
            Container(
              margin: const EdgeInsets.only(top: 40),
              width: double.infinity,
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Progress Indicator
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      value: checkDoneTask(tasks) / valueOfIndicator(tasks),
                      backgroundColor: Colors.grey,
                      valueColor:
                          const AlwaysStoppedAnimation(AppColors.primaryColor),
                    ),
                  ),

                  /// Space
                  24.w,

                  /// Top Level Task info
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        AppStr.mainTitle,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontWeight: FontWeight.bold),
                      ),
                      1.h,
                      Text(
                        '${checkDoneTask(tasks)} dari ${tasks.length} tugas yang harus diselesaikan',
                        style: textTheme.titleMedium?.copyWith(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// Divider
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Divider(
                thickness: 1,
                // indent: 100,
              ),
            ),

            /// Task List
            SizedBox(
              width: double.infinity,
              height: 800,
              child: tasks.isNotEmpty

                  /// Task list is not empty
                  ? ListView.builder(
                      itemCount: tasks.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        var task = tasks[index];
                        return Dismissible(
                          direction: DismissDirection.horizontal,
                          onDismissed: (_) {
                            base.dataStore.deleteTask(task: task);
                          },
                          background: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.delete_outline,
                                color: Colors.grey,
                              ),
                              8.w,
                              const Text(
                                AppStr.deletedTask,
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                          key: Key(task.id),
                          child: TaskWidget(task: task),
                        );
                      })

                  /// Task list is empty
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// Lottie Animation
                        FadeIn(
                          child: SizedBox(
                            width: 300,
                            height: 300,
                            child: Lottie.asset(lottieURL,
                                animate: tasks.isNotEmpty ? false : true),
                          ),
                        ),

                        /// Subtext
                        FadeInUp(
                          from: 30,
                          child: const Text(
                            AppStr.doneAllTask,
                          ),
                        )
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }
}
