import 'package:simple_to_do/data/database_service.dart';
import 'package:simple_to_do/models/to_do.dart';
import 'package:sqflite/sqflite.dart';

const TO_DO_TABLE = "ToDos";
const PK_TO_DO_TABLE = "id";

class ToDoService {
  ToDoService(this.dbService);

  final DatabaseService dbService;
  Database _db;

  Future<void> _initializeDB() async {
    _db = await dbService.getDatabase();
  }

  Future<List<ToDo>> getAll() async {
    await _initializeDB();
    final toDos = await _db.query(TO_DO_TABLE);
    if (toDos != null) {
      if (toDos.isNotEmpty) {
        return toDos.map((toDoMap) => ToDo.fromMap(toDoMap)).toList();
      }

      return [];
    }

    return null;
  }

  Future<ToDo> get(int id) async {
    await _initializeDB();
    final toDos = await _db
        .query(TO_DO_TABLE, where: "$PK_TO_DO_TABLE = ?", whereArgs: [id]);
    if (toDos != null && toDos.isNotEmpty) {
      return ToDo.fromMap(toDos[0]);
    }
    return null;
  }

  Future<ToDo> add(ToDo toDo) async {
    await _initializeDB();
    final id = await _db.insert(TO_DO_TABLE, toDo.toMap());
    return get(id);
  }

  Future<ToDo> update(ToDo toDo) async {
    await _initializeDB();
    await _db.update(TO_DO_TABLE, toDo.toMap(),
        where: "$PK_TO_DO_TABLE = ?", whereArgs: [toDo.id]);
    return toDo;
  }

  Future<ToDo> delete(ToDo toDoToDelete) async {
    await _initializeDB();
    final toDo = await get(toDoToDelete.id);
    if (toDo != null) {
      final rowsAffected = await _db.delete(TO_DO_TABLE,
          where: "$PK_TO_DO_TABLE = ?", whereArgs: [toDoToDelete.id]);
      if (rowsAffected == 0) {
        return null;
      }
    }
    return toDo;
  }
}
