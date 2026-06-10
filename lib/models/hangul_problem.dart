import 'dart:math';
import '../utils/hangul_utils.dart';

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

/// 권장 학습 순서대로 정의:
/// 음절 인식(낱글자) → 모음 → 자음(음소) → 글자 조합 → 받침 → 단어 읽기
enum GameMode {
  syllable,
  vowel,
  consonant,
  combine,
  batchim,
  word,
  challenge;

  String get label {
    switch (this) {
      case GameMode.syllable:
        return '낱글자 놀이';
      case GameMode.vowel:
        return '모음 놀이';
      case GameMode.consonant:
        return '자음 놀이';
      case GameMode.combine:
        return '글자 만들기';
      case GameMode.batchim:
        return '받침 놀이';
      case GameMode.word:
        return '단어 놀이';
      case GameMode.challenge:
        return '도전 모드';
    }
  }

  String get emoji2 {
    switch (this) {
      case GameMode.syllable:
        return '가나다';
      case GameMode.vowel:
        return 'ㅏㅗㅜ';
      case GameMode.consonant:
        return 'ㄱㄴㄷ';
      case GameMode.combine:
        return 'ㄱ+ㅏ';
      case GameMode.batchim:
        return '받침';
      case GameMode.word:
        return '📝';
      case GameMode.challenge:
        return '🎲';
    }
  }

  String get description {
    switch (this) {
      case GameMode.syllable:
        return '그림을 보고 첫 글자 찾기';
      case GameMode.vowel:
        return '그림을 보고 모음 찾기';
      case GameMode.consonant:
        return '그림을 보고 첫소리 찾기';
      case GameMode.combine:
        return '자음+모음 합쳐 글자 만들기';
      case GameMode.batchim:
        return '글자 속 받침 찾기';
      case GameMode.word:
        return '단어를 읽고 그림 찾기';
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

  /// 숙련도 추적용 키 (예: 'c:ㄱ', 'w:사과')
  final List<String> masteryKeys;

  /// 한 라운드 안에서 중복 출제를 막는 키. 기본은 정답 단어.
  final String? dedupeKeyOverride;

  const HangulProblem({
    required this.mode,
    required this.question,
    required this.correctEmoji,
    required this.correctWord,
    required this.choices,
    this.masteryKeys = const [],
    this.dedupeKeyOverride,
  });

  String get dedupeKey => dedupeKeyOverride ?? correctWord;

  EmojiChoice get correctChoice => choices.firstWhere((c) => c.isCorrect);

  /// 정답 단어의 첫 글자
  String get firstSyllable =>
      correctWord.isNotEmpty ? correctWord.substring(0, 1) : '';

  /// 보기 순서만 섞은 복사본 (틀린 문제 다시 풀기용)
  HangulProblem withShuffledChoices(Random random) => HangulProblem(
        mode: mode,
        question: question,
        correctEmoji: correctEmoji,
        correctWord: correctWord,
        choices: List.of(choices)..shuffle(random),
        masteryKeys: masteryKeys,
        dedupeKeyOverride: dedupeKeyOverride,
      );

  /// 정답 화면에 보여줄 해설
  String get explanation {
    final c = correctChoice.emoji;
    switch (mode) {
      case GameMode.consonant:
        return '$correctWord${HangulJamo.eunNeun(correctWord)} '
            '$c(${HangulJamo.soundOf(c)})으로 시작해요!';
      case GameMode.vowel:
        return '$correctWord의 첫 모음은 $c(${HangulJamo.soundOf(c)})예요!';
      case GameMode.syllable:
        return '$correctWord의 첫 글자는 \'$c\'${HangulJamo.iEyo(c)}!';
      case GameMode.batchim:
        final where = correctWord == firstSyllable
            ? '\'$firstSyllable\'의'
            : '$correctWord의 \'$firstSyllable\'';
        return '$where 받침은 $c(${HangulJamo.nameOf(c)})이에요!';
      case GameMode.combine:
        final tail = correctWord == c
            ? '$correctWord${HangulJamo.iEyo(correctWord)}'
            : '$correctWord의 \'$c\'${HangulJamo.iEyo(c)}';
        return '$question = $c! $tail!';
      case GameMode.word:
        return '$correctWord${HangulJamo.eunNeun(correctWord)} '
            '$correctEmoji ${HangulJamo.iEyo(correctWord)}!';
      case GameMode.challenge:
        return '정답은 $correctWord $correctEmoji!';
    }
  }

  /// 문제가 나올 때 읽어줄 말.
  /// 단어 놀이는 정답을 알려주지 않도록 단어를 읽지 않는다.
  String get spokenPrompt {
    switch (mode) {
      case GameMode.consonant:
        return '$correctWord! $correctWord'
            '${HangulJamo.eunNeun(correctWord)} 어떤 소리로 시작할까?';
      case GameMode.vowel:
        return '$correctWord! 첫 모음 소리는 무엇일까?';
      case GameMode.syllable:
        return '$correctWord! 첫 글자는 무엇일까?';
      case GameMode.batchim:
        final intro = correctWord == firstSyllable
            ? firstSyllable
            : '$correctWord의 $firstSyllable';
        return '$intro! 받침은 무엇일까?';
      case GameMode.combine:
        final parts = question.split(' + ');
        final sounds = <String>[];
        for (var i = 0; i < parts.length; i++) {
          if (i == 2) {
            sounds.add('받침 ${HangulJamo.nameOf(parts[i])}');
          } else {
            sounds.add(HangulJamo.soundOf(parts[i]));
          }
        }
        return '${sounds.join('! ')}! 합치면 어떤 글자가 될까?';
      case GameMode.word:
        return '단어를 읽고, 맞는 그림을 찾아봐!';
      case GameMode.challenge:
        return '맞는 그림을 골라봐!';
    }
  }

  /// 정답 공개 후 읽어줄 말 (TTS가 자모 기호를 못 읽으므로 음가·이름으로 변환)
  String get spokenAnswer {
    final c = correctChoice.emoji;
    switch (mode) {
      case GameMode.consonant:
        return '$correctWord${HangulJamo.eunNeun(correctWord)} '
            '${HangulJamo.soundOf(c)}, ${HangulJamo.nameOf(c)}으로 시작해요!';
      case GameMode.vowel:
        return '$correctWord의 첫 모음은 ${HangulJamo.soundOf(c)}!';
      case GameMode.syllable:
        return '$correctWord의 첫 글자는 $c!';
      case GameMode.batchim:
        return '$firstSyllable의 받침은 ${HangulJamo.nameOf(c)}!';
      case GameMode.combine:
        final tail = correctWord == c ? '$correctWord!' : '$correctWord의 $c!';
        return '합치면 $c! $tail';
      case GameMode.word:
      case GameMode.challenge:
        return '정답은 $correctWord!';
    }
  }
}

class GameResult {
  final GameMode mode;
  final int difficultyLevel;
  final List<HangulProblem> problems;
  final List<EmojiChoice?> userAnswers;
  final int score;
  final int maxStreak;
  final Duration elapsed;

  /// 틀린 문제만 다시 푸는 복습 라운드인지
  final bool isRetry;

  const GameResult({
    required this.mode,
    required this.difficultyLevel,
    required this.problems,
    required this.userAnswers,
    required this.score,
    required this.maxStreak,
    required this.elapsed,
    this.isRetry = false,
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
