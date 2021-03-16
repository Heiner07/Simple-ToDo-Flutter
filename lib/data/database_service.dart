import 'dart:io';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const _DATABASE_SCRIPT_PATH = "assets/sql/dbScript.sql";
const _DATABASE_SCRIPT_QUERY_SEPARATOR = ";";

const DATABASE_NAME = "simple_ToDo.db";
const CURRENT_DB_VERSION = 1;

class DatabaseService {
  Database _database;

  Future<Database> getDatabase() async {
    await initializeDB();
    return Future.value(_database);
  }

  Future<void> initializeDB() async {
    if (_database == null) {
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, DATABASE_NAME);

      await Directory(databasesPath).create(recursive: true);

      _database = await openDatabase(
        path,
        version: CURRENT_DB_VERSION,
        onCreate: _createDatabase,
      );
    }
  }

  void _createDatabase(Database db, int version) async {
    List<String> queries = await _getDatabaseQueries();
    // Creating the tables here
    queries.forEach((query) async => await db.execute(query));
  }

  Future<List<String>> _getDatabaseQueries() async {
    // Get the file with the queries
    final String dbScript = await rootBundle.loadString(_DATABASE_SCRIPT_PATH);
    final fixedScript = dbScript.replaceAll("\n", "");
    final queries = fixedScript.split(_DATABASE_SCRIPT_QUERY_SEPARATOR);
    return queries.sublist(0, queries.length - 1);
  }
}
