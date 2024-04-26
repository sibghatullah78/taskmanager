import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:is_fyp/models/users.dart';

class DatabaseHelper {
  final databaseName = "notes.db";
  String imagesTable =
      "CREATE TABLE images (imageId INTEGER PRIMARY KEY AUTOINCREMENT, imagePath TEXT NOT NULL)";

  String noteTable =
      "CREATE TABLE notes (noteId INTEGER PRIMARY KEY AUTOINCREMENT, noteTitle TEXT NOT NULL, noteContent TEXT NOT NULL, createdAt TEXT DEFAULT CURRENT_TIMESTAMP)";

  //Now we must create our user table into our sqlite db

  String users =
      "create table users (usrId INTEGER PRIMARY KEY AUTOINCREMENT, usrName TEXT UNIQUE, usrPassword TEXT)";

  //We are done in this section
  Future<int> insertImage(String imagePath) async {
    final Database db = await initDB();
    return db.insert('images', {'imagePath': imagePath});
  }

  // Retrieve all image paths from the images table
  Future<List<String>> getImages() async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query('images');
    return List.generate(maps.length, (i) {
      return maps[i]['imagePath'];
    });
  }
  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(users);
      await db.execute(noteTable);
    });
  }

  //Now we create login and sign up method

  //Login Method

  Future<bool> login(Users user) async {
    final Database db = await initDB();

    var result = await db.rawQuery(
        "select * from users where usrName = '${user.usrName}' AND usrPassword = '${user.usrPassword}'");
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //Sign up
  Future<int> signup(Users user) async {
    final Database db = await initDB();

    return db.insert('users', user.toMap());
  }

}