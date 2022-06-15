import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class LocationData {
  int? id;
  double latitude;
  double longitude;

  LocationData({this.id, required this.latitude, required this.longitude});

  factory LocationData.fromMap(Map<String, dynamic> json) => LocationData(
      id: json['id'], latitude: json['latitude'], longitude: json["longitude"]);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'longitude': longitude,
      'latitude': latitude,
    };
  }
}

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _init();

  Future<Database> _init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "location.db");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
  CREATE TABLE LOCATION(
    id INTEGER PRIMARY KEY,
    longitude DOUBLE,
    latitude DOUBLE
  )
  ''');
  }

  Future<int> add(LocationData location) async {
    print(location.longitude);
    Database db = await instance.database;
    return await db.insert('LOCATION', location.toMap());
  }
}