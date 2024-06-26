import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class EmployeeProvider with ChangeNotifier {
  List<Employee> _employees = [];

  List<Employee> get employees => _employees;

  Future<void> fetchEmployees() async {
    final db = await _getDatabase();
    final data = await db.query('employees');

    if (data.isEmpty) {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        _employees = jsonData.map((item) => Employee.fromJson(item)).toList();

        for (var employee in _employees) {
          await db.insert('employees', employee.toMap());
        }
      } else {
        throw Exception('Failed to load employees');
      }
    } else {
      _employees = data.map((item) => Employee.fromMap(item)).toList();
    }
    notifyListeners();
  }

  Future<Database> _getDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'employee_directory.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE employees(id INTEGER PRIMARY KEY, name TEXT, username TEXT, email TEXT, address TEXT, phone TEXT, website TEXT, company TEXT, profileImage TEXT)',
        );
      },
      version: 1,
    );
  }
}

class Employee {
  final int id;
  final String name;
  final String username;
  final String email;
  final String address;
  final String phone;
  final String website;
  final String company;
  final String profileImage;

  Employee({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.address,
    required this.phone,
    required this.website,
    required this.company,
    required this.profileImage,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      address: json['address']['street'] + json['address']['suite'] + json['address']['city'],
      phone: json['phone'],
      website: json['website'],
      company: json['company']['name'],
      profileImage: 'https://via.placeholder.com/150', // Placeholder image
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'address': address,
      'phone': phone,
      'website': website,
      'company': company,
      'profileImage': profileImage,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      username: map['username'],
      email: map['email'],
      address: map['address'],
      phone: map['phone'],
      website: map['website'],
      company: map['company'],
      profileImage: map['profileImage'],
    );
  }
}
