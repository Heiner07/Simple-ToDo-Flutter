import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_to_do/injection.dart';
import 'package:simple_to_do/models/to_do.dart';
import 'package:simple_to_do/view/cubit/add_edit_to_do_cubit.dart';
import 'package:simple_to_do/view/cubit/to_dos_cubit.dart';
import 'package:simple_to_do/view/helpers/add_edit_to_do_screen_arguments.dart';

class AddEditToDoScreen extends StatelessWidget {
  const AddEditToDoScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AddEditToDoScreenArguments arguments =
        ModalRoute.of(context).settings.arguments;
    final ToDo toDo = arguments.toDo;

    return BlocProvider(
      create: (context) => AddEditToDoCubit(
        toDo: toDo,
        toDosCubit: context.read<ToDosCubit>(),
        toDoService: getIt(),
      ),
      child: Builder(
        builder: (context) {
          return BlocListener<AddEditToDoCubit, AddEditToDoState>(
            listenWhen: (previous, current) =>
                previous.addEditState != current.addEditState,
            listener: (context, state) {
              if (state.addEditState == AddEditState.SAVED) {
                Navigator.pop(context);
              }
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(toDo != null ? "Edit ToDo" : "Add a ToDo"),
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const InputToDoValue(),
                      const InputToDoDetails(),
                      const SectionIsDone(),
                      const ButtonsSection(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ButtonsSection extends StatelessWidget {
  const ButtonsSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddEditToDoCubit, AddEditToDoState>(
      buildWhen: (previous, current) => previous.editing != current.editing,
      builder: (context, state) {
        if (state.editing) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _Button(
                    text: "Save",
                    backgroundColor: Colors.green,
                    onClick: () => context.read<AddEditToDoCubit>().submit(),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  _Button(
                    text: "Cancel",
                    textColor: Colors.black,
                    backgroundColor: Colors.white,
                    onClick: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(
                height: 28,
              ),
              _Button(
                text: "Delete",
                onClick: () => context.read<AddEditToDoCubit>().deleteToDo(),
              ),
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 24,
              ),
              _Button(
                text: "Add",
                backgroundColor: Colors.green,
                onClick: () => context.read<AddEditToDoCubit>().submit(),
              ),
            ],
          );
        }
      },
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    Key key,
    @required this.text,
    this.textColor,
    this.backgroundColor,
    @required this.onClick,
  }) : super(key: key);

  final String text;
  final Color textColor;
  final Color backgroundColor;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: ElevatedButton(
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
        onPressed: onClick,
        style: backgroundColor != null
            ? ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(backgroundColor),
              )
            : null,
      ),
    );
  }
}

class SectionIsDone extends StatelessWidget {
  const SectionIsDone({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddEditToDoCubit, AddEditToDoState>(
      buildWhen: (previous, current) => previous.isDone != current.isDone,
      builder: (context, state) {
        if (state.editing) {
          return Row(
            children: [
              Text("Done: "),
              IconButton(
                icon: Icon(
                  Icons.check_circle,
                  size: 28,
                  color: state.isDone
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                ),
                onPressed: () =>
                    context.read<AddEditToDoCubit>().onToDoIsDoneChanged(),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}

class InputToDoValue extends StatelessWidget {
  const InputToDoValue({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddEditToDoCubit, AddEditToDoState>(
      buildWhen: (previous, current) => previous.toDoValue != current.toDoValue,
      builder: (context, state) {
        return TextFormField(
          initialValue: state.toDoValue,
          onChanged: (value) =>
              context.read<AddEditToDoCubit>().onToDoValueChanged(value),
          decoration: InputDecoration(
            hintText: 'ToDo value',
          ),
        );
      },
    );
  }
}

class InputToDoDetails extends StatelessWidget {
  const InputToDoDetails({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddEditToDoCubit, AddEditToDoState>(
      buildWhen: (previous, current) =>
          previous.toDoDetails != current.toDoDetails,
      builder: (context, state) {
        return TextFormField(
          initialValue: state.toDoDetails,
          onChanged: (value) =>
              context.read<AddEditToDoCubit>().onToDoDetailsChanged(value),
          decoration: InputDecoration(
            hintText: 'ToDo details',
          ),
        );
      },
    );
  }
}
