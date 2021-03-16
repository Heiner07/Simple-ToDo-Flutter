import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_to_do/models/to_do.dart';
import 'package:simple_to_do/view/cubit/to_dos_cubit.dart';
import 'package:simple_to_do/view/helpers/add_edit_to_do_screen_arguments.dart';

class ToDosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Simple ToDo"),
      ),
      body: BlocConsumer<ToDosCubit, ToDosState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is ToDosLoaded) {
            final List<ToDo> toDos = state.toDos;
            return ListView.separated(
              itemCount: toDos.length,
              separatorBuilder: (context, index) {
                return Divider(
                  color: Theme.of(context).primaryColor,
                  thickness: 2,
                );
              },
              itemBuilder: (context, index) {
                final ToDo toDo = toDos[index];
                return ListTile(
                  title: Text(toDo.toDoValue),
                  subtitle: Text(toDo.toDoDetails),
                  trailing: GestureDetector(
                    onTap: () {
                      context.read<ToDosCubit>().updateToDoIsDone(toDo);
                    },
                    child: Icon(
                      Icons.check_circle,
                      color: toDo.isDone
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                      size: 28,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, "AddEditToDo",
                        arguments: AddEditToDoScreenArguments(toDo));
                  },
                );
              },
            );
          } else if (state is ToDosLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ToDosEmpty) {
            return Center(
              child: Text(
                "There are not ToDos, add one with the button below",
                textAlign: TextAlign.center,
              ),
            );
          }
          return Center(
            child: Text(
              "Error loading the ToDos",
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "AddEditToDo",
              arguments: AddEditToDoScreenArguments(null));
        },
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }
}
