class QuizModel {
  final int id;
  final String title;
  final List<QuizQuestionModel> questions;

  const QuizModel({
    required this.id,
    required this.title,
    required this.questions,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    final rawQuestions =
        json['questions'] ?? json['items'] ?? json['quizzes'] ?? [];

    return QuizModel(
      id: _toInt(json['id']) ?? 0,
      title: _readString(json['title']) ?? 'Section Quiz',
      questions: _parseQuestions(rawQuestions),
    );
  }

  static List<QuizQuestionModel> _parseQuestions(dynamic raw) {
    if (raw is Map) {
      raw = raw.values.toList();
    }

    if (raw is! List) return const [];

    final result = <QuizQuestionModel>[];

    for (final item in raw) {
      if (item is! Map) continue;

      final questionId = _toInt(item['id']) ?? result.length;
      final title = _readString(item['title']) ??
          _readString(item['question']) ??
          _readString(item['text']) ??
          'Question ${result.length + 1}';

      final rawAnswers =
          item['answers'] ?? item['options'] ?? item['choices'] ?? [];

      result.add(
        QuizQuestionModel(
          id: questionId,
          title: title,
          answers: _parseAnswers(rawAnswers),
        ),
      );
    }

    return result;
  }

  static List<QuizAnswerModel> _parseAnswers(dynamic raw) {
    if (raw is Map) {
      raw = raw.values.toList();
    }

    if (raw is! List) return const [];

    final result = <QuizAnswerModel>[];

    for (var i = 0; i < raw.length; i++) {
      final item = raw[i];

      if (item is Map) {
        result.add(
          QuizAnswerModel(
            id: _toInt(item['id']) ?? i,
            text: _readString(item['text']) ??
                _readString(item['title']) ??
                _readString(item['answer']) ??
                'Answer ${i + 1}',
          ),
        );
      } else if (item != null) {
        result.add(
          QuizAnswerModel(
            id: i,
            text: item.toString(),
          ),
        );
      }
    }

    return result;
  }
}

class QuizQuestionModel {
  final int id;
  final String title;
  final List<QuizAnswerModel> answers;

  const QuizQuestionModel({
    required this.id,
    required this.title,
    required this.answers,
  });
}

class QuizAnswerModel {
  final int id;
  final String text;

  const QuizAnswerModel({
    required this.id,
    required this.text,
  });
}

String? _readString(dynamic value) {
  if (value is String && value.trim().isNotEmpty) {
    return value.trim();
  }
  return null;
}

int? _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}
