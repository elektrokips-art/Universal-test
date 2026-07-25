class Submission {
  final String id;
  final String testId;
  final String fio;
  final String studentClass;
  final List<int> answers;
  final int correctCount;
  final int totalQuestions;
  final int grade;
  final DateTime submittedAt;

  Submission({
    required this.id,
    required this.testId,
    required this.fio,
    required this.studentClass,
    required this.answers,
    required this.correctCount,
    required this.totalQuestions,
    required this.grade,
    required this.submittedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'testId': testId,
        'fio': fio,
        'studentClass': studentClass,
        'answers': answers,
        'correctCount': correctCount,
        'totalQuestions': totalQuestions,
        'grade': grade,
        'submittedAt': submittedAt.toIso8601String(),
      };

  factory Submission.fromJson(Map<String, dynamic> json) => Submission(
        id: json['id'] as String,
        testId: json['testId'] as String,
        fio: json['fio'] as String,
        studentClass: json['studentClass'] as String,
        answers: List<int>.from(json['answers'] as List),
        correctCount: json['correctCount'] as int,
        totalQuestions: json['totalQuestions'] as int,
        grade: json['grade'] as int,
        submittedAt: DateTime.parse(json['submittedAt'] as String),
      );
}
