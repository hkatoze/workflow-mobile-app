import 'package:flutter/material.dart';

import 'departmentModel.dart';
import 'gradeModel.dart';

Color parseStringToColor(String colorString) {
  Color color = Colors.purple;

  try {
    String valueString =
        colorString.split('(0x')[1].split(')')[0]; // kind of hacky..
    int value = int.parse(valueString, radix: 16);
    Color otherColor = new Color(value);

    return otherColor;
  } catch (exception) {
    print(
        'Erreur lors de la conversion de la chaîne en un objet Color : $exception');
  }
  return color;
}

class CompanyModel {
  CompanyModel(
      {required this.companyId,
 
      required this.companyName,
      required this.status,
      required this.username,
      required this.database,
      required this.password,
      required this.servername,
      required this.grades,
      required this.departments});

  int companyId;
 
  String companyName;

  bool status;
  String database;
  String servername;
  String username;
  String password;
  List<GradeModel> grades;
  List<DepartmentModel> departments;

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> gradeJson = json['grades'];
    List<GradeModel> gradeList =
        gradeJson.map((gradeJson) => GradeModel.fromJson(gradeJson)).toList();

    List<dynamic> departmentJson = json['departments'];
    List<DepartmentModel> departmentList = departmentJson
        .map((departmentJson) => DepartmentModel.fromJson(departmentJson))
        .toList();
    return CompanyModel(
        companyId: json['id'],
       
        companyName: json['companyName'],
        status: json['status'],
        username: json['username'],
        database: json['databaseName'],
        password: json['password'],
        servername: json['servername'],
        grades: gradeList,
        departments: departmentList);
  }
}
