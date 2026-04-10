import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class VoiceService {
  static final FlutterTts _flutterTts = FlutterTts();
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized || kIsWeb || Platform.isWindows) return;
    
    try {
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setSpeechRate(0.5); // Slower, clearer speech for seniors
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      _isInitialized = true;
    } catch (e) {
      if (kDebugMode) print('Failed to initialize TTS: $e');
    }
  }

  static Future<void> speak(String text) async {
    if (kIsWeb || Platform.isWindows) return;
    if (!_isInitialized) await initialize();
    
    try {
      await _flutterTts.speak(text);
    } catch (e) {
      if (kDebugMode) print('Failed to speak text: $e');
    }
  }

  static Future<void> stop() async {
    if (kIsWeb || Platform.isWindows) return;
    try {
      await _flutterTts.stop();
    } catch (e) {
      if (kDebugMode) print('Failed to stop TTS: $e');
    }
  }
}
