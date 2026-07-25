/// Maps a count of correct answers to a grade (5/4/3/2), based on an
/// explicit [from, to] range of correct-answer counts set by the teacher
/// for each grade.
class GradeScale {
  final int grade5From;
  final int grade5To;
  final int grade4From;
  final int grade4To;
  final int grade3From;
  final int grade3To;
  final int grade2From;
  final int grade2To;

  const GradeScale({
    this.grade5From = 18,
    this.grade5To = 20,
    this.grade4From = 14,
    this.grade4To = 17,
    this.grade3From = 10,
    this.grade3To = 13,
    this.grade2From = 0,
    this.grade2To = 9,
  });

  int gradeFor(int correctCount) {
    if (correctCount >= grade5From && correctCount <= grade5To) return 5;
    if (correctCount >= grade4From && correctCount <= grade4To) return 4;
    if (correctCount >= grade3From && correctCount <= grade3To) return 3;
    if (correctCount >= grade2From && correctCount <= grade2To) return 2;
    return 2;
  }

  Map<String, dynamic> toJson() => {
        'grade5From': grade5From,
        'grade5To': grade5To,
        'grade4From': grade4From,
        'grade4To': grade4To,
        'grade3From': grade3From,
        'grade3To': grade3To,
        'grade2From': grade2From,
        'grade2To': grade2To,
      };

  factory GradeScale.fromJson(Map<String, dynamic> json) => GradeScale(
        grade5From: json['grade5From'] as int? ?? 18,
        grade5To: json['grade5To'] as int? ?? 20,
        grade4From: json['grade4From'] as int? ?? 14,
        grade4To: json['grade4To'] as int? ?? 17,
        grade3From: json['grade3From'] as int? ?? 10,
        grade3To: json['grade3To'] as int? ?? 13,
        grade2From: json['grade2From'] as int? ?? 0,
        grade2To: json['grade2To'] as int? ?? 9,
      );
}
