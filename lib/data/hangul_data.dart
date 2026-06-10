import '../utils/hangul_utils.dart';

class HangulWord {
  final String word;
  final String emoji;
  final String consonant;
  final String syllable;

  const HangulWord({
    required this.word,
    required this.emoji,
    required this.consonant,
    required this.syllable,
  });

  /// 첫 글자의 모음(중성)
  String get vowel => HangulJamo.vowelOf(syllable);

  /// 첫 글자의 받침(종성). 없으면 빈 문자열
  String get batchim => HangulJamo.batchimOf(syllable);

  bool get syllableHasBatchim => batchim.isNotEmpty;

  /// 단어 어딘가에 받침이 있는지
  bool get hasAnyBatchim => word.codeUnits.any(
        (u) => u >= 0xAC00 && u <= 0xD7A3 && (u - 0xAC00) % 28 != 0,
      );

  /// 읽기 난이도. 글자 수 + 받침 유무 기반:
  /// 받침 없는 짧은 단어가 가장 쉽고, 길거나 받침이 있으면 어려워진다.
  int get difficulty {
    final base = word.length <= 2 ? 1 : (word.length == 3 ? 2 : 3);
    return (base + (hasAnyBatchim ? 1 : 0)).clamp(1, 3);
  }
}

class HangulData {
  static const List<HangulWord> words = [
    // ㄱ (10개)
    HangulWord(word: '개', emoji: '🐕', consonant: 'ㄱ', syllable: '개'),
    HangulWord(word: '곰', emoji: '🐻', consonant: 'ㄱ', syllable: '곰'),
    HangulWord(word: '공', emoji: '⚽', consonant: 'ㄱ', syllable: '공'),
    HangulWord(word: '구름', emoji: '☁️', consonant: 'ㄱ', syllable: '구'),
    HangulWord(word: '고양이', emoji: '🐱', consonant: 'ㄱ', syllable: '고'),
    HangulWord(word: '거북이', emoji: '🐢', consonant: 'ㄱ', syllable: '거'),
    HangulWord(word: '귤', emoji: '🍊', consonant: 'ㄱ', syllable: '귤'),
    HangulWord(word: '기차', emoji: '🚂', consonant: 'ㄱ', syllable: '기'),
    HangulWord(word: '고래', emoji: '🐋', consonant: 'ㄱ', syllable: '고'),
    HangulWord(word: '기린', emoji: '🦒', consonant: 'ㄱ', syllable: '기'),

    // ㄴ (8개)
    HangulWord(word: '나비', emoji: '🦋', consonant: 'ㄴ', syllable: '나'),
    HangulWord(word: '나무', emoji: '🌳', consonant: 'ㄴ', syllable: '나'),
    HangulWord(word: '눈', emoji: '❄️', consonant: 'ㄴ', syllable: '눈'),
    HangulWord(word: '노래', emoji: '🎵', consonant: 'ㄴ', syllable: '노'),
    HangulWord(word: '눈사람', emoji: '⛄', consonant: 'ㄴ', syllable: '눈'),
    HangulWord(word: '낙타', emoji: '🐪', consonant: 'ㄴ', syllable: '낙'),
    HangulWord(word: '넥타이', emoji: '👔', consonant: 'ㄴ', syllable: '넥'),
    HangulWord(word: '냄비', emoji: '🍲', consonant: 'ㄴ', syllable: '냄'),

    // ㄷ (8개)
    HangulWord(word: '달', emoji: '🌙', consonant: 'ㄷ', syllable: '달'),
    HangulWord(word: '돼지', emoji: '🐷', consonant: 'ㄷ', syllable: '돼'),
    HangulWord(word: '당근', emoji: '🥕', consonant: 'ㄷ', syllable: '당'),
    HangulWord(word: '다람쥐', emoji: '🐿️', consonant: 'ㄷ', syllable: '다'),
    HangulWord(word: '도넛', emoji: '🍩', consonant: 'ㄷ', syllable: '도'),
    HangulWord(word: '돌고래', emoji: '🐬', consonant: 'ㄷ', syllable: '돌'),
    HangulWord(word: '독수리', emoji: '🦅', consonant: 'ㄷ', syllable: '독'),
    HangulWord(word: '다이아몬드', emoji: '💎', consonant: 'ㄷ', syllable: '다'),
    HangulWord(word: '드럼', emoji: '🥁', consonant: 'ㄷ', syllable: '드'),

    // ㄹ (7개)
    HangulWord(word: '라면', emoji: '🍜', consonant: 'ㄹ', syllable: '라'),
    HangulWord(word: '로봇', emoji: '🤖', consonant: 'ㄹ', syllable: '로'),
    HangulWord(word: '리본', emoji: '🎀', consonant: 'ㄹ', syllable: '리'),
    HangulWord(word: '로켓', emoji: '🚀', consonant: 'ㄹ', syllable: '로'),
    HangulWord(word: '레몬', emoji: '🍋', consonant: 'ㄹ', syllable: '레'),
    HangulWord(word: '라디오', emoji: '📻', consonant: 'ㄹ', syllable: '라'),
    HangulWord(word: '롤러코스터', emoji: '🎢', consonant: 'ㄹ', syllable: '롤'),

    // ㅁ (9개)
    HangulWord(word: '말', emoji: '🐴', consonant: 'ㅁ', syllable: '말'),
    HangulWord(word: '모자', emoji: '🧢', consonant: 'ㅁ', syllable: '모'),
    HangulWord(word: '무지개', emoji: '🌈', consonant: 'ㅁ', syllable: '무'),
    HangulWord(word: '물고기', emoji: '🐟', consonant: 'ㅁ', syllable: '물'),
    HangulWord(word: '망치', emoji: '🔨', consonant: 'ㅁ', syllable: '망'),
    HangulWord(word: '문어', emoji: '🐙', consonant: 'ㅁ', syllable: '문'),
    HangulWord(word: '마이크', emoji: '🎤', consonant: 'ㅁ', syllable: '마'),
    HangulWord(word: '멜론', emoji: '🍈', consonant: 'ㅁ', syllable: '멜'),
    HangulWord(word: '마우스', emoji: '🖱️', consonant: 'ㅁ', syllable: '마'),

    // ㅂ (9개)
    HangulWord(word: '배', emoji: '🍐', consonant: 'ㅂ', syllable: '배'),
    HangulWord(word: '별', emoji: '⭐', consonant: 'ㅂ', syllable: '별'),
    HangulWord(word: '뱀', emoji: '🐍', consonant: 'ㅂ', syllable: '뱀'),
    HangulWord(word: '바나나', emoji: '🍌', consonant: 'ㅂ', syllable: '바'),
    HangulWord(word: '버스', emoji: '🚌', consonant: 'ㅂ', syllable: '버'),
    HangulWord(word: '비행기', emoji: '✈️', consonant: 'ㅂ', syllable: '비'),
    HangulWord(word: '복숭아', emoji: '🍑', consonant: 'ㅂ', syllable: '복'),
    HangulWord(word: '번개', emoji: '⚡', consonant: 'ㅂ', syllable: '번'),
    HangulWord(word: '병아리', emoji: '🐤', consonant: 'ㅂ', syllable: '병'),

    // ㅅ (10개)
    HangulWord(word: '사과', emoji: '🍎', consonant: 'ㅅ', syllable: '사'),
    HangulWord(word: '새', emoji: '🐦', consonant: 'ㅅ', syllable: '새'),
    HangulWord(word: '소', emoji: '🐄', consonant: 'ㅅ', syllable: '소'),
    HangulWord(word: '수박', emoji: '🍉', consonant: 'ㅅ', syllable: '수'),
    HangulWord(word: '사탕', emoji: '🍬', consonant: 'ㅅ', syllable: '사'),
    HangulWord(word: '사자', emoji: '🦁', consonant: 'ㅅ', syllable: '사'),
    HangulWord(word: '선물', emoji: '🎁', consonant: 'ㅅ', syllable: '선'),
    HangulWord(word: '상어', emoji: '🦈', consonant: 'ㅅ', syllable: '상'),
    HangulWord(word: '신발', emoji: '👟', consonant: 'ㅅ', syllable: '신'),
    HangulWord(word: '시계', emoji: '⌚', consonant: 'ㅅ', syllable: '시'),

    // ㅇ (9개)
    HangulWord(word: '오리', emoji: '🦆', consonant: 'ㅇ', syllable: '오'),
    HangulWord(word: '우유', emoji: '🥛', consonant: 'ㅇ', syllable: '우'),
    HangulWord(word: '우산', emoji: '☂️', consonant: 'ㅇ', syllable: '우'),
    HangulWord(word: '양', emoji: '🐑', consonant: 'ㅇ', syllable: '양'),
    HangulWord(word: '연필', emoji: '✏️', consonant: 'ㅇ', syllable: '연'),
    HangulWord(word: '왕관', emoji: '👑', consonant: 'ㅇ', syllable: '왕'),
    HangulWord(word: '안경', emoji: '👓', consonant: 'ㅇ', syllable: '안'),
    HangulWord(word: '열쇠', emoji: '🔑', consonant: 'ㅇ', syllable: '열'),
    HangulWord(word: '아이스크림', emoji: '🍦', consonant: 'ㅇ', syllable: '아'),

    // ㅈ (8개)
    HangulWord(word: '종', emoji: '🔔', consonant: 'ㅈ', syllable: '종'),
    HangulWord(word: '자동차', emoji: '🚗', consonant: 'ㅈ', syllable: '자'),
    HangulWord(word: '지구', emoji: '🌍', consonant: 'ㅈ', syllable: '지'),
    HangulWord(word: '주스', emoji: '🧃', consonant: 'ㅈ', syllable: '주'),
    HangulWord(word: '젖소', emoji: '🐮', consonant: 'ㅈ', syllable: '젖'),
    HangulWord(word: '장갑', emoji: '🧤', consonant: 'ㅈ', syllable: '장'),
    HangulWord(word: '전화기', emoji: '📞', consonant: 'ㅈ', syllable: '전'),
    HangulWord(word: '접시', emoji: '🍽️', consonant: 'ㅈ', syllable: '접'),

    // ㅊ (7개)
    HangulWord(word: '책', emoji: '📖', consonant: 'ㅊ', syllable: '책'),
    HangulWord(word: '치즈', emoji: '🧀', consonant: 'ㅊ', syllable: '치'),
    HangulWord(word: '체리', emoji: '🍒', consonant: 'ㅊ', syllable: '체'),
    HangulWord(word: '촛불', emoji: '🕯️', consonant: 'ㅊ', syllable: '촛'),
    HangulWord(word: '칫솔', emoji: '🪥', consonant: 'ㅊ', syllable: '칫'),
    HangulWord(word: '초콜릿', emoji: '🍫', consonant: 'ㅊ', syllable: '초'),
    HangulWord(word: '치마', emoji: '👗', consonant: 'ㅊ', syllable: '치'),

    // ㅋ (7개)
    HangulWord(word: '코', emoji: '👃', consonant: 'ㅋ', syllable: '코'),
    HangulWord(word: '컵', emoji: '☕', consonant: 'ㅋ', syllable: '컵'),
    HangulWord(word: '케이크', emoji: '🎂', consonant: 'ㅋ', syllable: '케'),
    HangulWord(word: '코끼리', emoji: '🐘', consonant: 'ㅋ', syllable: '코'),
    HangulWord(word: '카메라', emoji: '📷', consonant: 'ㅋ', syllable: '카'),
    HangulWord(word: '크레용', emoji: '🖍️', consonant: 'ㅋ', syllable: '크'),
    HangulWord(word: '캥거루', emoji: '🦘', consonant: 'ㅋ', syllable: '캥'),

    // ㅌ (7개)
    HangulWord(word: '토끼', emoji: '🐰', consonant: 'ㅌ', syllable: '토'),
    HangulWord(word: '토마토', emoji: '🍅', consonant: 'ㅌ', syllable: '토'),
    HangulWord(word: '태양', emoji: '☀️', consonant: 'ㅌ', syllable: '태'),
    HangulWord(word: '트럭', emoji: '🚚', consonant: 'ㅌ', syllable: '트'),
    HangulWord(word: '텐트', emoji: '⛺', consonant: 'ㅌ', syllable: '텐'),
    HangulWord(word: '티셔츠', emoji: '👕', consonant: 'ㅌ', syllable: '티'),
    HangulWord(word: '튤립', emoji: '🌷', consonant: 'ㅌ', syllable: '튤'),

    // ㅍ (7개)
    HangulWord(word: '포도', emoji: '🍇', consonant: 'ㅍ', syllable: '포'),
    HangulWord(word: '피자', emoji: '🍕', consonant: 'ㅍ', syllable: '피'),
    HangulWord(word: '펭귄', emoji: '🐧', consonant: 'ㅍ', syllable: '펭'),
    HangulWord(word: '풍선', emoji: '🎈', consonant: 'ㅍ', syllable: '풍'),
    HangulWord(word: '팝콘', emoji: '🍿', consonant: 'ㅍ', syllable: '팝'),
    HangulWord(word: '팬더', emoji: '🐼', consonant: 'ㅍ', syllable: '팬'),
    HangulWord(word: '파인애플', emoji: '🍍', consonant: 'ㅍ', syllable: '파'),

    // ㅎ (8개)
    HangulWord(word: '하마', emoji: '🦛', consonant: 'ㅎ', syllable: '하'),
    HangulWord(word: '하트', emoji: '❤️', consonant: 'ㅎ', syllable: '하'),
    HangulWord(word: '호랑이', emoji: '🐯', consonant: 'ㅎ', syllable: '호'),
    HangulWord(word: '햄버거', emoji: '🍔', consonant: 'ㅎ', syllable: '햄'),
    HangulWord(word: '헬리콥터', emoji: '🚁', consonant: 'ㅎ', syllable: '헬'),
    HangulWord(word: '핫도그', emoji: '🌭', consonant: 'ㅎ', syllable: '핫'),
    HangulWord(word: '호박', emoji: '🎃', consonant: 'ㅎ', syllable: '호'),
    HangulWord(word: '해바라기', emoji: '🌻', consonant: 'ㅎ', syllable: '해'),
  ];

  static const List<String> allConsonants = [
    'ㄱ', 'ㄴ', 'ㄷ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅅ',
    'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ',
  ];

  /// 이모지·의미가 비슷해서 보기로 같이 내면 헷갈리는 단어 그룹.
  /// 같은 그룹의 단어는 한 문제의 보기에 함께 나오지 않는다.
  static const List<List<String>> confusionGroups = [
    ['소', '젖소'],
    ['새', '병아리', '오리'],
    ['눈', '눈사람'],
    ['고래', '돌고래'],
  ];

  static bool confusable(String a, String b) =>
      confusionGroups.any((g) => g.contains(a) && g.contains(b));

  static List<HangulWord> wordsForConsonant(String consonant) {
    return words.where((w) => w.consonant == consonant).toList();
  }

  static List<HangulWord> wordsForVowel(String vowel) {
    return words.where((w) => w.vowel == vowel).toList();
  }

  static List<HangulWord> wordsForBatchim(String batchim) {
    return words.where((w) => w.batchim == batchim).toList();
  }

  static List<HangulWord> wordsByDifficulty(int maxDifficulty) {
    return words.where((w) => w.difficulty <= maxDifficulty).toList();
  }

  /// 데이터에 실제로 존재하는 첫 글자 모음 목록
  static List<String> availableVowels() =>
      words.map((w) => w.vowel).toSet().toList();

  /// 데이터에 실제로 존재하는 첫 글자 받침 목록
  static List<String> availableBatchims() => words
      .where((w) => w.syllableHasBatchim)
      .map((w) => w.batchim)
      .toSet()
      .toList();
}
