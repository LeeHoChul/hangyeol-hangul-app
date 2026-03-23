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
    // ㄱ (10개)
    HangulWord(word: '개', emoji: '🐕', consonant: 'ㄱ', syllable: '개', difficulty: 1),
    HangulWord(word: '곰', emoji: '🐻', consonant: 'ㄱ', syllable: '곰', difficulty: 1),
    HangulWord(word: '공', emoji: '⚽', consonant: 'ㄱ', syllable: '공', difficulty: 1),
    HangulWord(word: '구름', emoji: '☁️', consonant: 'ㄱ', syllable: '구', difficulty: 1),
    HangulWord(word: '고양이', emoji: '🐱', consonant: 'ㄱ', syllable: '고', difficulty: 1),
    HangulWord(word: '거북이', emoji: '🐢', consonant: 'ㄱ', syllable: '거', difficulty: 2),
    HangulWord(word: '귤', emoji: '🍊', consonant: 'ㄱ', syllable: '귤', difficulty: 2),
    HangulWord(word: '기차', emoji: '🚂', consonant: 'ㄱ', syllable: '기', difficulty: 2),
    HangulWord(word: '고래', emoji: '🐋', consonant: 'ㄱ', syllable: '고', difficulty: 2),
    HangulWord(word: '기린', emoji: '🦒', consonant: 'ㄱ', syllable: '기', difficulty: 2),

    // ㄴ (8개)
    HangulWord(word: '나비', emoji: '🦋', consonant: 'ㄴ', syllable: '나', difficulty: 1),
    HangulWord(word: '나무', emoji: '🌳', consonant: 'ㄴ', syllable: '나', difficulty: 1),
    HangulWord(word: '눈', emoji: '❄️', consonant: 'ㄴ', syllable: '눈', difficulty: 1),
    HangulWord(word: '노래', emoji: '🎵', consonant: 'ㄴ', syllable: '노', difficulty: 2),
    HangulWord(word: '눈사람', emoji: '⛄', consonant: 'ㄴ', syllable: '눈', difficulty: 2),
    HangulWord(word: '낙타', emoji: '🐪', consonant: 'ㄴ', syllable: '낙', difficulty: 2),
    HangulWord(word: '넥타이', emoji: '👔', consonant: 'ㄴ', syllable: '넥', difficulty: 3),
    HangulWord(word: '냄비', emoji: '🍲', consonant: 'ㄴ', syllable: '냄', difficulty: 3),

    // ㄷ (8개)
    HangulWord(word: '달', emoji: '🌙', consonant: 'ㄷ', syllable: '달', difficulty: 1),
    HangulWord(word: '돼지', emoji: '🐷', consonant: 'ㄷ', syllable: '돼', difficulty: 1),
    HangulWord(word: '당근', emoji: '🥕', consonant: 'ㄷ', syllable: '당', difficulty: 1),
    HangulWord(word: '다람쥐', emoji: '🐿️', consonant: 'ㄷ', syllable: '다', difficulty: 2),
    HangulWord(word: '도넛', emoji: '🍩', consonant: 'ㄷ', syllable: '도', difficulty: 2),
    HangulWord(word: '돌고래', emoji: '🐬', consonant: 'ㄷ', syllable: '돌', difficulty: 2),
    HangulWord(word: '독수리', emoji: '🦅', consonant: 'ㄷ', syllable: '독', difficulty: 3),
    HangulWord(word: '다이아몬드', emoji: '💎', consonant: 'ㄷ', syllable: '다', difficulty: 3),
    HangulWord(word: '드럼', emoji: '🥁', consonant: 'ㄷ', syllable: '드', difficulty: 2),

    // ㄹ (7개)
    HangulWord(word: '라면', emoji: '🍜', consonant: 'ㄹ', syllable: '라', difficulty: 2),
    HangulWord(word: '로봇', emoji: '🤖', consonant: 'ㄹ', syllable: '로', difficulty: 2),
    HangulWord(word: '리본', emoji: '🎀', consonant: 'ㄹ', syllable: '리', difficulty: 2),
    HangulWord(word: '로켓', emoji: '🚀', consonant: 'ㄹ', syllable: '로', difficulty: 2),
    HangulWord(word: '레몬', emoji: '🍋', consonant: 'ㄹ', syllable: '레', difficulty: 2),
    HangulWord(word: '라디오', emoji: '📻', consonant: 'ㄹ', syllable: '라', difficulty: 3),
    HangulWord(word: '롤러코스터', emoji: '🎢', consonant: 'ㄹ', syllable: '롤', difficulty: 3),

    // ㅁ (9개)
    HangulWord(word: '말', emoji: '🐴', consonant: 'ㅁ', syllable: '말', difficulty: 1),
    HangulWord(word: '모자', emoji: '🧢', consonant: 'ㅁ', syllable: '모', difficulty: 1),
    HangulWord(word: '무지개', emoji: '🌈', consonant: 'ㅁ', syllable: '무', difficulty: 2),
    HangulWord(word: '물고기', emoji: '🐟', consonant: 'ㅁ', syllable: '물', difficulty: 2),
    HangulWord(word: '망치', emoji: '🔨', consonant: 'ㅁ', syllable: '망', difficulty: 2),
    HangulWord(word: '문어', emoji: '🐙', consonant: 'ㅁ', syllable: '문', difficulty: 2),
    HangulWord(word: '마이크', emoji: '🎤', consonant: 'ㅁ', syllable: '마', difficulty: 2),
    HangulWord(word: '멜론', emoji: '🍈', consonant: 'ㅁ', syllable: '멜', difficulty: 3),
    HangulWord(word: '마우스', emoji: '🖱️', consonant: 'ㅁ', syllable: '마', difficulty: 3),

    // ㅂ (9개)
    HangulWord(word: '배', emoji: '🍐', consonant: 'ㅂ', syllable: '배', difficulty: 1),
    HangulWord(word: '별', emoji: '⭐', consonant: 'ㅂ', syllable: '별', difficulty: 1),
    HangulWord(word: '뱀', emoji: '🐍', consonant: 'ㅂ', syllable: '뱀', difficulty: 1),
    HangulWord(word: '바나나', emoji: '🍌', consonant: 'ㅂ', syllable: '바', difficulty: 2),
    HangulWord(word: '버스', emoji: '🚌', consonant: 'ㅂ', syllable: '버', difficulty: 2),
    HangulWord(word: '비행기', emoji: '✈️', consonant: 'ㅂ', syllable: '비', difficulty: 2),
    HangulWord(word: '복숭아', emoji: '🍑', consonant: 'ㅂ', syllable: '복', difficulty: 2),
    HangulWord(word: '번개', emoji: '⚡', consonant: 'ㅂ', syllable: '번', difficulty: 2),
    HangulWord(word: '병아리', emoji: '🐤', consonant: 'ㅂ', syllable: '병', difficulty: 3),

    // ㅅ (10개)
    HangulWord(word: '사과', emoji: '🍎', consonant: 'ㅅ', syllable: '사', difficulty: 1),
    HangulWord(word: '새', emoji: '🐦', consonant: 'ㅅ', syllable: '새', difficulty: 1),
    HangulWord(word: '소', emoji: '🐄', consonant: 'ㅅ', syllable: '소', difficulty: 1),
    HangulWord(word: '수박', emoji: '🍉', consonant: 'ㅅ', syllable: '수', difficulty: 1),
    HangulWord(word: '사탕', emoji: '🍬', consonant: 'ㅅ', syllable: '사', difficulty: 1),
    HangulWord(word: '사자', emoji: '🦁', consonant: 'ㅅ', syllable: '사', difficulty: 1),
    HangulWord(word: '선물', emoji: '🎁', consonant: 'ㅅ', syllable: '선', difficulty: 2),
    HangulWord(word: '상어', emoji: '🦈', consonant: 'ㅅ', syllable: '상', difficulty: 2),
    HangulWord(word: '신발', emoji: '👟', consonant: 'ㅅ', syllable: '신', difficulty: 2),
    HangulWord(word: '시계', emoji: '⌚', consonant: 'ㅅ', syllable: '시', difficulty: 2),

    // ㅇ (9개)
    HangulWord(word: '오리', emoji: '🦆', consonant: 'ㅇ', syllable: '오', difficulty: 1),
    HangulWord(word: '우유', emoji: '🥛', consonant: 'ㅇ', syllable: '우', difficulty: 1),
    HangulWord(word: '우산', emoji: '☂️', consonant: 'ㅇ', syllable: '우', difficulty: 1),
    HangulWord(word: '양', emoji: '🐑', consonant: 'ㅇ', syllable: '양', difficulty: 1),
    HangulWord(word: '연필', emoji: '✏️', consonant: 'ㅇ', syllable: '연', difficulty: 2),
    HangulWord(word: '왕관', emoji: '👑', consonant: 'ㅇ', syllable: '왕', difficulty: 2),
    HangulWord(word: '안경', emoji: '👓', consonant: 'ㅇ', syllable: '안', difficulty: 2),
    HangulWord(word: '열쇠', emoji: '🔑', consonant: 'ㅇ', syllable: '열', difficulty: 3),
    HangulWord(word: '아이스크림', emoji: '🍦', consonant: 'ㅇ', syllable: '아', difficulty: 3),

    // ㅈ (8개)
    HangulWord(word: '종', emoji: '🔔', consonant: 'ㅈ', syllable: '종', difficulty: 1),
    HangulWord(word: '자동차', emoji: '🚗', consonant: 'ㅈ', syllable: '자', difficulty: 2),
    HangulWord(word: '지구', emoji: '🌍', consonant: 'ㅈ', syllable: '지', difficulty: 2),
    HangulWord(word: '주스', emoji: '🧃', consonant: 'ㅈ', syllable: '주', difficulty: 2),
    HangulWord(word: '젖소', emoji: '🐮', consonant: 'ㅈ', syllable: '젖', difficulty: 2),
    HangulWord(word: '장갑', emoji: '🧤', consonant: 'ㅈ', syllable: '장', difficulty: 2),
    HangulWord(word: '전화기', emoji: '📞', consonant: 'ㅈ', syllable: '전', difficulty: 2),
    HangulWord(word: '접시', emoji: '🍽️', consonant: 'ㅈ', syllable: '접', difficulty: 2),

    // ㅊ (7개)
    HangulWord(word: '책', emoji: '📖', consonant: 'ㅊ', syllable: '책', difficulty: 1),
    HangulWord(word: '치즈', emoji: '🧀', consonant: 'ㅊ', syllable: '치', difficulty: 2),
    HangulWord(word: '체리', emoji: '🍒', consonant: 'ㅊ', syllable: '체', difficulty: 2),
    HangulWord(word: '촛불', emoji: '🕯️', consonant: 'ㅊ', syllable: '촛', difficulty: 2),
    HangulWord(word: '칫솔', emoji: '🪥', consonant: 'ㅊ', syllable: '칫', difficulty: 2),
    HangulWord(word: '초콜릿', emoji: '🍫', consonant: 'ㅊ', syllable: '초', difficulty: 3),
    HangulWord(word: '치마', emoji: '👗', consonant: 'ㅊ', syllable: '치', difficulty: 2),

    // ㅋ (7개)
    HangulWord(word: '코', emoji: '👃', consonant: 'ㅋ', syllable: '코', difficulty: 1),
    HangulWord(word: '컵', emoji: '☕', consonant: 'ㅋ', syllable: '컵', difficulty: 1),
    HangulWord(word: '케이크', emoji: '🎂', consonant: 'ㅋ', syllable: '케', difficulty: 2),
    HangulWord(word: '코끼리', emoji: '🐘', consonant: 'ㅋ', syllable: '코', difficulty: 2),
    HangulWord(word: '카메라', emoji: '📷', consonant: 'ㅋ', syllable: '카', difficulty: 2),
    HangulWord(word: '크레용', emoji: '🖍️', consonant: 'ㅋ', syllable: '크', difficulty: 2),
    HangulWord(word: '캥거루', emoji: '🦘', consonant: 'ㅋ', syllable: '캥', difficulty: 2),

    // ㅌ (7개)
    HangulWord(word: '토끼', emoji: '🐰', consonant: 'ㅌ', syllable: '토', difficulty: 1),
    HangulWord(word: '토마토', emoji: '🍅', consonant: 'ㅌ', syllable: '토', difficulty: 1),
    HangulWord(word: '태양', emoji: '☀️', consonant: 'ㅌ', syllable: '태', difficulty: 2),
    HangulWord(word: '트럭', emoji: '🚚', consonant: 'ㅌ', syllable: '트', difficulty: 2),
    HangulWord(word: '텐트', emoji: '⛺', consonant: 'ㅌ', syllable: '텐', difficulty: 2),
    HangulWord(word: '타조', emoji: '🦤', consonant: 'ㅌ', syllable: '타', difficulty: 2),
    HangulWord(word: '튤립', emoji: '🌷', consonant: 'ㅌ', syllable: '튤', difficulty: 3),

    // ㅍ (7개)
    HangulWord(word: '포도', emoji: '🍇', consonant: 'ㅍ', syllable: '포', difficulty: 1),
    HangulWord(word: '피자', emoji: '🍕', consonant: 'ㅍ', syllable: '피', difficulty: 1),
    HangulWord(word: '펭귄', emoji: '🐧', consonant: 'ㅍ', syllable: '펭', difficulty: 2),
    HangulWord(word: '풍선', emoji: '🎈', consonant: 'ㅍ', syllable: '풍', difficulty: 2),
    HangulWord(word: '팝콘', emoji: '🍿', consonant: 'ㅍ', syllable: '팝', difficulty: 2),
    HangulWord(word: '팬더', emoji: '🐼', consonant: 'ㅍ', syllable: '팬', difficulty: 2),
    HangulWord(word: '파인애플', emoji: '🍍', consonant: 'ㅍ', syllable: '파', difficulty: 3),

    // ㅎ (8개)
    HangulWord(word: '하마', emoji: '🦛', consonant: 'ㅎ', syllable: '하', difficulty: 1),
    HangulWord(word: '하트', emoji: '❤️', consonant: 'ㅎ', syllable: '하', difficulty: 1),
    HangulWord(word: '호랑이', emoji: '🐯', consonant: 'ㅎ', syllable: '호', difficulty: 2),
    HangulWord(word: '햄버거', emoji: '🍔', consonant: 'ㅎ', syllable: '햄', difficulty: 2),
    HangulWord(word: '헬리콥터', emoji: '🚁', consonant: 'ㅎ', syllable: '헬', difficulty: 2),
    HangulWord(word: '핫도그', emoji: '🌭', consonant: 'ㅎ', syllable: '핫', difficulty: 2),
    HangulWord(word: '호박', emoji: '🎃', consonant: 'ㅎ', syllable: '호', difficulty: 2),
    HangulWord(word: '해바라기', emoji: '🌻', consonant: 'ㅎ', syllable: '해', difficulty: 3),
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
