import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme.dart';
import '../models/hangul_problem.dart';

class AnswerFeedback extends StatelessWidget {
  final HangulProblem problem;
  final EmojiChoice userAnswer;
  final VoidCallback onNext;
  final bool isLast;

  const AnswerFeedback({
    super.key,
    required this.problem,
    required this.userAnswer,
    required this.onNext,
    this.isLast = false,
  });

  /// 마지막 글자에 받침이 있으면 true
  static bool _hasBatchim(String text) {
    if (text.isEmpty) return false;
    final last = text.runes.last;
    // 한글 음절 범위: 0xAC00 ~ 0xD7A3
    if (last < 0xAC00 || last > 0xD7A3) return false;
    return (last - 0xAC00) % 28 != 0;
  }

  /// 받침 유무에 따라 은/는 반환
  static String _eunNeun(String text) => _hasBatchim(text) ? '은' : '는';

  /// 받침 유무에 따라 이에요/예요 반환
  static String _ieyo(String text) => _hasBatchim(text) ? '이에요' : '예요';

  String get _explanation {
    final q = problem.question;
    switch (problem.mode) {
      case GameMode.consonant:
        return '$q${_eunNeun(q)} ${problem.correctWord}! ${problem.correctEmoji}';
      case GameMode.syllable:
        return '$q${_eunNeun(q)} ${problem.correctWord}! ${problem.correctEmoji}';
      case GameMode.word:
        return '$q${_eunNeun(q)} ${problem.correctEmoji} ${_ieyo(q)}!';
      case GameMode.challenge:
        return '정답${_eunNeun("정답")} ${problem.correctWord} ${problem.correctEmoji}!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.green.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.green.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                problem.correctEmoji,
                style: const TextStyle(fontSize: 48),
              )
                  .animate()
                  .scale(
                    duration: 500.ms,
                    curve: Curves.elasticOut,
                    begin: const Offset(0, 0),
                  )
                  .shimmer(delay: 500.ms, duration: 600.ms),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _explanation,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.sky,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
            ),
            child: Text(
              isLast ? '결과 보기' : '다음 문제',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }
}
