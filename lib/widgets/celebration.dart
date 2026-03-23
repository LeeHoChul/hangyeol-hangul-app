import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme.dart';

class CelebrationOverlay extends StatefulWidget {
  final bool isPerfect;
  final bool isLevelUp;
  final int newLevel;
  final int xpGained;
  final int stars;
  final VoidCallback onDismiss;

  const CelebrationOverlay({
    super.key,
    required this.isPerfect,
    this.isLevelUp = false,
    this.newLevel = 1,
    required this.xpGained,
    required this.stars,
    required this.onDismiss,
  });

  @override
  State<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<CelebrationOverlay> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    if (widget.isPerfect || widget.isLevelUp) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 40,
              gravity: 0.15,
              emissionFrequency: 0.06,
              colors: const [
                AppColors.sky,
                AppColors.green,
                AppColors.yellow,
                AppColors.purple,
                AppColors.orange,
                AppColors.coral,
              ],
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.all(32),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.sky.withValues(alpha: 0.2),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.isLevelUp) ...[
                    Text(
                      LevelInfo.emojiFor(widget.newLevel),
                      style: const TextStyle(fontSize: 64),
                    )
                        .animate()
                        .scale(
                          duration: 600.ms,
                          curve: Curves.elasticOut,
                          begin: const Offset(0, 0),
                        )
                        .shimmer(delay: 600.ms, duration: 800.ms),
                    const SizedBox(height: 12),
                    const Text(
                      '레벨 업!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.sky,
                      ),
                    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3),
                    const SizedBox(height: 4),
                    Text(
                      LevelInfo.titleFor(widget.newLevel),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: AppColors.purple,
                      ),
                    ).animate().fadeIn(delay: 500.ms),
                  ] else ...[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        3,
                        (i) => Text(
                          i < widget.stars ? '⭐' : '☆',
                          style: const TextStyle(fontSize: 48),
                        )
                            .animate(delay: Duration(milliseconds: 200 * i))
                            .scale(
                              duration: 400.ms,
                              curve: Curves.elasticOut,
                              begin: const Offset(0, 0),
                            ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.isPerfect ? '완벽해요!' : '잘했어요!',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.sky,
                      ),
                    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),
                  ],
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.yellow.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '+${widget.xpGained} XP',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.orange,
                      ),
                    ),
                  ).animate(delay: 600.ms).fadeIn().scale(
                      begin: const Offset(0.8, 0.8),
                      curve: Curves.easeOutBack),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: widget.onDismiss,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.sky,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text('계속하기',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                  ).animate(delay: 800.ms).fadeIn().slideY(begin: 0.3),
                ],
              ),
            )
                .animate()
                .scale(
                  duration: 400.ms,
                  curve: Curves.easeOutBack,
                  begin: const Offset(0.7, 0.7),
                )
                .fadeIn(),
          ),
        ],
      ),
    );
  }
}

class CorrectFeedback extends StatelessWidget {
  const CorrectFeedback({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: const Text('⭕', style: TextStyle(fontSize: 80))
          .animate()
          .scale(
            duration: 300.ms,
            curve: Curves.elasticOut,
            begin: const Offset(0, 0),
          )
          .then()
          .fadeOut(delay: 400.ms, duration: 200.ms),
    );
  }
}

class WrongFeedback extends StatelessWidget {
  const WrongFeedback({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: const Text('❌', style: TextStyle(fontSize: 80))
          .animate()
          .scale(
            duration: 300.ms,
            curve: Curves.easeOutBack,
            begin: const Offset(0, 0),
          )
          .shake(hz: 4, duration: 300.ms)
          .then()
          .fadeOut(delay: 400.ms, duration: 200.ms),
    );
  }
}
