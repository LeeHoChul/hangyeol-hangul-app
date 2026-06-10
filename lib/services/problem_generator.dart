import 'dart:math';
import '../data/hangul_data.dart';
import '../models/hangul_problem.dart';
import '../utils/hangul_utils.dart';
import 'mastery_service.dart';

class ProblemGenerator {
  ProblemGenerator({MasteryService? mastery}) : _mastery = mastery;

  final MasteryService? _mastery;
  final _random = Random();

  static const _vowelsL1 = ['ㅏ', 'ㅗ', 'ㅜ', 'ㅣ'];
  static const _vowelsL2 = ['ㅏ', 'ㅗ', 'ㅜ', 'ㅣ', 'ㅓ', 'ㅡ', 'ㅐ', 'ㅔ'];
  static const _batchimsL1 = ['ㄴ', 'ㄹ', 'ㅁ', 'ㅇ'];
  static const _batchimsL2 = ['ㄴ', 'ㄹ', 'ㅁ', 'ㅇ', 'ㄱ', 'ㅂ'];

  List<DifficultyLevel> levelsForMode(GameMode mode) {
    switch (mode) {
      case GameMode.syllable:
        return const [
          DifficultyLevel(level: 1, name: '아기 새', emoji: '🐤', description: '가,나,다,마 행', choiceCount: 2),
          DifficultyLevel(level: 2, name: '똑똑한 앵무', emoji: '🦜', description: '가~바 행', choiceCount: 3),
          DifficultyLevel(level: 3, name: '지혜로운 부엉이', emoji: '🦉', description: '가~하 전체 + 비슷한 글자', choiceCount: 4),
        ];
      case GameMode.vowel:
        return const [
          DifficultyLevel(level: 1, name: '아기 물개', emoji: '🦭', description: 'ㅏ,ㅗ,ㅜ,ㅣ 모음', choiceCount: 2),
          DifficultyLevel(level: 2, name: '신나는 돌고래', emoji: '🐬', description: 'ㅓ,ㅡ,ㅐ,ㅔ까지', choiceCount: 3),
          DifficultyLevel(level: 3, name: '바다의 왕 고래', emoji: '🐋', description: '전체 모음', choiceCount: 4),
        ];
      case GameMode.consonant:
        return const [
          DifficultyLevel(level: 1, name: '아기 곰', emoji: '🐻', description: 'ㄱ,ㄴ,ㄷ,ㅁ 자음', choiceCount: 2),
          DifficultyLevel(level: 2, name: '꼬마 토끼', emoji: '🐰', description: 'ㄱ~ㅂ 자음', choiceCount: 3),
          DifficultyLevel(level: 3, name: '용감한 호랑이', emoji: '🐯', description: '전체 자음 + 비슷한 자음', choiceCount: 4),
        ];
      case GameMode.combine:
        return const [
          DifficultyLevel(level: 1, name: '꼬마 건축가', emoji: '🧱', description: '자음+모음 (ㅏ,ㅗ,ㅜ,ㅣ)', choiceCount: 2),
          DifficultyLevel(level: 2, name: '글자 목수', emoji: '🔨', description: '자음+모음 전체', choiceCount: 3),
          DifficultyLevel(level: 3, name: '글자 건축왕', emoji: '🏰', description: '받침 글자 만들기', choiceCount: 4),
        ];
      case GameMode.batchim:
        return const [
          DifficultyLevel(level: 1, name: '아기 거북', emoji: '🐢', description: 'ㄴ,ㄹ,ㅁ,ㅇ 받침', choiceCount: 2),
          DifficultyLevel(level: 2, name: '단단한 게', emoji: '🦀', description: 'ㄱ,ㅂ 받침까지', choiceCount: 3),
          DifficultyLevel(level: 3, name: '받침 박사 문어', emoji: '🐙', description: '전체 받침', choiceCount: 4),
        ];
      case GameMode.word:
        return const [
          DifficultyLevel(level: 1, name: '꼬마 탐험가', emoji: '🧒', description: '받침 없는 쉬운 단어', choiceCount: 2),
          DifficultyLevel(level: 2, name: '글자 용사', emoji: '⚔️', description: '받침 단어까지', choiceCount: 3),
          DifficultyLevel(level: 3, name: '단어 마법사', emoji: '🧙', description: '비슷한 단어 구별하기', choiceCount: 4),
          DifficultyLevel(level: 4, name: '한글 왕', emoji: '👑', description: '길고 어려운 단어 포함', choiceCount: 4),
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
      seen.add(problem.dedupeKey);
    }

    return problems;
  }

  static const _challengeModes = [
    GameMode.syllable,
    GameMode.vowel,
    GameMode.consonant,
    GameMode.combine,
    GameMode.batchim,
    GameMode.word,
  ];

  List<HangulProblem> _generateChallengeRound(int difficultyLevel, int count) {
    final problems = <HangulProblem>[];
    final seen = <String>{};

    for (var i = 0; i < count; i++) {
      final mode = _challengeModes[_random.nextInt(_challengeModes.length)];
      final modeLevel = difficultyLevel.clamp(1, levelsForMode(mode).length);
      final problem = _generateProblem(mode, modeLevel, seen);
      problems.add(problem);
      seen.add(problem.dedupeKey);
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
      case GameMode.syllable:
        return _generateSyllableProblem(difficultyLevel, choiceCount, seen);
      case GameMode.vowel:
        return _generateVowelProblem(difficultyLevel, choiceCount, seen);
      case GameMode.consonant:
        return _generateConsonantProblem(difficultyLevel, choiceCount, seen);
      case GameMode.combine:
        return _generateCombineProblem(difficultyLevel, choiceCount, seen);
      case GameMode.batchim:
        return _generateBatchimProblem(difficultyLevel, choiceCount, seen);
      case GameMode.word:
      case GameMode.challenge:
        return _generateWordProblem(difficultyLevel, choiceCount, seen);
    }
  }

  // ---- 가중 추첨 (간격 반복: 틀린 항목일수록 자주 나옴) ----

  double _weight(String key) => _mastery?.weightFor(key) ?? 1.0;

  T _weightedPick<T>(List<T> items, double Function(T) weightOf) {
    var total = 0.0;
    final weights = <double>[];
    for (final item in items) {
      final w = max(weightOf(item), 0.01);
      weights.add(w);
      total += w;
    }
    var roll = _random.nextDouble() * total;
    for (var i = 0; i < items.length; i++) {
      roll -= weights[i];
      if (roll <= 0) return items[i];
    }
    return items.last;
  }

  HangulWord _pickWord(
    List<HangulWord> candidates,
    Set<String> seen, {
    String Function(HangulWord)? weightKey,
    String Function(HangulWord)? dedupeKey,
  }) {
    final dk = dedupeKey ?? ((HangulWord w) => w.word);
    final wk = weightKey ?? ((HangulWord w) => 'w:${w.word}');
    final unseen = candidates.where((w) => !seen.contains(dk(w))).toList();
    final pool = unseen.isNotEmpty ? unseen : candidates;
    return _weightedPick(pool, (w) => _weight(wk(w)));
  }

  /// 유사 항목을 우선 배치하고 부족분은 풀에서 무작위로 채운 교란지 목록
  List<String> _distractorsFrom({
    required String correct,
    required List<String> pool,
    required List<String> similar,
    required int count,
  }) {
    final result = <String>[];
    final sim = similar.where((s) => s != correct && pool.contains(s)).toList()
      ..shuffle(_random);
    result.addAll(sim.take(count));
    if (result.length < count) {
      final rest = pool
          .where((c) => c != correct && !result.contains(c))
          .toList()
        ..shuffle(_random);
      result.addAll(rest.take(count - result.length));
    }
    return result;
  }

  List<EmojiChoice> _letterChoices(String correct, List<String> distractors) {
    final choices = <EmojiChoice>[
      EmojiChoice(emoji: correct, word: correct, isCorrect: true),
      ...distractors.map((d) => EmojiChoice(emoji: d, word: d, isCorrect: false)),
    ]..shuffle(_random);
    return choices;
  }

  // ---- 자음 놀이: 그림 → 첫소리 ----

  HangulProblem _generateConsonantProblem(int level, int choiceCount, Set<String> seen) {
    final consonants = _consonantsForLevel(level);
    final consonant = _weightedPick(consonants, (c) => _weight('c:$c'));
    final candidates = HangulData.wordsForConsonant(consonant);
    final correctWord = _pickWord(candidates, seen);

    // 최고 난이도에서는 모양·소리가 비슷한 자음을 교란지로 우선 사용
    final distractors = _distractorsFrom(
      correct: consonant,
      pool: consonants,
      similar: level >= 3 ? HangulSimilarity.consonants(consonant) : const [],
      count: choiceCount - 1,
    );

    return HangulProblem(
      mode: GameMode.consonant,
      question: correctWord.emoji,
      correctEmoji: correctWord.emoji,
      correctWord: correctWord.word,
      choices: _letterChoices(consonant, distractors),
      masteryKeys: ['c:$consonant', 'w:${correctWord.word}'],
    );
  }

  // ---- 모음 놀이: 그림 → 첫 모음 ----

  HangulProblem _generateVowelProblem(int level, int choiceCount, Set<String> seen) {
    final vowels = _vowelsForLevel(level);
    final vowel = _weightedPick(vowels, (v) => _weight('v:$v'));
    final candidates = HangulData.wordsForVowel(vowel);
    final correctWord = _pickWord(candidates, seen);

    final distractors = _distractorsFrom(
      correct: vowel,
      pool: _vowelChoicePool(level),
      similar: level >= 3 ? HangulSimilarity.vowels(vowel) : const [],
      count: choiceCount - 1,
    );

    return HangulProblem(
      mode: GameMode.vowel,
      question: correctWord.emoji,
      correctEmoji: correctWord.emoji,
      correctWord: correctWord.word,
      choices: _letterChoices(vowel, distractors),
      masteryKeys: ['v:$vowel', 'w:${correctWord.word}'],
    );
  }

  List<String> _vowelsForLevel(int level) {
    final available = HangulData.availableVowels();
    switch (level) {
      case 1:
        return _vowelsL1.where(available.contains).toList();
      case 2:
        return _vowelsL2.where(available.contains).toList();
      default:
        return available;
    }
  }

  List<String> _vowelChoicePool(int level) {
    switch (level) {
      case 1:
        return _vowelsL1;
      case 2:
        return _vowelsL2;
      default:
        return const [
          'ㅏ', 'ㅑ', 'ㅓ', 'ㅕ', 'ㅗ', 'ㅛ', 'ㅜ', 'ㅠ', 'ㅡ', 'ㅣ',
          'ㅐ', 'ㅔ', 'ㅘ', 'ㅙ',
        ];
    }
  }

  // ---- 낱글자 놀이: 그림 → 첫 글자 ----

  HangulProblem _generateSyllableProblem(int level, int choiceCount, Set<String> seen) {
    final consonants = _consonantsForLevel(level);
    final candidates = HangulData.words
        .where((w) => consonants.contains(w.consonant))
        .toList();
    final correctWord = _pickWord(
      candidates,
      seen,
      weightKey: (w) => 's:${w.syllable}',
      dedupeKey: (w) => w.syllable,
    );
    final correctSyllable = correctWord.syllable;

    final distractorSyllables = <String>{};

    // 최고 난이도: 자음 또는 모음 하나만 다른 글자로 변별 연습 (가↔고, 가↔다)
    if (level >= 3) {
      final cho = HangulJamo.initialOf(correctSyllable);
      final jung = HangulJamo.vowelOf(correctSyllable);
      final jong = HangulJamo.batchimOf(correctSyllable);

      final vowelOptions = _vowelsL2.where((v) => v != jung).toList()
        ..shuffle(_random);
      for (final v in vowelOptions) {
        final s = HangulJamo.compose(cho, v, jong);
        if (s.isNotEmpty && s != correctSyllable) {
          distractorSyllables.add(s);
          break;
        }
      }

      final consOptions = HangulData.allConsonants
          .where((c) => c != cho)
          .toList()
        ..shuffle(_random);
      for (final c in consOptions) {
        final s = HangulJamo.compose(c, jung, jong);
        if (s.isNotEmpty &&
            s != correctSyllable &&
            !distractorSyllables.contains(s)) {
          distractorSyllables.add(s);
          break;
        }
      }
    }

    // 나머지는 다른 자음으로 시작하는 단어의 첫 글자에서
    final otherSyllables = HangulData.words
        .where((w) => w.consonant != correctWord.consonant)
        .map((w) => w.syllable)
        .where((s) => s != correctSyllable)
        .toList()
      ..shuffle(_random);
    for (final s in otherSyllables) {
      if (distractorSyllables.length >= choiceCount - 1) break;
      distractorSyllables.add(s);
    }

    return HangulProblem(
      mode: GameMode.syllable,
      question: correctWord.emoji,
      correctEmoji: correctWord.emoji,
      correctWord: correctWord.word,
      choices: _letterChoices(
        correctSyllable,
        distractorSyllables.take(choiceCount - 1).toList(),
      ),
      masteryKeys: ['s:$correctSyllable', 'w:${correctWord.word}'],
      dedupeKeyOverride: correctSyllable,
    );
  }

  // ---- 받침 놀이: 글자 → 받침 찾기 ----

  HangulProblem _generateBatchimProblem(int level, int choiceCount, Set<String> seen) {
    final batchims = _batchimsForLevel(level);
    final batchim = _weightedPick(batchims, (b) => _weight('b:$b'));
    final candidates = HangulData.wordsForBatchim(batchim);
    final correctWord = _pickWord(
      candidates,
      seen,
      dedupeKey: (w) => w.syllable,
    );

    final distractors = _distractorsFrom(
      correct: batchim,
      pool: _batchimChoicePool(level),
      similar: level >= 3 ? HangulSimilarity.consonants(batchim) : const [],
      count: choiceCount - 1,
    );

    return HangulProblem(
      mode: GameMode.batchim,
      question: '${correctWord.emoji} ${correctWord.syllable}',
      correctEmoji: correctWord.emoji,
      correctWord: correctWord.word,
      choices: _letterChoices(batchim, distractors),
      masteryKeys: ['b:$batchim', 'w:${correctWord.word}'],
      dedupeKeyOverride: correctWord.syllable,
    );
  }

  List<String> _batchimsForLevel(int level) {
    final available = HangulData.availableBatchims();
    switch (level) {
      case 1:
        return _batchimsL1.where(available.contains).toList();
      case 2:
        return _batchimsL2.where(available.contains).toList();
      default:
        return available;
    }
  }

  List<String> _batchimChoicePool(int level) {
    switch (level) {
      case 1:
        return _batchimsL1;
      case 2:
        return _batchimsL2;
      default:
        return HangulData.availableBatchims();
    }
  }

  // ---- 글자 만들기: 자음+모음(+받침) → 글자 ----

  HangulProblem _generateCombineProblem(int level, int choiceCount, Set<String> seen) {
    // 대상 글자 풀: 단어의 첫 글자 (정답 후 단어 카드를 보여주기 위해)
    final targets = <String, List<HangulWord>>{};
    for (final w in HangulData.words) {
      final ok = switch (level) {
        1 => !w.syllableHasBatchim && _vowelsL1.contains(w.vowel),
        2 => !w.syllableHasBatchim,
        _ => w.syllableHasBatchim,
      };
      if (ok) {
        targets.putIfAbsent(w.syllable, () => []).add(w);
      }
    }

    var syllables =
        targets.keys.where((s) => !seen.contains(s)).toList();
    if (syllables.isEmpty) syllables = targets.keys.toList();
    final syllable = _weightedPick(syllables, (s) => _weight('j:$s'));
    final sourceWords = targets[syllable]!;
    final sourceWord = sourceWords[_random.nextInt(sourceWords.length)];

    final cho = HangulJamo.initialOf(syllable);
    final jung = HangulJamo.vowelOf(syllable);
    final jong = HangulJamo.batchimOf(syllable);
    final question =
        jong.isEmpty ? '$cho + $jung' : '$cho + $jung + $jong';

    // 교란지: 구성 요소를 하나만 바꾼 글자 (감↔곰, 솜↔곰, 고↔곰)
    final distractors = <String>{};
    final vowelPool = (level == 1 ? _vowelsL1 : _vowelsL2)
        .where((v) => v != jung)
        .toList()
      ..shuffle(_random);
    final consPool = HangulData.allConsonants
        .where((c) => c != cho)
        .toList()
      ..shuffle(_random);
    final jongPool = _batchimsL2.where((b) => b != jong).toList()
      ..shuffle(_random);

    final variations = <String>[];
    final rounds = max(vowelPool.length, consPool.length);
    for (var i = 0; i < rounds; i++) {
      if (i < vowelPool.length) {
        variations.add(HangulJamo.compose(cho, vowelPool[i], jong));
      }
      if (i < consPool.length) {
        variations.add(HangulJamo.compose(consPool[i], jung, jong));
      }
      if (jong.isNotEmpty) {
        if (i == 0) variations.add(HangulJamo.compose(cho, jung));
        if (i < jongPool.length) {
          variations.add(HangulJamo.compose(cho, jung, jongPool[i]));
        }
      }
    }
    for (final v in variations) {
      if (distractors.length >= choiceCount - 1) break;
      if (v.isNotEmpty && v != syllable) distractors.add(v);
    }

    return HangulProblem(
      mode: GameMode.combine,
      question: question,
      correctEmoji: sourceWord.emoji,
      correctWord: sourceWord.word,
      choices: _letterChoices(syllable, distractors.toList()),
      masteryKeys: ['j:$syllable'],
      dedupeKeyOverride: syllable,
    );
  }

  // ---- 단어 놀이: 단어 → 그림 ----

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
    final correctWord = _pickWord(candidates, seen);
    final distractors = _pickWordDistractors(
      correctWord,
      choiceCount - 1,
      preferSameStart: level >= 3,
    );

    final choices = <EmojiChoice>[
      EmojiChoice(emoji: correctWord.emoji, word: correctWord.word, isCorrect: true),
      ...distractors.map(
        (d) => EmojiChoice(emoji: d.emoji, word: d.word, isCorrect: false),
      ),
    ]..shuffle(_random);

    return HangulProblem(
      mode: GameMode.word,
      question: correctWord.word,
      correctEmoji: correctWord.emoji,
      correctWord: correctWord.word,
      choices: choices,
      masteryKeys: ['w:${correctWord.word}'],
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

  /// 단어 놀이 교란지.
  /// 높은 난이도에서는 첫 글자(사과↔사자)나 첫 자음이 같은 단어를 우선 배치해
  /// 첫 글자만 보고 찍는 전략을 막고 끝까지 읽게 한다.
  /// 헷갈리는 이모지 그룹(소↔젖소 등)은 보기에서 제외한다.
  List<HangulWord> _pickWordDistractors(
    HangulWord correct,
    int count, {
    bool preferSameStart = false,
  }) {
    final pool = HangulData.words
        .where((w) =>
            w.word != correct.word &&
            w.emoji != correct.emoji &&
            !HangulData.confusable(correct.word, w.word))
        .toList();

    final picked = <HangulWord>[];
    void fill(Iterable<HangulWord> source) {
      final list = source.where((w) => !picked.contains(w)).toList()
        ..shuffle(_random);
      for (final w in list) {
        if (picked.length >= count) return;
        picked.add(w);
      }
    }

    if (preferSameStart) {
      fill(pool.where((w) => w.syllable == correct.syllable));
      if (picked.length < count) {
        fill(pool.where((w) => w.consonant == correct.consonant));
      }
    }
    fill(pool.where((w) => w.word.length == correct.word.length));
    fill(pool);
    return picked;
  }
}
