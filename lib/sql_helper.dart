import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
    CREATE TABLE songs_database(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      artist TEXT,
      year TEXT,
      genre TEXT
    )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('songs_database.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  // add
  static Future<int> addSong(
      String title, String artist, String year, String genre) async {
    final db = await SQLHelper.db();
    final data = {
      'title': title,
      'artist': artist,
      'year': year,
      'genre': genre
    };
    return await db.insert('songs_database', data);
  }

  // read
  static Future<List<Map<String, dynamic>>> getSongs() async {
    final db = await SQLHelper.db();
    return db.query('songs_database');
  }

  // update
  static Future<int> updateSongs(
      int id, String title, String artist, String year, String genre) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'artist': artist,
      'year': year,
      'genre': genre
    };
    return await db.update('songs_database', data, where: "id = $id");
  }

  // delete
  static Future<void> deleteSong(int id) async {
    final db = await SQLHelper.db();
    await db.delete('songs_database', where: "id = $id");
  }
}
