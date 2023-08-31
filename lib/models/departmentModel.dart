 

class DepartmentModel {
  DepartmentModel({
    required this.departmentName,
    required this.departmentId
  });
int departmentId;
  String departmentName;

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      departmentId: json['id'],
      departmentName: json['departmentName'],
    );
  }
}
