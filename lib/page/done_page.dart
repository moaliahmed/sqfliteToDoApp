import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/controller/cubit/tacks_cubit.dart';
import 'package:todo/controller/cubit/tacks_state.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DoneScreen extends StatelessWidget {
  const DoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: BlocConsumer<TasksCubit, TasksState>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = TasksCubit.get(context);
            return cubit.doneTasks.isEmpty
                ? Container()
                : ListView.separated(
                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.teal,
                      thickness: 1,
                      height: 20,
                      indent: 9,
                    ),
                    itemCount: cubit.doneTasks.length,
                    itemBuilder: (context, index) {
                      return Slidable(
                        key: Key(cubit.doneTasks[index]['id'].toString()),
                        endActionPane: ActionPane(
                          motion: const BehindMotion(),

                          children: [
                            SlidableAction(
                              onPressed: (context) {},
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                cubit.updateDatabase(
                                    status: 'archive',
                                    id: cubit.doneTasks[index]['id']);
                              },
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              icon: Icons.archive_outlined,
                            ),
                          ],
                        ),
                        child: TaskItem(
                          title: cubit.doneTasks[index]['title'],
                          time: cubit.doneTasks[index]['time'],
                          date: cubit.doneTasks[index]['date'],
                        ),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  const TaskItem(
      {super.key, required this.title, required this.time, required this.date});

  final String title;
  final String time;
  final String date;

  @override
  Widget build(
    BuildContext context,
  ) {
    final slidAble = Slidable.of(context)!;
    return InkWell(
      onTap: () => slidAble.close(),
      onDoubleTap: () => slidAble.openEndActionPane(),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.teal,
            child: Text(
              time,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(date),
              ],
            ),
          )
        ],
      ),
    );
  }
}
