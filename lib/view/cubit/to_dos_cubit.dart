import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:simple_to_do/data/to_do_service.dart';
import 'package:simple_to_do/models/to_do.dart';

part 'to_dos_state.dart';

class ToDosCubit extends Cubit<ToDosState> {
  ToDosCubit({@required this.toDoService}) : super(ToDosLoading());

  final ToDoService toDoService;

  void getAllToDos() async {
    emit(ToDosLoading());
    final toDos = await toDoService.getAll();
    if (toDos != null) {
      if (toDos.isEmpty) {
        emit(ToDosEmpty());
        return;
      }

      emit(ToDosLoaded(toDos));
    } else {
      emit(ToDosFailedLoad("Error loading the ToDos"));
    }
  }

  void addToDo(ToDo newToDo) {
    if (state is ToDosFailedLoad) {
      return;
    }

    if (state is ToDosEmpty) {
      emit(ToDosLoaded([newToDo]));
    } else if (state is ToDosLoaded) {
      final toDos = (state as ToDosLoaded).toDos.toList();
      toDos.add(newToDo);
      emit(ToDosLoaded(toDos));
    }
  }

  void updatedToDo(ToDo toDoChanged) {
    if (state is ToDosLoaded) {
      final toDos = (state as ToDosLoaded).toDos.toList();
      final index = toDos.indexWhere((toDo) => toDo.id == toDoChanged.id);
      if (index > -1) {
        toDos[index] = toDoChanged;
        emit(ToDosLoaded(toDos));
      }
    }
  }

  void updateToDoIsDone(ToDo toDoToChange) async {
    if (state is ToDosLoaded) {
      final toDos = (state as ToDosLoaded).toDos.toList();
      final toDoChanged = await toDoService
          .update(toDoToChange.copyWith(isDone: !toDoToChange.isDone));
      if (toDoChanged != null) {
        final index = toDos.indexWhere((toDo) => toDo.id == toDoChanged.id);
        if (index > -1) {
          toDos[index] = toDoChanged;
          emit(ToDosLoaded(toDos));
        }
      }
    }
  }

  void deleteToDo(ToDo toDoDelete) {
    if (state is ToDosLoaded) {
      final toDos = (state as ToDosLoaded).toDos.toList();
      final index = toDos.indexWhere((toDo) => toDo.id == toDoDelete.id);
      if (index > -1) {
        toDos.removeAt(index);
        if (toDos.isEmpty) {
          emit(ToDosEmpty());
        } else {
          emit(ToDosLoaded(toDos));
        }
      }
    }
  }
}
