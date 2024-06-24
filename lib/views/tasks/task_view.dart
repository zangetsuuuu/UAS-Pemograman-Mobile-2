import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/extensions/space_exs.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/utils/app_colors.dart';
import 'package:todo_app/utils/app_str.dart';
import 'package:todo_app/utils/constants.dart';
import 'package:todo_app/views/tasks/components/date_time_selection.dart';
import 'package:todo_app/views/tasks/components/rep_textfield.dart';
import 'package:todo_app/views/tasks/widget/task_view_app_bar.dart';

class TaskView extends StatefulWidget {
  const TaskView(
      {super.key,
      required this.titleTaskController,
      required this.descriptionTaskController,
      required this.task});

  final TextEditingController? titleTaskController;
  final TextEditingController? descriptionTaskController;
  final Task? task;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  var title;
  var subTitle;
  DateTime? time;
  DateTime? date;

  String showTime(DateTime? time) {
    if (widget.task?.createdAtTime == null) {
      if (time == null) {
        return DateFormat('hh:mm a').format(DateTime.now()).toString();
      } else {
        return DateFormat('hh:mm a').format(time).toString();
      }
    } else {
      return DateFormat('hh:mm a')
          .format(widget.task!.createdAtTime)
          .toString();
    }
  }

  String showDate(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
      } else {
        return DateFormat('dd/MM/yyyy').format(date).toString();
      }
    } else {
      return DateFormat('dd/MM/yyyy')
          .format(widget.task!.createdAtDate)
          .toString();
    }
  }

  DateTime showDateAsDateTime(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateTime.now();
      } else {
        return date;
      }
    } else {
      return widget.task!.createdAtDate;
    }
  }

  /// If any task already exists
  bool isTaskAlreadyExists() {
    if (widget.titleTaskController?.text == null &&
        widget.descriptionTaskController?.text == null) {
      return true;
    } else {
      return false;
    }
  }

  /// Main function for creating task and updating task
  dynamic isTaskAlreadyExistUpdateOtherWiseCreate() {
    // Update existing task
    if (widget.titleTaskController?.text != null &&
        widget.descriptionTaskController?.text != null) {
      try {
        widget.titleTaskController?.text = title;
        widget.descriptionTaskController?.text = subTitle;
        widget.task?.save();

        Navigator.pop(context);
      } catch (e) {
        updateTaskWarning(context);
      }
    }
    // Create new task
    else {
      if (title != null && subTitle != null) {
        var task = Task.create(
          title: title,
          subTitle: subTitle,
          createdAtDate: date,
          createdAtTime: time,
        );

        BaseWidget.of(context).dataStore.addTask(task: task);

        Navigator.pop(context);
      } else {
        emptyWarning(context); // Title or subtitle is null
      }
    }
  }

  /// Delete task
  dynamic deleteTask() {
    return widget.task?.delete();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,

        /// App Bar
        appBar: const TaskViewAppBar(),

        /// Body
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                /// Top Side Texts
                _buildTopSideTexts(textTheme),

                /// Main Task View Activity
                _buildMainTaskViewActivity(textTheme, context),

                /// Bottom Side Texts
                _buildBottomSideButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSideButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: isTaskAlreadyExists()
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceEvenly,
        children: [
          isTaskAlreadyExists()
              ? Container()
              :

              /// Delete current task button
              MaterialButton(
                  onPressed: () {
                    deleteTask();
                    Navigator.pop(context);
                  },
                  minWidth: 150,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: 55,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.close_rounded,
                        color: AppColors.primaryColor,
                      ),
                      5.w,
                      const Text(
                        AppStr.deleteTask,
                        style: TextStyle(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),

          /// Add or update task button
          MaterialButton(
            onPressed: () {
              isTaskAlreadyExistUpdateOtherWiseCreate();
            },
            minWidth: 150,
            color: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            height: 55,
            child: Row(
              children: [
                Icon(
                  isTaskAlreadyExists() ? Icons.add_rounded : Icons.check,
                  color: Colors.white,
                ),
                5.w,
                Text(
                  isTaskAlreadyExists()
                      ? AppStr.addTaskString
                      : AppStr.updateTaskString,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Main Task View Activity
  Widget _buildMainTaskViewActivity(TextTheme textTheme, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 530,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title of TextFiled
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(
              AppStr.titleOfTitleTextField,
              style: textTheme.headlineMedium,
            ),
          ),

          /// Task Title
          RepTextField(
            controller: widget.titleTaskController,
            onFieldSubmitted: (String inputTitle) {
              title = inputTitle;
            },
            onChanged: (String inputTitle) {
              title = inputTitle;
            },
          ),

          10.h,

          /// Task Description
          RepTextField(
            controller: widget.descriptionTaskController,
            isForDescription: true,
            onFieldSubmitted: (String inputSubTitle) {
              subTitle = inputSubTitle;
            },
            onChanged: (String inputSubTitle) {
              subTitle = inputSubTitle;
            },
          ),

          /// Time Selection
          DateTimeSelectionWidget(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => SizedBox(
                  height: 280,
                  child: TimePickerWidget(
                    initDateTime: showDateAsDateTime(time),
                    dateFormat: 'HH:mm',
                    onChange: (_, __) {},
                    onConfirm: (dateTime, _) {
                      setState(() {
                        if (widget.task?.createdAtTime == null) {
                          time = dateTime;
                        } else {
                          widget.task!.createdAtTime = dateTime;
                        }
                      });
                    },
                  ),
                ),
              );
            },
            title: AppStr.timeString,
            time: showTime(time),
          ),

          /// Date Selection
          DateTimeSelectionWidget(
            onTap: () {
              DatePicker.showDatePicker(
                context,
                maxDateTime: DateTime(2030, 4, 5),
                minDateTime: DateTime.now(),
                initialDateTime: showDateAsDateTime(date),
                onConfirm: (dateTime, _) {
                  setState(() {
                    if (widget.task?.createdAtTime == null) {
                      date = dateTime;
                    } else {
                      widget.task!.createdAtDate = dateTime;
                    }
                  });
                },
              );
            },
            title: AppStr.dateString,
            time: showDate(date),
          ),
        ],
      ),
    );
  }

  /// Top Side Texts
  Widget _buildTopSideTexts(TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 100,
            child: Divider(
              thickness: 1,
            ),
          ),
          RichText(
              text: TextSpan(
            text: isTaskAlreadyExists()
                ? AppStr.addNewTask
                : AppStr.updateCurrentTask,
            style: textTheme.titleLarge,
          )),
          const SizedBox(
            width: 100,
            child: Divider(
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
