 

class GradeModel {
  GradeModel({required this.maxAmount, required this.word,required this.gradeId});
int gradeId;
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
