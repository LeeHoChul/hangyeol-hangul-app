import 'dart:math';
import '../data/hangul_data.dart';
import '../models/hangul_problem.dart';

class ProblemGenerator {
  final _random = Random();

  List<DifficultyLevel> levelsForMode(GameMode mode) {
    switch (mode) {
      case GameMode.consonant:
        return const [
          DifficultyLevel(level: 1, name: '아기 곰', emoji: '🐻', description: 'ㄱ,ㄴ,ㄷ,ㅁ 자음', choiceCount: 2),
          DifficultyLevel(level: 2, name: '꼬마 토끼', emoji: '🐰', description: 'ㄱ~ㅂ 자음', choiceCount: 3),
          DifficultyLevel(level: 3, name: '용감한 호랑이', emoji: '🐯', description: '전체 자음', choiceCount: 4),
        ];
      case GameMode.syllable:
        return const [
          DifficultyLevel(level: 1, name: '아기 새', emoji: '🐤', description: '가,나,다,마 행', choiceCount: 2),
          DifficultyLevel(level: 2, name: '똑똑한 앵무', emoji: '🦜', description: '가~바 행', choiceCount: 3),
          DifficultyLevel(level: 3, name: '지혜로운 부엉이', emoji: '🦉', description: '가~하 전체', choiceCount: 4),
        ];
      case GameMode.word:
        return const [
          DifficultyLevel(level: 1, name: '꼬마 탐험가', emoji: '🧒', description: '쉬운 2글자', choiceCount: 2),
          DifficultyLevel(level: 2, name: '글자 용사', emoji: '⚔️', description: '2글자 전체', choiceCount: 3),
          DifficultyLevel(level: 3, name: '단어 마법사', emoji: '🧙', description: '2~3글자', choiceCount: 4),
          DifficultyLevel(level: 4, name: '한글 왕', emoji: '👑', description: '어려운 단어 포함', choiceCount: 4),
        ];
      case GameMode.challenge:
        return const [
          DifficultyLevel(level: 1, name: '도전 시작!', emoji: '🚀', description: '쉬운 혼합', choiceCount: 3),
          DifficultyLevel(level: 2, name: '도전 계속!', emoji: '🔥', description: '보통 혼합', choiceCount: 4),
          DifficultyLevel(level: 3, name: '최종 도전!', emoji: '🏆', description: '어려운 혼합', choiceCount: 4),
        ];
    }
  }

  List<HangulProblem> generateRound(GameMode mode, int difficultyLevel, {int count = 10}) {
    if (mode == GameMode.challenge) {
      return _generateChallengeRound(difficultyLevel, count);
    }

    final problems = <HangulProblem>[];
    final seen = <String>{};

    for (var i = 0; i < count; i++) {
      final problem = _generateProblem(mode, difficultyLevel, seen);
      problems.add(problem);
      seen.add(problem.correctWord);
    }

    return problems;
  }

  List<HangulProblem> _generateChallengeRound(int difficultyLevel, int count) {
    final modes = [GameMode.consonant, GameMode.syllable, GameMode.word];
    final problems = <HangulProblem>[];
    final seen = <String>{};

    for (var i = 0; i < count; i++) {
      final mode = modes[_random.nextInt(modes.length)];
      final modeLevel = difficultyLevel.clamp(1, levelsForMode(mode).length);
      final problem = _generateProblem(mode, modeLevel, seen);
      problems.add(problem);
      seen.add(problem.correctWord);
    }

    return problems;
  }

  HangulProblem _generateProblem(GameMode mode, int difficultyLevel, Set<String> seen) {
    final levels = levelsForMode(mode);
    final levelInfo = levels.firstWhere(
      (l) => l.level == difficultyLevel,
      orElse: () => levels.last,
    );
    final choiceCount = levelInfo.choiceCount;

    switch (mode) {
      case GameMode.consonant:
        return _generateConsonantProblem(difficultyLevel, choiceCount, seen);
      case GameMode.syllable:
        return _generateSyllableProblem(difficultyLevel, choiceCount, seen);
      case GameMode.word:
        return _generateWordProblem(difficultyLevel, choiceCount, seen);
      case GameMode.challenge:
        return _generateWordProblem(difficultyLevel, choiceCount, seen);
    }
  }

  HangulProblem _generateConsonantProblem(int level, int choiceCount, Set<String> seen) {
    final consonants = _consonantsForLevel(level);
    final consonant = consonants[_random.nextInt(consonants.length)];
    final candidates = HangulData.wordsForConsonant(consonant);

    final correctWord = _pickUnseen(candidates, seen);
    final distractors = _pickDistractors(
      correctWord,
      choiceCount - 1,
      excludeConsonant: consonant,
    );

    final choices = _buildChoices(correctWord, distractors);

    return HangulProblem(
      mode: GameMode.consonant,
      question: consonant,
      correctEmoji: correctWord.emoji,
      correctWord: correctWord.word,
      choices: choices,
    );
  }

  HangulProblem _generateSyllableProblem(int level, int choiceCount, Set<String> seen) {
    final consonants = _consonantsForLevel(level);
    final consonant = consonants[_random.nextInt(consonants.length)];
    final candidates = HangulData.wordsForConsonant(consonant);

    final correctWord = _pickUnseen(candidates, seen);
    final distractors = _pickDistractors(
      correctWord,
      choiceCount - 1,
      excludeConsonant: consonant,
    );

    final choices = _buildChoices(correctWord, distractors);

    return HangulProblem(
      mode: GameMode.syllable,
      question: correctWord.syllable,
      correctEmoji: correctWord.emoji,
      correctWord: correctWord.word,
      choices: choices,
    );
  }

  HangulProblem _generateWordProblem(int level, int choiceCount, Set<String> seen) {
    final int maxDifficulty;
    switch (level) {
      case 1:
        maxDifficulty = 1;
      case 2:
        maxDifficulty = 2;
      case 3:
        maxDifficulty = 2;
      default:
        maxDifficulty = 3;
    }

    final candidates = HangulData.wordsByDifficulty(maxDifficulty);
    final correctWord = _pickUnseen(candidates, seen);
    final distractors = _pickDistractors(correctWord, choiceCount - 1);
    final choices = _buildChoices(correctWord, distractors);

    return HangulProblem(
      mode: GameMode.word,
      question: correctWord.word,
      correctEmoji: correctWord.emoji,
      correctWord: correctWord.word,
      choices: choices,
    );
  }

  List<String> _consonantsForLevel(int level) {
    switch (level) {
      case 1:
        return ['ㄱ', 'ㄴ', 'ㄷ', 'ㅁ'];
      case 2:
        return ['ㄱ', 'ㄴ', 'ㄷ', 'ㄹ', 'ㅁ', 'ㅂ'];
      default:
        return HangulData.allConsonants;
    }
  }

  HangulWord _pickUnseen(List<HangulWord> candidates, Set<String> seen) {
    final unseen = candidates.where((w) => !seen.contains(w.word)).toList();
    final pool = unseen.isNotEmpty ? unseen : candidates;
    return pool[_random.nextInt(pool.length)];
  }

  List<HangulWord> _pickDistractors(
    HangulWord correct,
    int count, {
    String? excludeConsonant,
  }) {
    var pool = HangulData.words
        .where((w) => w.word != correct.word && w.emoji != correct.emoji)
        .toList();

    if (excludeConsonant != null) {
      pool = pool.where((w) => w.consonant != excludeConsonant).toList();
    }

    pool.shuffle(_random);
    return pool.take(count).toList();
  }

  List<EmojiChoice> _buildChoices(HangulWord correct, List<HangulWord> distractors) {
    final choices = <EmojiChoice>[
      EmojiChoice(emoji: correct.emoji, word: correct.word, isCorrect: true),
      ...distractors.map((d) => EmojiChoice(emoji: d.emoji, word: d.word, isCorrect: false)),
    ];
    choices.shuffle(_random);
    return choices;
  }
}
