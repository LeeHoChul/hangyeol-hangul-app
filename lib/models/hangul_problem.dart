class EmojiChoice {
  final String emoji;
  final String word;
  final bool isCorrect;

  const EmojiChoice({
    required this.emoji,
    required this.word,
    required this.isCorrect,
  });
}

enum GameMode {
  consonant,
  syllable,
  word,
  challenge;

  String get label {
    switch (this) {
      case GameMode.consonant:
        return '자음 놀이';
      case GameMode.syllable:
        return '낱글자 놀이';
      case GameMode.word:
        return '단어 놀이';
      case GameMode.challenge:
        return '도전 모드';
    }
  }

  String get emoji2 {
    switch (this) {
      case GameMode.consonant:
        return 'ㄱㄴㄷ';
      case GameMode.syllable:
        return '가나다';
      case GameMode.word:
        return '📝';
      case GameMode.challenge:
        return '🎲';
    }
  }

  String get description {
    switch (this) {
      case GameMode.consonant:
        return '자음을 보고 그림 찾기';
      case GameMode.syllable:
        return '글자를 보고 그림 찾기';
      case GameMode.word:
        return '단어를 보고 그림 찾기';
      case GameMode.challenge:
        return '모두 섞어서 도전!';
    }
  }
}

class DifficultyLevel {
  final int level;
  final String name;
  final String emoji;
  final String description;
  final int choiceCount;

  const DifficultyLevel({
    required this.level,
    required this.name,
    required this.emoji,
    required this.description,
    required this.choiceCount,
  });
}

class HangulProblem {
  final GameMode mode;
  final String question;
  final String correctEmoji;
  final String correctWord;
  final List<EmojiChoice> choices;

  const HangulProblem({
    required this.mode,
    required this.question,
    required this.correctEmoji,
    required this.correctWord,
    required this.choices,
  });
}

class GameResult {
  final GameMode mode;
  final int difficultyLevel;
  final List<HangulProblem> problems;
  final List<EmojiChoice?> userAnswers;
  final int score;
  final int maxStreak;
  final Duration elapsed;

  const GameResult({
    required this.mode,
    required this.difficultyLevel,
    required this.problems,
    required this.userAnswers,
    required this.score,
    required this.maxStreak,
    required this.elapsed,
  });

  int get total => problems.length;
  double get accuracy => total > 0 ? score / total : 0;

  int get xpEarned {
    var xp = score * 2;
    if (accuracy >= 1.0) xp += 5;
    if (maxStreak >= 5) xp += 3;
    xp += (difficultyLevel * 0.5).round();
    return xp;
  }

  int get stars {
    if (accuracy >= 1.0) return 3;
    if (accuracy >= 0.8) return 2;
    if (accuracy >= 0.5) return 1;
    return 0;
  }

  List<int> get wrongIndices {
    final result = <int>[];
    for (var i = 0; i < problems.length; i++) {
      final answer = userAnswers[i];
      if (answer == null || !answer.isCorrect) {
        result.add(i);
      }
    }
    return result;
  }
}
