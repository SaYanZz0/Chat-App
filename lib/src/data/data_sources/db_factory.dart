import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabaseFactory {
  Future<Database> createDatabase() async {
    final databasePath = await getDatabasesPath();
    String dbPath = join(databasePath, 'chatapp.db');

    var database = openDatabase(databasePath, version: 1, onCreate: populateDB);

    return database;
  }

  populateDB(Database db, int version) async {
    await _createChatTable(db);
    await _createMessageTable(db);
  }

  _createChatTable(Database db) {
    db
        .execute('''
                   CREATE TABLE chats(
                      id TEXT PRIMARY KEY,
                      name TEXT,
                      type TEXT,
                      members TEXT,
                      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, 
                      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
)
''')
        .then((value) => print('Creating Chats Table'))
        .catchError((e) => print('error creating chats table: $e'));
  }

  _createMessageTable(Database db) {
    db
        .execute('''CREATE TABLE messages(
            chat_id TEXT NOT NULL,
            id TEXT PRIMARY KEY,
            sender TEXT NOT NULL,
            receiver TEXT NOT NULL,
            contents TEXT NOT NULL,
            receipt TEXT NOT NULL,
            received_at TIMESTAMP NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
            )''')
        .then((value) => print('Creating Chats Table'))
        .catchError((e) => print('error creating chats table: $e'));
  }
}
