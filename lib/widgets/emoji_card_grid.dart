import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme.dart';
import '../models/hangul_problem.dart';

class EmojiCardGrid extends StatelessWidget {
  final List<EmojiChoice> choices;
  final EmojiChoice? selectedChoice;
  final bool enabled;
  final bool hideWord;
  final ValueChanged<EmojiChoice> onSelect;

  const EmojiCardGrid({
    super.key,
    required this.choices,
    required this.onSelect,
    this.selectedChoice,
    this.enabled = true,
    this.hideWord = false,
  });

  @override
  Widget build(BuildContext context) {
    final count = choices.length;
    final crossAxisCount = count <= 3 ? count : 2;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: count <= 3 ? 0.85 : 0.9,
      children: choices.asMap().entries.map((entry) {
        final idx = entry.key;
        final choice = entry.value;
        return _EmojiCard(
          choice: choice,
          selected: selectedChoice,
          enabled: enabled,
          hideWord: hideWord,
          onTap: () => onSelect(choice),
          delay: idx * 80,
        );
      }).toList(),
    );
  }
}

class _EmojiCard extends StatelessWidget {
  final EmojiChoice choice;
  final EmojiChoice? selected;
  final bool enabled;
  final bool hideWord;
  final VoidCallback onTap;
  final int delay;

  const _EmojiCard({
    required this.choice,
    required this.selected,
    required this.enabled,
    required this.hideWord,
    required this.onTap,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selected != null &&
        selected!.emoji == choice.emoji &&
        selected!.word == choice.word;
    final showResult = selected != null;

    Color borderColor;
    Color bgColor;

    if (showResult && isSelected) {
      borderColor = choice.isCorrect ? AppColors.green : AppColors.coral;
      bgColor = choice.isCorrect
          ? AppColors.green.withValues(alpha: 0.08)
          : AppColors.coral.withValues(alpha: 0.08);
    } else if (showResult && choice.isCorrect) {
      borderColor = AppColors.green;
      bgColor = AppColors.green.withValues(alpha: 0.08);
    } else {
      borderColor = Colors.grey.shade300;
      bgColor = Colors.white;
    }

    Widget card = GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderColor,
            width: (showResult && (isSelected || choice.isCorrect)) ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: borderColor.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              choice.emoji,
              style: const TextStyle(fontSize: 48),
            ),
            if (!hideWord || showResult) ...[
              const SizedBox(height: 8),
              Text(
                choice.word,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: showResult && isSelected && !choice.isCorrect
                      ? AppColors.coral
                      : const Color(0xFF555555),
                ),
              ),
            ],
            if (showResult && isSelected) ...[
              const SizedBox(height: 4),
              Text(
                choice.isCorrect ? '⭕' : '❌',
                style: const TextStyle(fontSize: 20),
              ),
            ] else if (showResult && choice.isCorrect) ...[
              const SizedBox(height: 4),
              const Text('✅', style: TextStyle(fontSize: 20)),
            ],
          ],
        ),
      ),
    );

    if (showResult && choice.isCorrect && !isSelected) {
      card = card
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .shimmer(duration: 800.ms, color: AppColors.green.withValues(alpha: 0.3));
    }

    if (showResult && isSelected && !choice.isCorrect) {
      card = card.animate().shake(hz: 4, duration: 300.ms);
    }

    return card
        .animate()
        .fadeIn(delay: Duration(milliseconds: delay), duration: 200.ms)
        .scale(
          begin: const Offset(0.9, 0.9),
          curve: Curves.easeOutBack,
          duration: 300.ms,
        );
  }
}
