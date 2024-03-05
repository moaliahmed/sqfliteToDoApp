

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo/core/bloc_observer/cubit_observer.dart';
import 'package:todo/src/app_root.dart';

void main(){
  Bloc.observer= CubitObserver();
runApp(const AppRoot());

}
