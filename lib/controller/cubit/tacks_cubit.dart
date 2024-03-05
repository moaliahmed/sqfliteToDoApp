import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/controller/cubit/tacks_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import '../../page/archive_page.dart';
import '../../page/done_page.dart';
import '../../page/tacks_page.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(TasksInitialState());

  static TasksCubit get(context) => BlocProvider.of(context);
  int currentScreen = 0;
  IconData fabIcon = Icons.edit;
  bool isShowButtonSheet = false;
  List<Widget> screen = [
    const TacksScreen(),
    const DoneScreen(),
    const ArchiveScreen()
  ];

  changeScreen(int index) {
    currentScreen = index;
    emit(ChangeButtonNavBarState());
  }

  changeButtonSheet({required bool change, required IconData icon}) {
    isShowButtonSheet = change;
    fabIcon = icon;
    emit(ChangeButtonSheetState());
  }

  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) {
        // id integer
        // title String
        // time String
        // data String
        // status String
        db
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT,time TEXT,date TEXT,status TEXT)')
            .then((value) {
          print('table create');
        }).catchError((error) {
          print('Error when create table ${error.toString()}');
        });
      },
      onOpen: (db) {
        getFromDatabase(db);
        print('database opened');
      },
    ).then((value) {
      database = value;
      print('database create');
      emit(CreateDatabaseState());
    });
  }

  getFromDatabase(database) {
    archiveTasks=[];
    newTasks=[];
    doneTasks=[];
    database.rawQuery('SELECT * FROM tasks').then((value) {
      print(value);
      value.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'archive')
          archiveTasks.add(element);
        else
          doneTasks.add(element);
      });

      emit(GetDatabaseState());
    });
  }

//title TEXT,time TEXT,date TEXT,status TEXT
  Future insertDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    return await database.transaction(
      (txn) => txn
          .rawInsert(
              'INSERT INTO tasks(title,time,date,status)VALUES("$title", "$time","$date","new" )')
          .then(
        (value) {
          print('$value Insert Successfully');
          emit(InsertDatabaseState());
          getFromDatabase(database);
        },
      ).catchError(
        (error) {
          print('Error When i Insert new Record $error');
        },
      ),
    );
  }

  updateDatabase({
    required String status,
    required int id,
  }) {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        [status, id]).then((value) {
          print ('update successfully');
          print('/////////$value');
      getFromDatabase(database);
      emit(UpdateDatabaseState());
    });
  }
}
