import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow/models/departmentModel.dart';
import 'package:workflow/models/gradeModel.dart';

import '../models/companyModel.dart';
import '../models/requisitionModel.dart';

import 'firebaseservices.dart';

final endpoint = 'https://workflowapi-nodejs.vercel.app';
Future<void> _saveCredentials(
    String username,
    String password,
    String companyId,
    String grade,
    String department,
    String email,
    String maxAmount) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', username);
  await prefs.setString('password', password);
  await prefs.setString('email', email);
  await prefs.setString('companyId', companyId);
  await prefs.setString('grade', grade);
  await prefs.setString('department', department);
  await prefs.setString('maxAmount', maxAmount);
}

Future<String> loginAPI(String email, String password, String companyId) async {
  final response = await http.post(
    Uri.parse(endpoint + "/login"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'companyName': companyId,
      'emailAdd': email,
      'password': password
    }),
  );
 
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      String message = body['message'];

      if (message == "Authentification réussie.") {
        print(body['user']['USERNAME']);
        _saveCredentials(
            body['user']['USERNAME'],
            body['user']['PASSWORD'],
            body['user']['COMPANYID'],
            body['user']['GRADE'],
            body['user']['DEPARTMENT'],
            body['user']['EMAILADD'],
            body['user']['MAXAMOUNT']);

        List<String> reqNumbers = await getRequisitionNumbers(
            companyId, body['user']['DEPARTMENT'], body['user']['MAXAMOUNT']);

        await createOrUpdateCollection(
            companyId,
            body['user']['EMAILADD'],
            body['user']['USERNAME'],
            body['user']['DEPARTMENT'],
            body['user']['GRADE'],
            body['user']['MAXAMOUNT'],
            reqNumbers);
      }

      return message;
    }
  

  return "error";
}

Future<String> updateRequisitionHold(
    String companyName, String reqNumber, String status) async {
  final response = await http.post(
    Uri.parse(endpoint + "/validateRequisition"),
    body: jsonEncode(<String, String>{
      'companyName': companyName,
      'onhold': '${status}',
      'reqNumber': reqNumber
    }),
  );

  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);

    String message = body['status'];

    return message;
  }

  return "error";
}

Future<String> signupApi(String companyId, String email, String username,
    String department, String grade, String password, String maxAmount) async {
  final response = await http.post(
    Uri.parse(endpoint + "/signUp"),
     headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'companyName': companyId,
      'emailAdd': email,
      'username': username,
      'department': department,
      'grade': grade,
      'password': password,
      'maxAmount': maxAmount
    }),
  );

  try {
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      String result = body["message"];

      if (result == "success") {
        _saveCredentials(
            username, password, companyId, grade, department, email, maxAmount);
      }
      List<String> reqNumbers =
          await getRequisitionNumbers(companyId, department, maxAmount);

      await createOrUpdateCollection(
          companyId, email, username, department, grade, maxAmount, reqNumbers);

      print(result);
      return result;
    }
  } catch (e) {
    return "null";
  }

  return "null";
}

Future<List<Requisition>> getRequisitions(
    String companyId, String department, String maxAmount) async {
  List<Requisition> _requisitions = [];

  try {
    final response = await http.post(
      Uri.parse(endpoint + "/requisitions"),
      body: jsonEncode(<String, String>{
        'companyName': companyId,
        'department': department,
        'maxAmount': maxAmount.replaceAll('.', '')
      }),
    );

    if (response.statusCode == 200) {
      List<dynamic> requisitionsJson = jsonDecode(response.body);

      _requisitions = requisitionsJson
          .map((requisitionJson) => Requisition.fromJson(requisitionJson))
          .toList();

      return _requisitions;
    }

    return _requisitions;
  } catch (e) {
    return [];
  }
}

Future<List<String>> getRequisitionNumbers(
    String companyId, String department, String maxAmount) async {
  List<String> requisitionNumbers = [];

  try {
    final response = await http.post(
      Uri.parse(endpoint + "/requisitions"),
      body: jsonEncode(<String, String>{
        'companyName': companyId,
        'department': department,
        'maxAmount': maxAmount.replaceAll('.', '')
      }),
    );

    if (response.statusCode == 200) {
      List<dynamic> requisitionsJson = jsonDecode(response.body);
      requisitionNumbers = requisitionsJson
          .map((requisitionJson) =>
              Requisition.fromJson(requisitionJson).reqNumber)
          .toList();

      return requisitionNumbers;
    }

    return requisitionNumbers;
  } catch (e) {
    return [];
  }
}

Future<CompanyModel> getCompanyData(String companyId) async {
  final response = await http.post(
    Uri.parse(endpoint + "/companyData"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'companyName': companyId}),
  );

  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);
    print(body);

    String message = body['status'];
    if (message != "success") {
      return CompanyModel(
          companyId: 0,
          companyName: "",
          status: false,
          username: "",
          database: "",
          password: "",
          servername: "",
          grades: [],
          departments: []);
    }
    List<dynamic> gradeJson = body['data']['grades'];
    List<GradeModel> gradeList =
        gradeJson.map((grade) => GradeModel.fromJson(grade)).toList();

    List<dynamic> departmentsJson = body['data']['departments'];
    List<DepartmentModel> departmentList = departmentsJson
        .map((department) => DepartmentModel.fromJson(department))
        .toList();

    return CompanyModel(
        companyId: body['data']['id'],
        companyName: body['data']['companyName'],
        status: true,
        username: body['data']['username'],
        database: body['data']['databaseName'],
        password: body['data']['password'],
        servername: body['data']['servername'],
        grades: gradeList,
        departments: departmentList);
  }

  return CompanyModel(
      companyId: 0,
      companyName: "",
      status: false,
      username: "",
      database: "",
      password: "",
      servername: "",
      grades: [],
      departments: []);
}
