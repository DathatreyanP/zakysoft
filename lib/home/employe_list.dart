import 'package:flutter/material.dart';

import '../details/details.dart';
import '../provider/employee_provider.dart';
class EmployeeList extends StatelessWidget {
  final List<Employee> employees;

  EmployeeList({required this.employees});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: employees.length,
      itemBuilder: (ctx, index) {
        final employee = employees[index];
        return Container(
          margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.white, // Optional: background color
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              color: Colors.grey, // Border color
              width: 1.0, // Border width
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4.0,
                spreadRadius: 2.0,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(employee.profileImage),
            ),
            title: Text(employee.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Company: ${employee.company}'),
                Text('Email: ${employee.email}'),
              ],
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EmployeeDetailScreen(employee: employee),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
