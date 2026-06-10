import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme.dart';
import '../models/hangul_problem.dart';
import '../services/problem_generator.dart';
import '../services/storage_service.dart';
import '../services/tts_service.dart';
import '../widgets/xp_bar.dart';
import 'game_screen.dart';

class HomeScreen extends StatefulWidget {
  final StorageService storage;

  const HomeScreen({super.key, required this.storage});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GameMode? _selectedMode;
  bool _showAchievements = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                XpBar(
                  currentXp: widget.storage.totalXp,
                  level: widget.storage.level,
                ),
                const SizedBox(height: 8),
                _buildStreakBadge(),
                const SizedBox(height: 20),
                if (_selectedMode == null) ...[
                  _buildWelcome(),
                  const SizedBox(height: 20),
                  _buildModeGrid(),
                  const SizedBox(height: 20),
                  _buildAchievementsSection(),
                  const SizedBox(height: 24),
                  _buildCredits(),
                ] else ...[
                  _buildDifficultySelection(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final soundOn = widget.storage.soundEnabled;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (_selectedMode != null)
          IconButton(
            onPressed: () => setState(() => _selectedMode = null),
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppColors.sky,
          )
        else
          const SizedBox(width: 48),
        Text(
          '한결이의 한글 놀이터',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.sky.withValues(alpha: 0.8),
          ),
        ),
        IconButton(
          onPressed: () {
            final next = !soundOn;
            widget.storage.setSoundEnabled(next);
            TtsService.instance.muted = !next;
            if (!next) TtsService.instance.stop();
            setState(() {});
          },
          icon: Icon(
            soundOn ? Icons.volume_up_rounded : Icons.volume_off_rounded,
            color: AppColors.sky,
          ),
        ),
      ],
    );
  }

  Widget _buildStreakBadge() {
    final streak = widget.storage.streak;
    if (streak <= 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.orange, AppColors.yellow],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '🔥 $streak일 연속 플레이 중!',
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    ).animate().fadeIn().slideY(begin: -0.3);
  }

  Widget _buildWelcome() {
    return Column(
      children: [
        const Text('📚', style: TextStyle(fontSize: 64))
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .moveY(begin: 0, end: -10, duration: 1500.ms, curve: Curves.easeInOut),
        const SizedBox(height: 8),
        const Text(
          '안녕, 한결이!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF333333),
          ),
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 4),
        Text(
          '오늘은 어떤 한글이랑 놀까? 🎈',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ).animate().fadeIn(delay: 400.ms),
      ],
    );
  }

  Widget _buildModeGrid() {
    // 음운 인식 발달 순서(음절 → 음소 → 조합 → 받침 → 단어)대로 배치
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: [
        _ModeCard(
          mode: GameMode.syllable,
          step: 1,
          bgGradient: const LinearGradient(
            colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
          ),
          borderColor: AppColors.green,
          onTap: () => setState(() => _selectedMode = GameMode.syllable),
        ),
        _ModeCard(
          mode: GameMode.vowel,
          step: 2,
          bgGradient: const LinearGradient(
            colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
          ),
          borderColor: AppColors.orange,
          onTap: () => setState(() => _selectedMode = GameMode.vowel),
        ),
        _ModeCard(
          mode: GameMode.consonant,
          step: 3,
          bgGradient: const LinearGradient(
            colors: [Color(0xFFE1F5FE), Color(0xFFB3E5FC)],
          ),
          borderColor: AppColors.sky,
          onTap: () => setState(() => _selectedMode = GameMode.consonant),
        ),
        _ModeCard(
          mode: GameMode.combine,
          step: 4,
          bgGradient: const LinearGradient(
            colors: [Color(0xFFFCE4EC), Color(0xFFF8BBD0)],
          ),
          borderColor: AppColors.coral,
          onTap: () => setState(() => _selectedMode = GameMode.combine),
        ),
        _ModeCard(
          mode: GameMode.batchim,
          step: 5,
          bgGradient: const LinearGradient(
            colors: [Color(0xFFF3E5F5), Color(0xFFE1BEE7)],
          ),
          borderColor: AppColors.purple,
          onTap: () => setState(() => _selectedMode = GameMode.batchim),
        ),
        _ModeCard(
          mode: GameMode.word,
          step: 6,
          bgGradient: const LinearGradient(
            colors: [Color(0xFFE0F2F1), Color(0xFFB2DFDB)],
          ),
          borderColor: const Color(0xFF4DB6AC),
          onTap: () => setState(() => _selectedMode = GameMode.word),
        ),
        _ModeCard(
          mode: GameMode.challenge,
          bgGradient: const LinearGradient(
            colors: [Color(0xFFFFF8E1), Color(0xFFFFECB3)],
          ),
          borderColor: AppColors.yellow,
          onTap: () => setState(() => _selectedMode = GameMode.challenge),
        ),
      ],
    );
  }

  Widget _buildDifficultySelection() {
    final generator = ProblemGenerator();
    final levels = generator.levelsForMode(_selectedMode!);
    final recommended = widget.storage.recommendedLevel(
      _selectedMode!.name,
      levels.length,
    );

    return Column(
      children: [
        Text(
          '${_selectedMode!.emoji2} ${_selectedMode!.label}',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '난이도를 골라봐! 🎯',
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 16),
        ...levels.asMap().entries.map((entry) {
          final idx = entry.key;
          final dl = entry.value;
          return _DifficultyCard(
            difficulty: dl,
            delay: idx * 100,
            recommended: dl.level == recommended,
            onTap: () => _startGame(dl.level),
          );
        }),
      ],
    ).animate().fadeIn();
  }

  Widget _buildAchievementsSection() {
    final achievements = widget.storage.unlockedAchievements;
    if (achievements.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _showAchievements = !_showAchievements),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🏆 업적',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF555555),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.yellow.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${achievements.length}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.orange,
                  ),
                ),
              ),
              Icon(
                _showAchievements
                    ? Icons.expand_less
                    : Icons.expand_more,
                color: Colors.grey,
              ),
            ],
          ),
        ),
        if (_showAchievements) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: achievements
                .map((a) => Chip(
                      avatar: Text(a.emoji, style: const TextStyle(fontSize: 16)),
                      label: Text(a.title,
                          style: const TextStyle(fontSize: 12)),
                      backgroundColor: AppColors.lightYellow,
                    ))
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildCredits() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  'Made with \u2764\ufe0f for 한결이',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.sky.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 8),
                _creditRow('기획', '아빠'),
                _creditRow('개발', '아빠'),
                _creditRow('디자인', '아빠'),
                _creditRow('테스트', '한결이'),
                _creditRow('응원', '엄마'),
                _creditRow('귀여움', '다솜이'),
                const SizedBox(height: 6),
                Text(
                  'v1.4.0',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _creditRow(String role, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 50,
            child: Text(
              role,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              ':',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            ),
          ),
          Text(
            name,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF555555),
            ),
          ),
        ],
      ),
    );
  }

  void _startGame(int difficultyLevel) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GameScreen(
          mode: _selectedMode!,
          difficultyLevel: difficultyLevel,
          storage: widget.storage,
        ),
      ),
    ).then((_) => setState(() => _selectedMode = null));
  }
}

class _ModeCard extends StatelessWidget {
  final GameMode mode;
  final int? step;
  final LinearGradient bgGradient;
  final Color borderColor;
  final VoidCallback onTap;

  const _ModeCard({
    required this.mode,
    this.step,
    required this.bgGradient,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: bgGradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: borderColor.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (step != null)
              Positioned(
                top: 8,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$step단계',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF777777),
                    ),
                  ),
                ),
              ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(mode.emoji2, style: const TextStyle(fontSize: 32)),
                  const SizedBox(height: 6),
                  Text(
                    mode.label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF555555),
                    ),
                  ),
                  Text(
                    mode.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().scale(
          begin: const Offset(0.9, 0.9),
          curve: Curves.easeOutBack,
          duration: 300.ms,
        );
  }
}

class _DifficultyCard extends StatelessWidget {
  final DifficultyLevel difficulty;
  final int delay;
  final bool recommended;
  final VoidCallback onTap;

  const _DifficultyCard({
    required this.difficulty,
    required this.delay,
    this.recommended = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: recommended
              ? Border.all(color: AppColors.yellow, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(difficulty.emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          difficulty.name,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                      if (recommended) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.yellow.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            '추천 ⭐',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.orange,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    difficulty.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.sky),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn(duration: 200.ms)
        .slideX(begin: 0.2, curve: Curves.easeOutBack);
  }
}
