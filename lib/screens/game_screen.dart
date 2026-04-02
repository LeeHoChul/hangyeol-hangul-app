import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme.dart';
import '../models/hangul_problem.dart';
import '../services/problem_generator.dart';
import '../services/storage_service.dart';
import '../widgets/emoji_card_grid.dart';
import '../widgets/answer_feedback.dart';
import '../widgets/xp_bar.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  final GameMode mode;
  final int difficultyLevel;
  final StorageService storage;

  const GameScreen({
    super.key,
    required this.mode,
    required this.difficultyLevel,
    required this.storage,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<HangulProblem> _problems;
  final List<EmojiChoice?> _userAnswers = [];
  int _currentIndex = 0;
  int _score = 0;
  int _streak = 0;
  int _maxStreak = 0;
  EmojiChoice? _selectedChoice;
  bool _showFeedback = false;
  bool _lastCorrect = false;
  bool _showAnswerFeedback = false;
  late DateTime _startTime;

  final _correctMessages = const [
    '천재 한결이! 🌟',
    '완벽해! ✨',
    '멋져! 💖',
    '대박! 👏',
    '역시! 🎀',
    '정답! 🎉',
    '와우! 🌈',
    '짱이야! 💪',
  ];

  @override
  void initState() {
    super.initState();
    _problems = ProblemGenerator().generateRound(
      widget.mode,
      widget.difficultyLevel,
    );
    _startTime = DateTime.now();
  }

  HangulProblem get _currentProblem => _problems[_currentIndex];
  double get _progress => _currentIndex / _problems.length;
  bool get _isLastQuestion => _currentIndex >= _problems.length - 1;

  void _onCardSelected(EmojiChoice choice) {
    if (_showFeedback || _showAnswerFeedback) return;

    final correct = choice.isCorrect;

    setState(() {
      _selectedChoice = choice;
      _userAnswers.add(choice);
      _showFeedback = true;
      _lastCorrect = correct;

      if (correct) {
        _score++;
        _streak++;
        if (_streak > _maxStreak) _maxStreak = _streak;
      } else {
        _streak = 0;
      }
    });

    Future.delayed(Duration(milliseconds: correct ? 800 : 1200), () {
      if (!mounted) return;

      if (!correct) {
        setState(() {
          _showFeedback = false;
          _showAnswerFeedback = true;
        });
      } else {
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    if (_isLastQuestion) {
      _finishGame();
      return;
    }

    setState(() {
      _currentIndex++;
      _selectedChoice = null;
      _showFeedback = false;
      _showAnswerFeedback = false;
    });
  }

  void _finishGame() {
    final elapsed = DateTime.now().difference(_startTime);
    final result = GameResult(
      mode: widget.mode,
      difficultyLevel: widget.difficultyLevel,
      problems: _problems,
      userAnswers: _userAnswers,
      score: _score,
      maxStreak: _maxStreak,
      elapsed: elapsed,
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          result: result,
          storage: widget.storage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _showQuitDialog();
      },
      child: Scaffold(
        body: Container(
          decoration:
              const BoxDecoration(gradient: AppColors.backgroundGradient),
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    _buildHeader(),
                    _buildProgressBar(),
                    Expanded(child: _buildGameArea()),
                  ],
                ),
                if (_showFeedback) _buildFeedbackOverlay(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: _showQuitDialog,
            icon: const Icon(Icons.close_rounded, color: Colors.grey),
          ),
          Expanded(
            child: XpBar(
              currentXp: widget.storage.totalXp,
              level: widget.storage.level,
              compact: true,
            ),
          ),
          const SizedBox(width: 8),
          _buildStat('맞힌 수', '$_score'),
          const SizedBox(width: 12),
          _buildStat('연속', '$_streak🔥'),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.sky,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: _progress),
          duration: const Duration(milliseconds: 400),
          builder: (_, value, _) => LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: Colors.white,
            valueColor:
                const AlwaysStoppedAnimation(AppColors.green),
          ),
        ),
      ),
    );
  }

  Widget _buildGameArea() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 8),
          _buildProblemCard(),
          const SizedBox(height: 16),
          if (_showAnswerFeedback) ...[
            AnswerFeedback(
              problem: _currentProblem,
              userAnswer: _selectedChoice!,
              onNext: _nextQuestion,
              isLast: _isLastQuestion,
            ),
          ] else ...[
            EmojiCardGrid(
              key: ValueKey(_currentIndex),
              choices: _currentProblem.choices,
              selectedChoice: _selectedChoice,
              enabled: !_showFeedback,
              hideWord: true,
              onSelect: _onCardSelected,
            ),
          ],
          if (_streak >= 3 && !_showAnswerFeedback)
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.orange, AppColors.yellow],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$_streak연속 정답! 🔥',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.05, 1.05),
                    duration: 800.ms),
        ],
      ),
    );
  }

  Widget _buildProblemCard() {
    String modeLabel;
    switch (_currentProblem.mode) {
      case GameMode.consonant:
        modeLabel = '이 그림은 어떤 자음으로 시작할까?';
      case GameMode.syllable:
        modeLabel = '이 글자로 시작하는 그림은?';
      case GameMode.word:
        modeLabel = '이 단어의 그림은?';
      case GameMode.challenge:
        modeLabel = '맞는 그림을 골라봐!';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.sky.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '${_currentIndex + 1}번 문제',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            modeLabel,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _currentProblem.question,
            style: const TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w700,
              color: Color(0xFF333333),
            ),
          ),
        ],
      ),
    )
        .animate(key: ValueKey(_currentIndex))
        .fadeIn(duration: 200.ms)
        .slideX(begin: 0.1, curve: Curves.easeOut);
  }

  Widget _buildFeedbackOverlay() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _lastCorrect ? '⭕' : '❌',
                style: const TextStyle(fontSize: 80),
              )
                  .animate()
                  .scale(
                    duration: 300.ms,
                    curve: Curves.elasticOut,
                    begin: const Offset(0, 0),
                  )
                  .then()
                  .fadeOut(delay: 300.ms),
              const SizedBox(height: 8),
              Text(
                _lastCorrect
                    ? _correctMessages[_currentIndex % _correctMessages.length]
                    : _currentProblem.mode == GameMode.consonant
                        ? '${_currentProblem.correctWord}${_currentProblem.correctEmoji} → ${_currentProblem.choices.firstWhere((c) => c.isCorrect).emoji}'
                        : '정답은 ${_currentProblem.correctWord} ${_currentProblem.correctEmoji}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _lastCorrect ? AppColors.green : AppColors.coral,
                ),
              )
                  .animate()
                  .fadeIn(delay: 100.ms)
                  .slideY(begin: 0.3)
                  .then()
                  .fadeOut(delay: 400.ms),
            ],
          ),
        ),
      ),
    );
  }

  void _showQuitDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('정말 나갈까?', textAlign: TextAlign.center),
        content: const Text(
          '진행 중인 게임이 사라져요 😢',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('계속 할래!'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.coral),
            child: const Text('나갈래'),
          ),
        ],
      ),
    );
  }
}
