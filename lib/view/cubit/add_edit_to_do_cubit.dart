import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:simple_to_do/data/to_do_service.dart';
import 'package:simple_to_do/models/to_do.dart';
import 'package:simple_to_do/view/cubit/to_dos_cubit.dart';

part 'add_edit_to_do_state.dart';

class AddEditToDoCubit extends Cubit<AddEditToDoState> {
  AddEditToDoCubit({
    @required this.toDoService,
    @required this.toDosCubit,
    ToDo toDo,
  }) : super(toDo == null
            ? AddEditToDoState()
            : AddEditToDoState.withToDo(toDo));

  final ToDoService toDoService;
  final ToDosCubit toDosCubit;

  void onToDoValueChanged(String value) {
    emit(state.copyWith(toDoValue: value));
  }

  void onToDoDetailsChanged(String value) {
    emit(state.copyWith(toDoDetails: value));
  }

  void onToDoIsDoneChanged() {
    emit(state.copyWith(isDone: !state.isDone));
  }

  bool _isToDoValueCorrect() {
    return state.toDoValue.isNotEmpty && !state.toDoValue.startsWith(" ");
  }

  Future<void> submit() async {
    if (_isToDoValueCorrect()) {
      emit(state.copyWith(addEditState: AddEditState.LOADING));
      if (state.editing) {
        final toDoUpdated = await toDoService.update(state.toDo.copyWith(
          toDoValue: state.toDoValue.trim(),
          toDoDetails: state.toDoDetails.trim(),
          isDone: state.isDone,
        ));

        if (toDoUpdated != null) {
          toDosCubit.updatedToDo(toDoUpdated);
        } else {
          emit(state.copyWith(addEditState: AddEditState.ERROR));
          return;
        }
      } else {
        final toDoAdded = await toDoService.add(ToDo(
          id: null,
          toDoValue: state.toDoValue.trim(),
          toDoDetails: state.toDoDetails.trim(),
          isDone: state.isDone,
        ));

        if (toDoAdded != null) {
          toDosCubit.addToDo(toDoAdded);
        } else {
          emit(state.copyWith(addEditState: AddEditState.ERROR));
          return;
        }
      }
      emit(state.copyWith(addEditState: AddEditState.SAVED));
    }
  }

  Future<void> deleteToDo() async {
    if (state.toDo != null) {
      emit(state.copyWith(addEditState: AddEditState.LOADING));

      final toDoDeleted = await toDoService.delete(state.toDo);

      if (toDoDeleted != null) {
        toDosCubit.deleteToDo(toDoDeleted);
      } else {
        emit(state.copyWith(addEditState: AddEditState.ERROR));
        return;
      }

      emit(state.copyWith(addEditState: AddEditState.SAVED));
    }
  }
}
