import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _keyTotalXp = 'total_xp';
  static const _keyLevel = 'user_level';
  static const _keyStreak = 'streak_count';
  static const _keyLastPlay = 'last_play_date';
  static const _keyTotalGames = 'total_games';
  static const _keyTotalCorrect = 'total_correct';
  static const _keyBestStreak = 'best_streak';
  static const _keyPerfectGames = 'perfect_games';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  int get totalXp => _prefs.getInt(_keyTotalXp) ?? 0;
  int get level => _prefs.getInt(_keyLevel) ?? 1;
  int get streak => _prefs.getInt(_keyStreak) ?? 0;
  int get totalGames => _prefs.getInt(_keyTotalGames) ?? 0;
  int get totalCorrect => _prefs.getInt(_keyTotalCorrect) ?? 0;
  int get bestStreak => _prefs.getInt(_keyBestStreak) ?? 0;
  int get perfectGames => _prefs.getInt(_keyPerfectGames) ?? 0;

  String? get lastPlayDate => _prefs.getString(_keyLastPlay);

  Future<bool> addXp(int amount) async {
    final newXp = totalXp + amount;
    await _prefs.setInt(_keyTotalXp, newXp);

    final thresholds = [0, 15, 40, 80, 140, 220, 350];
    var newLevel = 1;
    for (var i = 1; i < thresholds.length; i++) {
      if (newXp >= thresholds[i]) {
        newLevel = i + 1;
      }
    }

    final didLevelUp = newLevel > level;
    await _prefs.setInt(_keyLevel, newLevel);
    return didLevelUp;
  }

  Future<void> recordGame({
    required int correctCount,
    required int maxGameStreak,
    required bool isPerfect,
  }) async {
    await _prefs.setInt(_keyTotalGames, totalGames + 1);
    await _prefs.setInt(_keyTotalCorrect, totalCorrect + correctCount);

    if (maxGameStreak > bestStreak) {
      await _prefs.setInt(_keyBestStreak, maxGameStreak);
    }

    if (isPerfect) {
      await _prefs.setInt(_keyPerfectGames, perfectGames + 1);
    }

    await _updateStreak();
  }

  Future<void> _updateStreak() async {
    final today = _dateString(DateTime.now());
    final lastPlay = lastPlayDate;

    if (lastPlay == null) {
      await _prefs.setInt(_keyStreak, 1);
    } else if (lastPlay == today) {
      // noop
    } else {
      final yesterday = _dateString(
        DateTime.now().subtract(const Duration(days: 1)),
      );
      if (lastPlay == yesterday) {
        await _prefs.setInt(_keyStreak, streak + 1);
      } else {
        await _prefs.setInt(_keyStreak, 1);
      }
    }

    await _prefs.setString(_keyLastPlay, today);
  }

  String _dateString(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

  List<Achievement> get unlockedAchievements {
    final achievements = <Achievement>[];

    if (totalGames >= 1) {
      achievements.add(Achievement('첫 도전!', '🎯', '첫 게임 완료'));
    }
    if (totalGames >= 10) {
      achievements.add(Achievement('열심히!', '💪', '10번 도전'));
    }
    if (totalGames >= 50) {
      achievements.add(Achievement('한글 중독', '🤓', '50번 도전'));
    }
    if (perfectGames >= 1) {
      achievements.add(Achievement('완벽해!', '💯', '만점 1회'));
    }
    if (perfectGames >= 5) {
      achievements.add(Achievement('만점 왕', '👑', '만점 5회'));
    }
    if (bestStreak >= 10) {
      achievements.add(Achievement('연속 달인', '🔥', '10연속 정답'));
    }
    if (bestStreak >= 20) {
      achievements.add(Achievement('멈출 수 없어', '⚡', '20연속 정답'));
    }
    if (streak >= 3) {
      achievements.add(Achievement('3일 연속!', '📅', '3일 연속 플레이'));
    }
    if (streak >= 7) {
      achievements.add(Achievement('일주일!', '🗓️', '7일 연속 플레이'));
    }
    if (level >= 3) {
      achievements.add(Achievement('한글 탐험가', '🔭', '레벨 3 달성'));
    }
    if (level >= 5) {
      achievements.add(Achievement('한글 마법사', '🧙', '레벨 5 달성'));
    }
    if (level >= 7) {
      achievements.add(Achievement('한글 박사', '🎓', '최고 레벨 달성'));
    }

    return achievements;
  }
}

class Achievement {
  final String title;
  final String emoji;
  final String description;

  const Achievement(this.title, this.emoji, this.description);
}
