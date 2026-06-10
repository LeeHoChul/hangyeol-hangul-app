import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// 라이트너 박스 방식의 항목별 숙련도 추적 (간격 반복 학습).
///
/// 항목 키 규칙:
///   'c:ㄱ'  자음, 'v:ㅏ' 모음, 's:가' 첫 글자, 'b:ㅁ' 받침,
///   'j:가'  글자 조합, 'w:사과' 단어
///
/// 박스 1(틀려서 자주 나옴) ~ 5(익혀서 드물게 나옴).
/// 정답이면 한 칸 올라가고, 오답이면 박스 1로 내려간다.
class MasteryService {
  static const _storageKey = 'mastery_v1';

  MasteryService(this._prefs) {
    _load();
  }

  final SharedPreferences _prefs;
  final Map<String, ItemMastery> _items = {};

  void _load() {
    final raw = _prefs.getString(_storageKey);
    if (raw == null) return;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      decoded.forEach((key, value) {
        final list = (value as List).cast<int>();
        _items[key] = ItemMastery(box: list[0], correct: list[1], wrong: list[2]);
      });
    } catch (_) {
      // 손상된 데이터는 버리고 새로 시작
      _items.clear();
    }
  }

  Future<void> _save() async {
    final encoded = jsonEncode(
      _items.map((k, v) => MapEntry(k, [v.box, v.correct, v.wrong])),
    );
    await _prefs.setString(_storageKey, encoded);
  }

  ItemMastery? statsFor(String key) => _items[key];

  /// 출제 가중치: 최근에 틀린 항목일수록 자주, 익힌 항목일수록 드물게 나온다.
  /// 아직 안 풀어본 항목은 중간보다 높은 가중치로 골고루 노출.
  double weightFor(String key) {
    final item = _items[key];
    if (item == null) return 3.0;
    switch (item.box) {
      case 1:
        return 6.0;
      case 2:
        return 3.0;
      case 3:
        return 1.5;
      case 4:
        return 0.8;
      default:
        return 0.4;
    }
  }

  Future<void> record(String key, bool correct) async {
    final item = _items[key] ?? const ItemMastery();
    _items[key] = correct
        ? ItemMastery(
            box: (item.box + 1).clamp(1, 5),
            correct: item.correct + 1,
            wrong: item.wrong,
          )
        : ItemMastery(box: 1, correct: item.correct, wrong: item.wrong + 1);
    await _save();
  }
}

class ItemMastery {
  final int box;
  final int correct;
  final int wrong;

  const ItemMastery({this.box = 2, this.correct = 0, this.wrong = 0});
}
