import 'package:flutter/material.dart';
import '../theme.dart';

class XpBar extends StatelessWidget {
  final int currentXp;
  final int level;
  final bool compact;

  const XpBar({
    super.key,
    required this.currentXp,
    required this.level,
    this.compact = false,
  });

  double get _progress {
    final currentThreshold = LevelInfo.xpForLevel(level);
    final nextThreshold = LevelInfo.xpForNextLevel(level);
    if (nextThreshold <= currentThreshold) return 1.0;
    return ((currentXp - currentThreshold) / (nextThreshold - currentThreshold))
        .clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    if (compact) return _buildCompact(context);
    return _buildFull(context);
  }

  Widget _buildFull(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.sky.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    LevelInfo.emojiFor(level),
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lv.$level',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.sky,
                        ),
                      ),
                      Text(
                        LevelInfo.titleFor(level),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.yellow.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$currentXp XP',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.orange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: _progress),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 12,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation(
                    HSLColor.fromAHSL(
                            1.0, (level * 40.0) % 360, 0.7, 0.55)
                        .toColor(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${(_progress * 100).toInt()}% 다음 레벨까지',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompact(BuildContext context) {
    return Row(
      children: [
        Text(
          LevelInfo.emojiFor(level),
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(width: 6),
        Text(
          'Lv.$level',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.sky,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: _progress),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 8,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation(AppColors.yellow),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
