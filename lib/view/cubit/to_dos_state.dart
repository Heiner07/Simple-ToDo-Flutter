part of 'to_dos_cubit.dart';

abstract class ToDosState extends Equatable {
  const ToDosState();

  @override
  List<Object> get props => [];
}

class ToDosLoading extends ToDosState {}

class ToDosLoaded extends ToDosState {
  const ToDosLoaded(this.toDos);

  final List<ToDo> toDos;

  @override
  List<Object> get props => [toDos];

  ToDosLoaded copyWith({
    List<ToDo> toDos,
  }) {
    return ToDosLoaded(
      toDos ?? this.toDos,
    );
  }
}

class ToDosEmpty extends ToDosState {}

class ToDosFailedLoad extends ToDosState {
  const ToDosFailedLoad(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
