class Question {
  final String id;
  final String text;
  final List<String> options;
  final int correctIndex;
  final bool enabled;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctIndex,
    this.enabled = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'options': options,
        'correctIndex': correctIndex,
        'enabled': enabled,
      };

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json['id'] as String,
        text: json['text'] as String,
        options: List<String>.from(json['options'] as List),
        correctIndex: json['correctIndex'] as int,
        enabled: json['enabled'] as bool? ?? true,
      );

  Question copyWith({
    String? text,
    List<String>? options,
    int? correctIndex,
    bool? enabled,
  }) =>
      Question(
        id: id,
        text: text ?? this.text,
        options: options ?? this.options,
        correctIndex: correctIndex ?? this.correctIndex,
        enabled: enabled ?? this.enabled,
      );

  /// Public view for the student page: no correct-answer info included.
  Map<String, dynamic> toPublicJson(int index) => {
        'index': index,
        'text': text,
        'options': options,
      };
}
