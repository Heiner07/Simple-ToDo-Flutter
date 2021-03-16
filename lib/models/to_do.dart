import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class ToDo extends Equatable {
  const ToDo({
    @required this.id,
    @required this.toDoValue,
    this.toDoDetails,
    @required this.isDone,
  });

  final int id;
  final String toDoValue;
  final String toDoDetails;
  final bool isDone;

  @override
  List<Object> get props => [id, toDoValue, toDoDetails, isDone];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'toDoValue': toDoValue,
      'toDoDetails': toDoDetails,
      'isDone': isDone ? 1 : 0,
    };
  }

  factory ToDo.fromMap(Map<String, dynamic> map) {
    return ToDo(
      id: map['id'],
      toDoValue: map['toDoValue'],
      toDoDetails: map['toDoDetails'],
      isDone: map['isDone'] == 0 ? false : true,
    );
  }

  String toJson() => json.encode(toMap());

  factory ToDo.fromJson(String source) => ToDo.fromMap(json.decode(source));

  ToDo copyWith({
    int id,
    String toDoValue,
    String toDoDetails,
    bool isDone,
  }) {
    return ToDo(
      id: id ?? this.id,
      toDoValue: toDoValue ?? this.toDoValue,
      toDoDetails: toDoDetails ?? this.toDoDetails,
      isDone: isDone ?? this.isDone,
    );
  }
}
