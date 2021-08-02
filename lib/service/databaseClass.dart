import 'dart:async';

import 'package:adress_book/service/addressClass.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class DatabaseClass {

  Future<bool> databaseExists(String path) => databaseFactory.databaseExists(path);


  Future<Database> createDB() async{
    WidgetsFlutterBinding.ensureInitialized();
    // check if database exist
    var isDBExist = await databaseExists(join(await getDatabasesPath(), 'address_book.db'));

    if(isDBExist){
      // exist
      print('database exist');
      final database = openDatabase(
        join(await getDatabasesPath(), 'address_book.db'),
      );
      return database;
    }
    print('database does not exist');
    final database = openDatabase(

      join(await getDatabasesPath(), 'address_book.db'),

      onCreate: (db, version) {

        return db.execute(
          'CREATE TABLE Addresses (id TEXT PRIMARY KEY, name TEXT, city TEXT, country TEXT, address TET, phone TEXT, lat REAL, lng REAL)',
        );
      },

      version: 1
    );
    return database;

  }

  Future<void> insertAddress(Map addressInfo) async {
    Uuid uuid = new Uuid();
    addressInfo['id'] = uuid.v1();
    AddressClass addressClass = new AddressClass(
        id: addressInfo['id'],
        name: addressInfo['name'],
        city: addressInfo['city'],
        country: addressInfo['country'],
        address: addressInfo['address'],
        phone: addressInfo['phone'],
        lat: addressInfo['lat'],
        lng: addressInfo['lng']
    );
    // Get a reference to the database.
    final db = await createDB();
    await db.insert(
      'Addresses',
      addressClass.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<AddressClass>> getAddressList() async {
    // Get a reference to the database.
    final db = await createDB();

    // Query the table for all The Address.
    final List<Map<String, dynamic>> maps = await db.query('Addresses');

    // Convert the List<Map<String, dynamic> into a List<Address>.
    return List.generate(maps.length, (i) {

      return AddressClass(
        id: maps[i]['id'],
        name: maps[i]['name'],
        city: maps[i]['city'],
        country: maps[i]['country'],
        address: maps[i]['address'],
        phone: maps[i]['phone'],
        lat: maps[i]['lat'],
        lng: maps[i]['lng']
      );
    });
  }

  Future<void> updateAddress(Map addressInfo) async {
    AddressClass addressClass = new AddressClass(
        id: addressInfo['id'],
        name: addressInfo['name'],
        city: addressInfo['city'],
        country: addressInfo['country'],
        address: addressInfo['address'],
        phone: addressInfo['phone'],
        lat: addressInfo['lat'],
        lng: addressInfo['address']
    );
    // Get a reference to the database.
    final db = await createDB();

    // Update the given address.
    await db.update(
      'Addresses',
      addressClass.toMap(),
      // Ensure that the address has a matching id.
      where: 'id = ?',
      // Pass the address's id as a whereArg to prevent SQL injection.
      whereArgs: [addressClass.id],
    );
  }

  Future<void> deleteAddress(String id) async {
    // Get a reference to the database.
    final db = await createDB();

    // Remove the address from the database.
    await db.delete(
      'Addresses',
      // Use a `where` clause to delete a specific address.
      where: 'id = ?',
      // Pass the address's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}