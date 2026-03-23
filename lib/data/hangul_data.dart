class HangulWord {
  final String word;
  final String emoji;
  final String consonant;
  final String syllable;
  final int difficulty;

  const HangulWord({
    required this.word,
    required this.emoji,
    required this.consonant,
    required this.syllable,
    required this.difficulty,
  });
}

class HangulData {
  static const List<HangulWord> words = [
    // ㄱ (6개)
    HangulWord(word: '개', emoji: '🐕', consonant: 'ㄱ', syllable: '개', difficulty: 1),
    HangulWord(word: '곰', emoji: '🐻', consonant: 'ㄱ', syllable: '곰', difficulty: 1),
    HangulWord(word: '공', emoji: '⚽', consonant: 'ㄱ', syllable: '공', difficulty: 1),
    HangulWord(word: '거북이', emoji: '🐢', consonant: 'ㄱ', syllable: '거', difficulty: 2),
    HangulWord(word: '귤', emoji: '🍊', consonant: 'ㄱ', syllable: '귤', difficulty: 2),
    HangulWord(word: '기차', emoji: '🚂', consonant: 'ㄱ', syllable: '기', difficulty: 2),

    // ㄴ (5개)
    HangulWord(word: '나비', emoji: '🦋', consonant: 'ㄴ', syllable: '나', difficulty: 1),
    HangulWord(word: '나무', emoji: '🌳', consonant: 'ㄴ', syllable: '나', difficulty: 1),
    HangulWord(word: '눈', emoji: '❄️', consonant: 'ㄴ', syllable: '눈', difficulty: 1),
    HangulWord(word: '노래', emoji: '🎵', consonant: 'ㄴ', syllable: '노', difficulty: 2),
    HangulWord(word: '냄비', emoji: '🍲', consonant: 'ㄴ', syllable: '냄', difficulty: 3),

    // ㄷ (5개)
    HangulWord(word: '달', emoji: '🌙', consonant: 'ㄷ', syllable: '달', difficulty: 1),
    HangulWord(word: '돼지', emoji: '🐷', consonant: 'ㄷ', syllable: '돼', difficulty: 1),
    HangulWord(word: '다람쥐', emoji: '🐿️', consonant: 'ㄷ', syllable: '다', difficulty: 2),
    HangulWord(word: '도넛', emoji: '🍩', consonant: 'ㄷ', syllable: '도', difficulty: 2),
    HangulWord(word: '독수리', emoji: '🦅', consonant: 'ㄷ', syllable: '독', difficulty: 3),

    // ㄹ (5개)
    HangulWord(word: '라면', emoji: '🍜', consonant: 'ㄹ', syllable: '라', difficulty: 2),
    HangulWord(word: '로봇', emoji: '🤖', consonant: 'ㄹ', syllable: '로', difficulty: 2),
    HangulWord(word: '리본', emoji: '🎀', consonant: 'ㄹ', syllable: '리', difficulty: 2),
    HangulWord(word: '로켓', emoji: '🚀', consonant: 'ㄹ', syllable: '로', difficulty: 2),
    HangulWord(word: '레몬', emoji: '🍋', consonant: 'ㄹ', syllable: '레', difficulty: 2),

    // ㅁ (6개)
    HangulWord(word: '말', emoji: '🐴', consonant: 'ㅁ', syllable: '말', difficulty: 1),
    HangulWord(word: '모자', emoji: '🧢', consonant: 'ㅁ', syllable: '모', difficulty: 1),
    HangulWord(word: '무지개', emoji: '🌈', consonant: 'ㅁ', syllable: '무', difficulty: 2),
    HangulWord(word: '물고기', emoji: '🐟', consonant: 'ㅁ', syllable: '물', difficulty: 2),
    HangulWord(word: '마우스', emoji: '🖱️', consonant: 'ㅁ', syllable: '마', difficulty: 3),
    HangulWord(word: '멜론', emoji: '🍈', consonant: 'ㅁ', syllable: '멜', difficulty: 3),

    // ㅂ (6개)
    HangulWord(word: '배', emoji: '🍐', consonant: 'ㅂ', syllable: '배', difficulty: 1),
    HangulWord(word: '별', emoji: '⭐', consonant: 'ㅂ', syllable: '별', difficulty: 1),
    HangulWord(word: '바나나', emoji: '🍌', consonant: 'ㅂ', syllable: '바', difficulty: 2),
    HangulWord(word: '버스', emoji: '🚌', consonant: 'ㅂ', syllable: '버', difficulty: 2),
    HangulWord(word: '비행기', emoji: '✈️', consonant: 'ㅂ', syllable: '비', difficulty: 2),
    HangulWord(word: '병아리', emoji: '🐤', consonant: 'ㅂ', syllable: '병', difficulty: 3),

    // ㅅ (6개)
    HangulWord(word: '사과', emoji: '🍎', consonant: 'ㅅ', syllable: '사', difficulty: 1),
    HangulWord(word: '새', emoji: '🐦', consonant: 'ㅅ', syllable: '새', difficulty: 1),
    HangulWord(word: '소', emoji: '🐄', consonant: 'ㅅ', syllable: '소', difficulty: 1),
    HangulWord(word: '수박', emoji: '🍉', consonant: 'ㅅ', syllable: '수', difficulty: 1),
    HangulWord(word: '사자', emoji: '🦁', consonant: 'ㅅ', syllable: '사', difficulty: 1),
    HangulWord(word: '선물', emoji: '🎁', consonant: 'ㅅ', syllable: '선', difficulty: 2),

    // ㅇ (6개)
    HangulWord(word: '오리', emoji: '🦆', consonant: 'ㅇ', syllable: '오', difficulty: 1),
    HangulWord(word: '우유', emoji: '🥛', consonant: 'ㅇ', syllable: '우', difficulty: 1),
    HangulWord(word: '우산', emoji: '☂️', consonant: 'ㅇ', syllable: '우', difficulty: 1),
    HangulWord(word: '아이스크림', emoji: '🍦', consonant: 'ㅇ', syllable: '아', difficulty: 3),
    HangulWord(word: '연필', emoji: '✏️', consonant: 'ㅇ', syllable: '연', difficulty: 2),
    HangulWord(word: '열쇠', emoji: '🔑', consonant: 'ㅇ', syllable: '열', difficulty: 3),

    // ㅈ (5개)
    HangulWord(word: '자동차', emoji: '🚗', consonant: 'ㅈ', syllable: '자', difficulty: 2),
    HangulWord(word: '지구', emoji: '🌍', consonant: 'ㅈ', syllable: '지', difficulty: 2),
    HangulWord(word: '주스', emoji: '🧃', consonant: 'ㅈ', syllable: '주', difficulty: 2),
    HangulWord(word: '종', emoji: '🔔', consonant: 'ㅈ', syllable: '종', difficulty: 1),
    HangulWord(word: '젖소', emoji: '🐮', consonant: 'ㅈ', syllable: '젖', difficulty: 2),

    // ㅊ (5개)
    HangulWord(word: '책', emoji: '📖', consonant: 'ㅊ', syllable: '책', difficulty: 1),
    HangulWord(word: '치즈', emoji: '🧀', consonant: 'ㅊ', syllable: '치', difficulty: 2),
    HangulWord(word: '초콜릿', emoji: '🍫', consonant: 'ㅊ', syllable: '초', difficulty: 3),
    HangulWord(word: '체리', emoji: '🍒', consonant: 'ㅊ', syllable: '체', difficulty: 2),
    HangulWord(word: '촛불', emoji: '🕯️', consonant: 'ㅊ', syllable: '촛', difficulty: 2),

    // ㅋ (4개)
    HangulWord(word: '코', emoji: '👃', consonant: 'ㅋ', syllable: '코', difficulty: 1),
    HangulWord(word: '케이크', emoji: '🎂', consonant: 'ㅋ', syllable: '케', difficulty: 2),
    HangulWord(word: '코끼리', emoji: '🐘', consonant: 'ㅋ', syllable: '코', difficulty: 2),
    HangulWord(word: '컵', emoji: '☕', consonant: 'ㅋ', syllable: '컵', difficulty: 1),

    // ㅌ (5개)
    HangulWord(word: '토끼', emoji: '🐰', consonant: 'ㅌ', syllable: '토', difficulty: 1),
    HangulWord(word: '태양', emoji: '☀️', consonant: 'ㅌ', syllable: '태', difficulty: 2),
    HangulWord(word: '트럭', emoji: '🚚', consonant: 'ㅌ', syllable: '트', difficulty: 2),
    HangulWord(word: '텐트', emoji: '⛺', consonant: 'ㅌ', syllable: '텐', difficulty: 2),
    HangulWord(word: '튤립', emoji: '🌷', consonant: 'ㅌ', syllable: '튤', difficulty: 3),

    // ㅍ (5개)
    HangulWord(word: '포도', emoji: '🍇', consonant: 'ㅍ', syllable: '포', difficulty: 1),
    HangulWord(word: '피자', emoji: '🍕', consonant: 'ㅍ', syllable: '피', difficulty: 1),
    HangulWord(word: '펭귄', emoji: '🐧', consonant: 'ㅍ', syllable: '펭', difficulty: 2),
    HangulWord(word: '풍선', emoji: '🎈', consonant: 'ㅍ', syllable: '풍', difficulty: 2),
    HangulWord(word: '파인애플', emoji: '🍍', consonant: 'ㅍ', syllable: '파', difficulty: 3),

    // ㅎ (5개)
    HangulWord(word: '하마', emoji: '🦛', consonant: 'ㅎ', syllable: '하', difficulty: 1),
    HangulWord(word: '호랑이', emoji: '🐯', consonant: 'ㅎ', syllable: '호', difficulty: 2),
    HangulWord(word: '해바라기', emoji: '🌻', consonant: 'ㅎ', syllable: '해', difficulty: 3),
    HangulWord(word: '햄버거', emoji: '🍔', consonant: 'ㅎ', syllable: '햄', difficulty: 2),
    HangulWord(word: '하트', emoji: '❤️', consonant: 'ㅎ', syllable: '하', difficulty: 1),
  ];

  static const List<String> allConsonants = [
    'ㄱ', 'ㄴ', 'ㄷ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅅ',
    'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ',
  ];

  static List<HangulWord> wordsForConsonant(String consonant) {
    return words.where((w) => w.consonant == consonant).toList();
  }

  static List<HangulWord> wordsByDifficulty(int maxDifficulty) {
    return words.where((w) => w.difficulty <= maxDifficulty).toList();
  }
}
