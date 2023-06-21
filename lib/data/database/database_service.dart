import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static const dbName = 'data.db';
  static const dbVersion = 1;
  static const tableName = 'transactions';
  static const columnID = 'columnID';
  static const type = 'type';
  static const date = 'date';
  static const data = 'data';

  /// Singleton
  DatabaseService._privateConstructor();

  static final DatabaseService instance = DatabaseService._privateConstructor();

  /// Initialize Database
  Database? database; // Make database field nullable

  Future<Database> get db async {
    database ??= await initializeDatabase(); // Initialize if null
    return database!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbName);
    return await openDatabase(path, version: dbVersion, onCreate: createTable);
  }

  void createTable(Database db, int version) {
    db.execute('''
    CREATE TABLE $tableName(
      $columnID INTEGER PRIMARY KEY,
      $type TEXT NOT NULL,
      $data REAL NOT NULL,
      $date TEXT NOT NULL
    )
    ''');
    if (kDebugMode) {
      print('Table is created');
    }
  }

  Future<int> addTransactions(Map<String, dynamic> row) async {
    Database db = await instance.db;
    return await db.insert(tableName, row);
  }

  Future<int> deleteTransactions(int? id) async {
    Database db = await instance.db;
    return await db.delete(tableName, where: '$columnID = ?', whereArgs: [id.toString()]);
  }

  Future<List<Map<String, Object?>>> getTransaction(String category) async {
    Database db = await instance.db;
    if (category == 'All') {
      return await db.rawQuery('SELECT * FROM transactions');
    } else {
      return await db.rawQuery(
          'SELECT * FROM transactions WHERE type=?', [(category)]);
    }
  }
}
