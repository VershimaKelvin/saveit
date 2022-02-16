import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper{
  DatabaseHelper._();
  DatabaseHelper instance = DatabaseHelper._();

  Database? _database;
  static const databaseName = 'myDb.db';
  static const databaseVersion = 1;
  static const tableName = 'ContactTable';
  static const idColumn = 'id';
  static const nameColumn = 'name';
  static const mobileColumn = 'mobile';

  Future<Database> get database async{
    if(_database != null){
      return _database!;
    }
    return await initializeDatabase();
  }

  Future<Database> initializeDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path,databaseName);
    return await openDatabase(path,version: 1,onCreate: onCreate);
  }
  onCreate(Database db,int databaseVersion){
    db.execute('''
      CREATE TABLE $tableName(
      $idColumn INTEGER PRIMARY KEY,
      $nameColumn TEXT NOT NULL,
      $mobileColumn TEXT NOT NULL
    )
    '''
    );
  }
}