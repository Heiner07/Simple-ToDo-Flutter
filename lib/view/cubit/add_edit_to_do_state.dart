part of 'add_edit_to_do_cubit.dart';

enum AddEditState { NO_ACTION, LOADING, SAVED, ERROR }

class AddEditToDoState extends Equatable {
  const AddEditToDoState({
    this.toDoValue = "",
    this.toDoDetails = "",
    this.isDone = false,
    this.toDo,
    this.editing = false,
    this.addEditState = AddEditState.NO_ACTION,
  });

  factory AddEditToDoState.withToDo(ToDo toDo) {
    return AddEditToDoState(
      toDoValue: toDo.toDoValue,
      toDoDetails: toDo.toDoDetails,
      isDone: toDo.isDone,
      toDo: toDo,
      editing: true,
    );
  }

  final String toDoValue;
  final String toDoDetails;
  final bool isDone;
  final ToDo toDo;
  final bool editing;
  final AddEditState addEditState;

  @override
  List<Object> get props {
    return [
      toDoValue,
      toDoDetails,
      isDone,
      toDo,
      editing,
      addEditState,
    ];
  }

  AddEditToDoState copyWith({
    String toDoValue,
    String toDoDetails,
    bool isDone,
    ToDo toDo,
    bool editing,
    AddEditState addEditState,
  }) {
    return AddEditToDoState(
      toDoValue: toDoValue ?? this.toDoValue,
      toDoDetails: toDoDetails ?? this.toDoDetails,
      isDone: isDone ?? this.isDone,
      toDo: toDo ?? this.toDo,
      editing: editing ?? this.editing,
      addEditState: addEditState ?? this.addEditState,
    );
  }
}
