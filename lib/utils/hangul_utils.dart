/// 한글 자모 분해·조합, 조사 처리, 음가/이름 정보를 담당하는 유틸리티.
class HangulJamo {
  static const List<String> choseong = [
    'ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ', 'ㅅ',
    'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ',
  ];

  static const List<String> jungseong = [
    'ㅏ', 'ㅐ', 'ㅑ', 'ㅒ', 'ㅓ', 'ㅔ', 'ㅕ', 'ㅖ', 'ㅗ', 'ㅘ',
    'ㅙ', 'ㅚ', 'ㅛ', 'ㅜ', 'ㅝ', 'ㅞ', 'ㅟ', 'ㅠ', 'ㅡ', 'ㅢ',
    'ㅣ',
  ];

  static const List<String> jongseong = [
    '', 'ㄱ', 'ㄲ', 'ㄳ', 'ㄴ', 'ㄵ', 'ㄶ', 'ㄷ', 'ㄹ', 'ㄺ',
    'ㄻ', 'ㄼ', 'ㄽ', 'ㄾ', 'ㄿ', 'ㅀ', 'ㅁ', 'ㅂ', 'ㅄ', 'ㅅ',
    'ㅆ', 'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ',
  ];

  /// 자음 음가 (첫소리 강조 발음용)
  static const Map<String, String> consonantSounds = {
    'ㄱ': '그', 'ㄲ': '끄', 'ㄴ': '느', 'ㄷ': '드', 'ㄸ': '뜨',
    'ㄹ': '르', 'ㅁ': '므', 'ㅂ': '브', 'ㅃ': '쁘', 'ㅅ': '스',
    'ㅆ': '쓰', 'ㅇ': '으', 'ㅈ': '즈', 'ㅉ': '쯔', 'ㅊ': '츠',
    'ㅋ': '크', 'ㅌ': '트', 'ㅍ': '프', 'ㅎ': '흐',
  };

  /// 자음 이름
  static const Map<String, String> consonantNames = {
    'ㄱ': '기역', 'ㄲ': '쌍기역', 'ㄴ': '니은', 'ㄷ': '디귿', 'ㄸ': '쌍디귿',
    'ㄹ': '리을', 'ㅁ': '미음', 'ㅂ': '비읍', 'ㅃ': '쌍비읍', 'ㅅ': '시옷',
    'ㅆ': '쌍시옷', 'ㅇ': '이응', 'ㅈ': '지읒', 'ㅉ': '쌍지읒', 'ㅊ': '치읓',
    'ㅋ': '키읔', 'ㅌ': '티읕', 'ㅍ': '피읖', 'ㅎ': '히읗',
  };

  /// 모음 음가
  static const Map<String, String> vowelSounds = {
    'ㅏ': '아', 'ㅐ': '애', 'ㅑ': '야', 'ㅒ': '얘', 'ㅓ': '어',
    'ㅔ': '에', 'ㅕ': '여', 'ㅖ': '예', 'ㅗ': '오', 'ㅘ': '와',
    'ㅙ': '왜', 'ㅚ': '외', 'ㅛ': '요', 'ㅜ': '우', 'ㅝ': '워',
    'ㅞ': '웨', 'ㅟ': '위', 'ㅠ': '유', 'ㅡ': '으', 'ㅢ': '의',
    'ㅣ': '이',
  };

  static bool isSyllable(String ch) {
    if (ch.isEmpty) return false;
    final code = ch.codeUnitAt(0);
    return code >= 0xAC00 && code <= 0xD7A3;
  }

  /// 첫 글자의 초성 (한글 음절이 아니면 빈 문자열)
  static String initialOf(String syllable) {
    if (!isSyllable(syllable)) return '';
    return choseong[(syllable.codeUnitAt(0) - 0xAC00) ~/ (21 * 28)];
  }

  /// 첫 글자의 중성(모음)
  static String vowelOf(String syllable) {
    if (!isSyllable(syllable)) return '';
    return jungseong[((syllable.codeUnitAt(0) - 0xAC00) % (21 * 28)) ~/ 28];
  }

  /// 첫 글자의 종성(받침). 없으면 빈 문자열
  static String batchimOf(String syllable) {
    if (!isSyllable(syllable)) return '';
    return jongseong[(syllable.codeUnitAt(0) - 0xAC00) % 28];
  }

  /// 초성+중성(+종성)을 한 글자로 조합. 조합 불가능하면 빈 문자열
  static String compose(String cho, String jung, [String jong = '']) {
    final c = choseong.indexOf(cho);
    final v = jungseong.indexOf(jung);
    final j = jong.isEmpty ? 0 : jongseong.indexOf(jong);
    if (c < 0 || v < 0 || j < 0) return '';
    return String.fromCharCode(0xAC00 + (c * 21 + v) * 28 + j);
  }

  /// 마지막 글자에 받침이 있으면 true
  static bool hasBatchim(String text) {
    if (text.isEmpty) return false;
    final last = text.runes.last;
    if (last < 0xAC00 || last > 0xD7A3) return false;
    return (last - 0xAC00) % 28 != 0;
  }

  /// 받침 유무에 따라 은/는 반환
  static String eunNeun(String text) => hasBatchim(text) ? '은' : '는';

  /// 받침 유무에 따라 이에요/예요 반환
  static String iEyo(String text) => hasBatchim(text) ? '이에요' : '예요';

  /// 자모의 음가 (예: ㄱ→그, ㅏ→아)
  static String soundOf(String jamo) =>
      consonantSounds[jamo] ?? vowelSounds[jamo] ?? jamo;

  /// 자모의 이름 (예: ㄱ→기역, ㅏ→아)
  static String nameOf(String jamo) =>
      consonantNames[jamo] ?? vowelSounds[jamo] ?? jamo;
}

/// 모양·소리가 비슷해서 헷갈리기 쉬운 자모 그룹.
/// 높은 난이도에서 이런 글자를 보기로 같이 내면 변별 연습이 된다.
class HangulSimilarity {
  static const Map<String, List<String>> _consonants = {
    'ㄱ': ['ㅋ', 'ㄴ'],
    'ㄴ': ['ㄱ', 'ㄷ', 'ㄹ'],
    'ㄷ': ['ㅌ', 'ㄴ', 'ㄹ'],
    'ㄹ': ['ㄷ', 'ㄴ', 'ㅌ'],
    'ㅁ': ['ㅂ', 'ㅍ', 'ㅇ'],
    'ㅂ': ['ㅁ', 'ㅍ'],
    'ㅅ': ['ㅈ', 'ㅊ'],
    'ㅇ': ['ㅁ', 'ㅎ'],
    'ㅈ': ['ㅅ', 'ㅊ'],
    'ㅊ': ['ㅈ', 'ㅅ', 'ㅎ'],
    'ㅋ': ['ㄱ', 'ㅌ', 'ㅍ'],
    'ㅌ': ['ㄷ', 'ㅋ', 'ㅍ'],
    'ㅍ': ['ㅂ', 'ㅁ', 'ㅌ'],
    'ㅎ': ['ㅇ', 'ㅊ'],
  };

  static const Map<String, List<String>> _vowels = {
    'ㅏ': ['ㅓ', 'ㅑ', 'ㅣ'],
    'ㅓ': ['ㅏ', 'ㅕ'],
    'ㅗ': ['ㅜ', 'ㅛ'],
    'ㅜ': ['ㅗ', 'ㅠ', 'ㅡ'],
    'ㅡ': ['ㅣ', 'ㅜ'],
    'ㅣ': ['ㅏ', 'ㅡ'],
    'ㅐ': ['ㅔ', 'ㅏ'],
    'ㅔ': ['ㅐ', 'ㅓ'],
    'ㅑ': ['ㅏ', 'ㅕ'],
    'ㅕ': ['ㅓ', 'ㅑ', 'ㅛ'],
    'ㅛ': ['ㅗ', 'ㅠ', 'ㅕ'],
    'ㅠ': ['ㅜ', 'ㅛ'],
    'ㅘ': ['ㅏ', 'ㅗ', 'ㅙ'],
    'ㅙ': ['ㅘ', 'ㅐ', 'ㅔ'],
  };

  static List<String> consonants(String c) => _consonants[c] ?? const [];

  static List<String> vowels(String v) => _vowels[v] ?? const [];
}
