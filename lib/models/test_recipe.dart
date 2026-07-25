import 'question.dart';
import 'grade_scale.dart';

class TestRecipe {
  final String id;
  final String name;
  final List<Question> questions;
  final GradeScale gradeScale;
  final DateTime createdAt;

  TestRecipe({
    required this.id,
    required this.name,
    required this.questions,
    required this.gradeScale,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'questions': questions.map((q) => q.toJson()).toList(),
        'gradeScale': gradeScale.toJson(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory TestRecipe.fromJson(Map<String, dynamic> json) => TestRecipe(
        id: json['id'] as String,
        name: json['name'] as String,
        questions: (json['questions'] as List)
            .map((q) => Question.fromJson(q as Map<String, dynamic>))
            .toList(),
        gradeScale: GradeScale.fromJson(
            json['gradeScale'] as Map<String, dynamic>? ?? const {}),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  TestRecipe copyWith({
    String? name,
    List<Question>? questions,
    GradeScale? gradeScale,
  }) =>
      TestRecipe(
        id: id,
        name: name ?? this.name,
        questions: questions ?? this.questions,
        gradeScale: gradeScale ?? this.gradeScale,
        createdAt: createdAt,
      );

  /// Questions actually delivered to students — disabled ones are kept in
  /// the recipe (so the teacher can re-enable them later) but excluded here.
  List<Question> get activeQuestions =>
      questions.where((q) => q.enabled).toList();

  Map<String, dynamic> toPublicJson() {
    final active = activeQuestions;
    return {
      'id': id,
      'name': name,
      'questions': [
        for (var i = 0; i < active.length; i++) active[i].toPublicJson(i),
      ],
    };
  }
}
