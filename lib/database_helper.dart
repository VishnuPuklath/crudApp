import 'dart:async';
import 'dart:io';
import 'package:helper/contact.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{

static const _databaseName='ContactData.db';
static const _databaseVersion=1;

//singleton class
 DatabaseHelper._();

 static final DatabaseHelper instance = DatabaseHelper._();

   Database? _database;

 Future<Database> get database async{
   if(_database!= null) return _database!;
   _database =await initDatabase();
   return _database!;

 }

  initDatabase() async{
    Directory directory=await getApplicationDocumentsDirectory();
    String path=join(directory.path,_databaseName);
   return await openDatabase(path,version: _databaseVersion,onCreate: _onCreateDB);
  }



  FutureOr<void> _onCreateDB(Database db, int version) async{
    await db.execute('''
    CREATE TABLE ${Contact.tblContact}(
      ${Contact.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${Contact.colName} TEXT NOT NULL,
      ${Contact.colMobile} TEXT NOT NULL
    )
''');
  }

  Future<int> insertContact(Contact contact) async{
    
       Database db=await database;
     return await db.insert(Contact.tblContact,contact.toMap());
     
  }
  Future<List<Contact>> fetchContacts() async{
     Database db=await database;
     List<Map> contacts=await db.query(Contact.tblContact);
     return contacts.isEmpty?[]:contacts.map((e) => Contact.fromMap(e)).toList();

  }

  Future<int> updateContact(Contact contact) async{
       Database db=await database;
     return await db.update(Contact.tblContact,contact.toMap(),where: '${Contact.colId}==?',whereArgs: [contact.id]);
     
  }
  
  Future<int> deleteContact(int id) async{
       Database db=await database;
     return await db.delete(Contact.tblContact,where: '${Contact.colId}==?',whereArgs: [id]);
     
  }
  }
