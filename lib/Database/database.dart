import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'download_model.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentDirectory.path, 'database.db');

    if (kDebugMode) {}
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE download (id INTEGER,videopath TEXT,imagepath TEXT,type TEXT,PRIMARY KEY(id AUTOINCREMENT))');

    if (kDebugMode) {
      print('table create');
    }
  }

  Future<bool> isdownload(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('download', where: 'id = ?', whereArgs: [id]);
    return maps.isNotEmpty ? true : false;
  }

  Future addDownload(Download download) async {
    var db = await database;
    await db!.insert('download', download.toMap(), conflictAlgorithm: ConflictAlgorithm.replace).then((value) {
      print('addDownload----${value}');
    });

    return download;
  }

  Future<List<Download>> getDownload(String type) async {
    var db = await database;
    List<Map> maps = await db!.query('download', columns: ['id', 'videopath', 'imagepath', 'type'], where: 'type = ?', whereArgs: [type]);

    List<Download> download = [];
    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        download.add(Download.fromMap(maps[i]));
      }
    }
    return download;
  }

  Future<int> deleteDownload(int id) async {
    var db = await database;
    return await db!.delete(
      'download',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
