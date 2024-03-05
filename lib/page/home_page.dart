import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/controller/cubit/tacks_cubit.dart';
import 'package:todo/controller/cubit/tacks_state.dart';
import 'package:todo/core/strings/app_string.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TasksCubit>(
      create: (context) => TasksCubit()..createDatabase(),
      child: BlocConsumer<TasksCubit, TasksState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = TasksCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: const Text(
                AppString.todoApp,
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.teal,
            ),
            body: cubit.screen[cubit.currentScreen],
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              elevation: 4,
              currentIndex: cubit.currentScreen,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.list_outlined), label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.done_outlined), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: 'Archive'),
              ],
              onTap: (value) {
                cubit.changeScreen(value);
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (!cubit.isShowButtonSheet) {
                  scaffoldKey.currentState!
                      .showBottomSheet((context) => buildButtonSheet(context))
                      .closed
                      .then((value) => cubit.changeButtonSheet(change: false,icon: Icons.edit));
                  cubit.changeButtonSheet(change: true,icon: Icons.add);
                } else {
                  if (formKey.currentState!.validate()) {
                    cubit.insertDatabase(title: titleController.text, time: timeController.text, date: dateController.text);
                   titleController.clear();
                   timeController.clear();
                   dateController.clear();
                    Navigator.pop(context);
                  }
                }
              },
              backgroundColor: Colors.teal,
              child: Icon(cubit.fabIcon,
                  color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  Widget buildButtonSheet(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                label: const Text('Inter Title'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Title must not be empty';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onTap: () {
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                ).then((value) =>
                    timeController.text = value!.format(context).toString());
              },
              controller: timeController,
              decoration: InputDecoration(
                label: const Text('Inter Time'),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Time must not be Empty';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onTap: () {
                showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.parse('2024-03-27'))
                    .then((value) => dateController.text =
                        DateFormat.yMMMd().format(value!));
              },
              controller: dateController,
              decoration: InputDecoration(
                label: const Text('Inter Data'),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return ' Data must not be Empty';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
