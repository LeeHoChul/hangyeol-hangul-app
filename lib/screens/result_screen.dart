import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme.dart';
import '../models/hangul_problem.dart';
import '../services/storage_service.dart';
import '../widgets/celebration.dart';
import 'game_screen.dart';

class ResultScreen extends StatefulWidget {
  final GameResult result;
  final StorageService storage;

  const ResultScreen({
    super.key,
    required this.result,
    required this.storage,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _showCelebration = false;
  bool _didLevelUp = false;

  @override
  void initState() {
    super.initState();
    _saveResults();
  }

  Future<void> _saveResults() async {
    final r = widget.result;

    await widget.storage.recordGame(
      correctCount: r.score,
      maxGameStreak: r.maxStreak,
      isPerfect: r.accuracy >= 1.0,
    );

    final leveledUp = await widget.storage.addXp(r.xpEarned);

    if (mounted) {
      setState(() {
        _didLevelUp = leveledUp;
        if (r.accuracy >= 0.8 || leveledUp) {
          _showCelebration = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goHome();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration:
                  const BoxDecoration(gradient: AppColors.backgroundGradient),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildResultCard(),
                      const SizedBox(height: 16),
                      _buildStatsCard(),
                      if (widget.result.wrongIndices.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildReviewCard(),
                      ],
                      const SizedBox(height: 24),
                      _buildButtons(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            if (_showCelebration)
              CelebrationOverlay(
                isPerfect: widget.result.accuracy >= 1.0,
                isLevelUp: _didLevelUp,
                newLevel: widget.storage.level,
                xpGained: widget.result.xpEarned,
                stars: widget.result.stars,
                onDismiss: () => setState(() => _showCelebration = false),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    final r = widget.result;
    String emoji;
    String title;
    String message;

    if (r.accuracy >= 1.0) {
      emoji = '🏆';
      title = '완벽해, 한결이!';
      message = '만점이야! 정말 대단한 한글 박사!';
    } else if (r.accuracy >= 0.8) {
      emoji = '🎉';
      title = '잘했어, 한결이!';
      message = '거의 다 맞았어! 최고야~';
    } else if (r.accuracy >= 0.6) {
      emoji = '😊';
      title = '좋았어!';
      message = '조금만 더 연습하면 완벽할 거야!';
    } else if (r.accuracy >= 0.4) {
      emoji = '💪';
      title = '힘내!';
      message = '연습하면 분명 더 잘할 수 있어!';
    } else {
      emoji = '🤗';
      title = '괜찮아!';
      message = '천천히 다시 해보자! 화이팅!';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.sky.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 64))
              .animate()
              .scale(
                  duration: 600.ms,
                  curve: Curves.elasticOut,
                  begin: const Offset(0, 0)),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppColors.sky,
            ),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 4),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
          ).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 16),
          Text(
            '${r.score}/${r.total}',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w700,
              color: Color(0xFF333333),
            ),
          ).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  i < r.stars ? '⭐' : '☆',
                  style: const TextStyle(fontSize: 36),
                )
                    .animate(delay: Duration(milliseconds: 500 + i * 150))
                    .scale(
                      duration: 400.ms,
                      curve: Curves.elasticOut,
                      begin: const Offset(0, 0),
                    ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.yellow.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '+${r.xpEarned} XP',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.orange,
              ),
            ),
          ).animate(delay: 700.ms).fadeIn().scale(
              begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Widget _buildStatsCard() {
    final r = widget.result;
    final elapsed = r.elapsed;
    final minutes = elapsed.inMinutes;
    final seconds = elapsed.inSeconds % 60;
    final timeStr = minutes > 0 ? '$minutes분 $seconds초' : '$seconds초';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _StatRow(icon: '⏱', label: '걸린 시간', value: timeStr),
          const Divider(height: 16),
          _StatRow(
              icon: '🔥',
              label: '최대 연속 정답',
              value: '${r.maxStreak}문제'),
          const Divider(height: 16),
          _StatRow(
              icon: '📊',
              label: '정답률',
              value: '${(r.accuracy * 100).round()}%'),
        ],
      ),
    ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1);
  }

  Widget _buildReviewCard() {
    final r = widget.result;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📝 틀린 문제 다시 보기',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.coral,
            ),
          ),
          const SizedBox(height: 10),
          ...r.wrongIndices.map((i) {
            final p = r.problems[i];
            final ua = r.userAnswers[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF5F5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFFD4D4)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      p.mode == GameMode.consonant
                          ? '${p.correctEmoji} ${p.correctWord}'
                          : p.question,
                      style: const TextStyle(
                          fontSize: 18, color: Color(0xFF555555)),
                    ),
                  ),
                  if (ua != null) ...[
                    Text(
                      ua.emoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const Text(' → ', style: TextStyle(fontSize: 16)),
                  ],
                  Text(
                    p.mode == GameMode.consonant
                        ? p.choices.firstWhere((c) => c.isCorrect).emoji
                        : '${p.correctEmoji} ${p.correctWord}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.green,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.1);
  }

  Widget _buildButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => GameScreen(
                    mode: widget.result.mode,
                    difficultyLevel: widget.result.difficultyLevel,
                    storage: widget.storage,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.sky,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('다시 도전! 💪',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _goHome,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.green,
              side: const BorderSide(color: AppColors.green, width: 2),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            child: const Text('처음으로 🏠',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    ).animate(delay: 600.ms).fadeIn();
  }

  void _goHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}

class _StatRow extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$icon $label',
          style: const TextStyle(fontSize: 15, color: Color(0xFF555555)),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
      ],
    );
  }
}
