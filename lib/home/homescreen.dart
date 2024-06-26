// home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/employee_provider.dart';
import 'employe_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee List'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: EmployeeSearch());
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<EmployeeProvider>(context, listen: false).fetchEmployees(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return Center(child: Text('An error occurred!'));
          } else {
            return Consumer<EmployeeProvider>(
              builder: (ctx, employeeProvider, child) {
                final employees = employeeProvider.employees.where((employee) {
                  return employee.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                      employee.email.toLowerCase().contains(_searchQuery.toLowerCase());
                }).toList();

                return EmployeeList(employees: employees); // Use the EmployeeList widget
              },
            );
          }
        },
      ),
    );
  }
}

class EmployeeSearch extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context, listen: false);
    final results = employeeProvider.employees.where((employee) {
      return employee.name.toLowerCase().contains(query.toLowerCase()) ||
          employee.email.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return EmployeeList(employees: results); // Use the EmployeeList widget
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context, listen: false);
    final suggestions = employeeProvider.employees.where((employee) {
      return employee.name.toLowerCase().contains(query.toLowerCase()) ||
          employee.email.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return EmployeeList(employees: suggestions); // Use the EmployeeList widget
  }
}
