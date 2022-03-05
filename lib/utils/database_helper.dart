import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:saveit/models/contact.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper{
  DatabaseHelper.privateConstructor();
  //DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper.privateConstructor();

  Database? _database;
  static const _databaseName = 'myDb.db';
  static const _databaseVersion = 1;
  static const _tableName = 'ContactTable';
  static const _idColumn = 'id';
  static const _nameColumn = 'name';
  static const _mobileColumn = 'mobile';

  Future<Database> get database async{
    if(_database != null){
      return _database!;
    }
    return await initializeDatabase();
  }

  Future<Database> initializeDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path,_databaseName);
    return await openDatabase(path,version: _databaseVersion,onCreate: onCreate);
  }

  onCreate(Database db,int databaseVersion){
    db.execute(
        '''
      CREATE TABLE $_tableName(
      $_idColumn INTEGER PRIMARY KEY,
      $_nameColumn TEXT NOT NULL,
      $_mobileColumn TEXT NOT NULL
    )
    '''
    );
  }

  Future<int> insert(Map<String,dynamic> row)async{
    Database db = await instance.database;
    return await db.insert(_tableName, row);
  }

  Future<List<Map<String,dynamic>>> query()async{
    Database db = await instance.database;
    return await db.query(_tableName);
  }

  Future<int> update(Contact contacts)async{
    Database db = await instance.database;
    Contact contact = Contact();
    return db.update(_tableName, contact.toMap(),where: '${contact.id}=?', whereArgs: [contact.id]);
  }
}