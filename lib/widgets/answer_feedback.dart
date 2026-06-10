import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme.dart';
import '../models/hangul_problem.dart';

class AnswerFeedback extends StatelessWidget {
  final HangulProblem problem;
  final EmojiChoice userAnswer;
  final VoidCallback onNext;
  final bool isLast;
  final bool isCorrect;

  const AnswerFeedback({
    super.key,
    required this.problem,
    required this.userAnswer,
    required this.onNext,
    this.isLast = false,
    this.isCorrect = false,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = isCorrect ? AppColors.sky : AppColors.green;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isCorrect)
            Text(
              '⭕ 정답!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.green,
              ),
            ).animate().scale(
                  duration: 400.ms,
                  curve: Curves.elasticOut,
                  begin: const Offset(0.5, 0.5),
                ),
          if (isCorrect) const SizedBox(height: 12),
          Text(
            problem.correctEmoji,
            style: const TextStyle(fontSize: 64),
          )
              .animate()
              .scale(
                duration: 500.ms,
                curve: Curves.elasticOut,
                begin: const Offset(0, 0),
              )
              .shimmer(delay: 500.ms, duration: 600.ms),
          const SizedBox(height: 8),
          Text(
            problem.correctWord,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Color(0xFF333333),
            ),
          ).animate().fadeIn(delay: 150.ms),
          const SizedBox(height: 8),
          Text(
            problem.explanation,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ).animate().fadeIn(delay: 250.ms),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
            ),
            child: Text(
              isLast ? '결과 보기' : '다음 문제',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.3),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }
}
