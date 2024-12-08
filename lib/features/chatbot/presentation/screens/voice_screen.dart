// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:logger/logger.dart' show Level;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  final _player = FlutterSoundPlayer();
  bool _isPlaying = false;
  bool _isPlayerInitialized = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      await _player.openPlayer();
      _player.setLogLevel(Level.off);
      _isPlayerInitialized = true;
      print('Player initialized successfully');
    } catch (e) {
      print('Error initializing player: $e');
    }
  }

  Future<String> _getFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/audio.aac';
  }

  Future<void> _playRecording() async {
    if (!_isPlayerInitialized) {
      print('Player not initialized');
      return;
    }

    try {
      String path = await _getFilePath();
      final file = File(path);

      if (!await file.exists()) {
        print('Audio file does not exist at path: $path');
        return;
      }

      print('Attempting to play file from: $path');
      print('File exists: ${await file.exists()}');
      print('File size: ${await file.length()} bytes');

      if (_isPlaying) {
        await _player.stopPlayer();
        print('Playback stopped');
      } else {
        await _player
            .setSubscriptionDuration(const Duration(milliseconds: 100));
        await _player.startPlayer(
          fromURI: path,
          codec: Codec.aacADTS,
          whenFinished: () {
            print('Playback finished');
            setState(() {
              _isPlaying = false;
            });
          },
        );
        print('Playback started');
      }
      setState(() {
        _isPlaying = !_isPlaying;
      });
    } catch (e, stackTrace) {
      print('Error playing audio: $e');
      print('Error details: ${e.toString()}');
      print('Stack trace: $stackTrace');
    }
  }

  @override
  void dispose() {
    if (_isPlayerInitialized) {
      _player.closePlayer();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      key: const ValueKey('voice_screen'),
      color: theme.colorScheme.surface,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Last Recording'),
            const SizedBox(height: 16),
            IconButton(
              onPressed: _playRecording,
              icon: Icon(
                _isPlaying ? Icons.stop : Icons.play_arrow,
                size: 32,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
