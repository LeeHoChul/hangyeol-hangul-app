import 'package:flutter_tts/flutter_tts.dart';

/// 한국어 TTS 래퍼.
/// 기기에 TTS 엔진이 없거나 초기화에 실패해도 게임은 그대로 진행되도록
/// 모든 호출을 방어적으로 처리한다.
class TtsService {
  TtsService._();

  static final TtsService instance = TtsService._();

  final FlutterTts _tts = FlutterTts();
  bool _ready = false;
  bool muted = false;

  Future<void> init() async {
    try {
      await _tts.setLanguage('ko-KR');
      // 아이가 따라 들을 수 있도록 평소보다 천천히
      await _tts.setSpeechRate(0.45);
      await _tts.setPitch(1.05);
      _ready = true;
    } catch (_) {
      _ready = false;
    }
  }

  Future<void> speak(String text) async {
    if (!_ready || muted || text.isEmpty) return;
    try {
      await _tts.stop();
      await _tts.speak(text);
    } catch (_) {
      // TTS 실패는 무시 — 게임 진행이 우선
    }
  }

  Future<void> stop() async {
    if (!_ready) return;
    try {
      await _tts.stop();
    } catch (_) {}
  }
}
