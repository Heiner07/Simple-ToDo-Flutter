import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_to_do/injection.dart' as getIt;
import 'package:simple_to_do/view/cubit/to_dos_cubit.dart';
import 'package:simple_to_do/view/screens/add_edit_to_do_screen.dart';
import 'package:simple_to_do/view/screens/to_dos_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  getIt.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ToDosCubit>(
      create: (context) =>
          ToDosCubit(toDoService: getIt.getIt())..getAllToDos(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.red,
          primaryColor: Colors.red,
          accentColor: Colors.redAccent,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: Brightness.dark,
        ),
        routes: {
          "AddEditToDo": (context) {
            return AddEditToDoScreen();
          }
        },
        home: ToDosScreen(),
      ),
    );
  }
}
