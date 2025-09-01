
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('movilizacion.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    print("Initializing database...");
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE solicitudes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fecha TEXT NOT NULL,
        estado TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE animales (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        solicitud_id INTEGER,
        identificador TEXT,
        especie TEXT,
        categoria TEXT,
        sexo TEXT,
        raza TEXT,
        color TEXT,
        edad INTEGER,
        comerciante TEXT,
        observaciones TEXT,
        FOREIGN KEY (solicitud_id) REFERENCES solicitudes (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE aves (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        solicitud_id INTEGER,
        numero_galpon TEXT,
        categoria TEXT,
        raza TEXT,
        edad INTEGER,
        total INTEGER,
        observaciones TEXT,
        FOREIGN KEY (solicitud_id) REFERENCES solicitudes (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE predios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        solicitud_id INTEGER,
        tipo TEXT,
        nombre TEXT,
        localidad TEXT,
        sitio TEXT,
        parroquia TEXT,
        kilometro REAL,
        es_centro_faenamiento INTEGER,
        latitud REAL,
        longitud REAL,
        ubicacion TEXT,
        condicion_tenencia TEXT,
        FOREIGN KEY (solicitud_id) REFERENCES solicitudes (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE transportes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        solicitud_id INTEGER,
        tipo_transporte TEXT,
        es_terrestre INTEGER,
        nombre_transportista TEXT,
        cedula_transportista TEXT,
        placa TEXT,
        telefono_transportista TEXT,
        FOREIGN KEY (solicitud_id) REFERENCES solicitudes (id) ON DELETE CASCADE
      )
    ''');
  }
}
