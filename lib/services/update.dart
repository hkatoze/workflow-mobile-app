import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:http/http.dart' as http;

final endpoint = 'https://workflow.vbs-solutions.com/api';

class Requisition {
  final String totalAmount;
  final String rqnhseq;
  final String vdname;
  final String requestBy;
  final String expArrival;
  final String onHold;
  final String description;
  final String reqNumber;
  final String reference;
  final List<RequisitionLine> lines;

  Requisition(
      {required this.rqnhseq,
      required this.vdname,
      required this.requestBy,
      required this.expArrival,
      required this.onHold,
      required this.description,
      required this.reference,
      required this.totalAmount,
      required this.lines,
      required this.reqNumber});

  factory Requisition.fromJson(Map<String, dynamic> json) {
    List<dynamic> linesJson = json['RequisitionLine'] ?? [];
    List<RequisitionLine> lines = linesJson
        .map((lineJson) => RequisitionLine.fromJson(lineJson))
        .toList();
    return Requisition(
      rqnhseq: json['RQNHSEQ'],
      vdname: json['VDNAME'],
      totalAmount: json['TOTALAMOUNT'],
      requestBy: json['REQUESTBY'],
      expArrival: json['EXPARRIVAL'],
      onHold: json['ONHOLD'],
      description: json['DESCRIPTIO'],
      reference: json['REFERENCE'],
      reqNumber: json['RQNNUMBER'],
      lines: lines,
    );
  }
}

class RequisitionLine {
  final String rqnhseq;
  final String rqnlrev;
  final String oqordered;
  final String orderUnit;
  final String itemNo;
  final String expArrival;
  final String itemDesc;
  final String manItemNo;
  final String oeonumber;
  final String extended;

  RequisitionLine({
    required this.rqnhseq,
    required this.rqnlrev,
    required this.oqordered,
    required this.orderUnit,
    required this.itemNo,
    required this.expArrival,
    required this.itemDesc,
    required this.manItemNo,
    required this.oeonumber,
    required this.extended,
  });

  factory RequisitionLine.fromJson(Map<String, dynamic> json) {
    return RequisitionLine(
        rqnhseq: json['RQNHSEQ'],
        rqnlrev: json['RQNLREV'],
        oqordered: json['OQORDERED'],
        orderUnit: json['ORDERUNIT'],
        itemNo: json['ITEMNO'],
        expArrival: json['EXPARRIVAL'],
        itemDesc: json['ITEMDESC'],
        manItemNo: json['MANITEMNO'],
        oeonumber: json['OEONUMBER'],
        extended: json["EXTENDED"]);
  }
}

class DepartmentModel {
  DepartmentModel({required this.departmentName, required this.departmentId});
  String departmentId;
  String departmentName;

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      departmentId: json['id'],
      departmentName: json['departmentName'],
    );
  }
}

class UserModel {
  UserModel(
      {required this.companyId,
      required this.emailAdd,
      required this.username,
      required this.department,
      required this.grade,
      required this.password,
      required this.maxAmount});

  String companyId;
  String emailAdd;
  String username;

  String department;
  String grade;
  String password;
  String maxAmount;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      companyId: json['COMPANYID'],
      emailAdd: json['EMAILADD'],
      username: json['USERNAME'],
      department: json['DEPARTMENT'],
      grade: json['GRADE'],
      password: json['PASSWORD'],
      maxAmount: json['MAXAMOUNT'],
    );
  }
}

class GradeModel {
  GradeModel(
      {required this.maxAmount, required this.word, required this.gradeId});
  String gradeId;
  String word;
  String maxAmount;

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(
      gradeId: json['id'],
      word: json['word'],
      maxAmount: json['maxAmount'],
    );
  }
}

class CompanyModel {
  CompanyModel(
      {required this.companyId,
      required this.companyName,
      // required this.status,
      required this.username,
      required this.database,
      required this.password,
      required this.servername,
      required this.grades,
      required this.departments});

  String companyId;

  String companyName;
  // bool status;
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
        // status: json['status'],
        username: json['username'],
        database: json['databaseName'],
        password: json['password'],
        servername: json['servername'],
        grades: gradeList,
        departments: departmentList);
  }
}

Future<List<CompanyModel>> getAllCompaniesFuture() async {
  List<CompanyModel> _companies = [];

  try {
    final response = await http.get(
      Uri.parse(endpoint + "/allCompanies"),
    );

    if (response.statusCode == 200) {
      List<dynamic> companiesJson = jsonDecode(response.body);
      _companies = companiesJson
          .map((CompanyModelJson) => CompanyModel.fromJson(CompanyModelJson))
          .toList();

      return _companies;
    }
    print(_companies);
    return _companies;
  } catch (e) {
    return _companies;
  }
}

Future<Map<String, dynamic>> createRequisitionsMap(
    List<String> reqNumbers) async {
  Map<String, dynamic> requisitions = {};

  for (String reqNumber in reqNumbers) {
    requisitions[reqNumber] = false;
  }

  return requisitions;
}

Future<void> createOrUpdateCollection(
    String companyId,
    String email,
    String username,
    String department,
    String grade,
    String maxAmount,
    List<String> reqNumbers) async {
  // Créer le champ requisitions avec des valeurs par défaut
  final Map<String, dynamic> requisitions =
      await createRequisitionsMap(reqNumbers);

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference companyCollection =
      firestore.collection(companyId.trim());

  final DocumentReference documentRef = companyCollection.doc(email);

  final DocumentSnapshot snapshot = await documentRef.get();
  if (snapshot.exists) {
    // Le document existe déjà, récupérer les données existantes
    final Map<String, dynamic>? existingData =
        snapshot.data() as Map<String, dynamic>?;

    if (existingData != null && existingData.containsKey('requisitions')) {
      // Les requêtes existent déjà, mettre à jour seulement les valeurs spécifiées
      final Map<String, dynamic> existingRequisitions =
          existingData['requisitions'];

      requisitions.forEach((reqNumber, value) {
        if (existingRequisitions.containsKey(reqNumber)) {
        } else {
          existingRequisitions.addAll({"$reqNumber": "$value"});
        }
      });

      await documentRef.update({
        'email': email,
        'username': username,
        'department': department,
        'grade': grade,
        'maxAmount': int.parse(maxAmount),
        'requisitions': existingRequisitions,
      });
    } else {
      // Les requêtes n'existent pas, les ajouter entièrement
      await documentRef.set({
        'email': email,
        'username': username,
        'department': department,
        'grade': grade,
        'maxAmount': int.parse(maxAmount),
        'requisitions': requisitions,
      });
    }
  } else {
    // Le document n'existe pas, le créer avec les nouvelles données
    await documentRef.set({
      'email': email,
      'username': username,
      'department': department,
      'grade': grade,
      'maxAmount': int.parse(maxAmount),
      'requisitions': requisitions,
    });
  }
}

Future<List<UserModel>> getUsersByCompany(String companyName) async {
  List<UserModel> _users = [];

  final response = await http.post(
    Uri.parse(endpoint + "/companyAllUsers"),
    body: jsonEncode(<String, String>{
      'companyName': companyName,
    }),
  );

  if (response.statusCode == 200) {
    List<dynamic> usersJson = jsonDecode(response.body);
    _users = usersJson
        .map((UserModelJson) => UserModel.fromJson(UserModelJson))
        .toList();

    return _users;
  }

  return _users;
}

Future<List<String>> getRequisitionNumbers(
    String companyId, String department, String maxAmount) async {
  List<String> requisitionNumbers = [];

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
}

Future<void> updateRequisitionsOnFirebase() async {
  getAllCompaniesFuture().then((companies) {
    for (int icompany = 0; icompany < companies.length; icompany++) {
      getUsersByCompany(companies[icompany].companyName).then((users) async {
        for (int iuser = 0; iuser < users.length; iuser++) {
          List<String> reqNumbers = await getRequisitionNumbers(
              users[iuser].companyId,
              users[iuser].department,
              users[iuser].maxAmount);

          await createOrUpdateCollection(
              users[iuser].companyId,
              users[iuser].emailAdd,
              users[iuser].username,
              users[iuser].department,
              users[iuser].grade,
              users[iuser].maxAmount,
              reqNumbers);
        }
      });
    }
  });
}
