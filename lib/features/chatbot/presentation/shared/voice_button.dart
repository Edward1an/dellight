// ignore_for_file: avoid_print

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dellight/features/chatbot/presentation/blocs/chat_messages_bloc/chat_messages_bloc.dart';
import 'package:dellight/features/chatbot/presentation/blocs/chat_messages_bloc/chat_messages_state.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:logger/logger.dart' show Level;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dellight/env.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dellight/features/chatbot/data/services/secure_storage.service.dart';

class VoiceButton extends StatefulWidget {
  const VoiceButton({super.key});

  @override
  State<VoiceButton> createState() => _VoiceButtonState();
}

class _VoiceButtonState extends State<VoiceButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _rippleController;
  late Animation<double> _rippleAnimation;
  final _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  bool _isRecorderInitialized = false;
  String? _filePath;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _rippleAnimation = Tween<double>(begin: 1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _rippleController,
        curve: Curves.easeInOut,
      ),
    );
    _recorder.openRecorder().then((value) async {
      await initializeAudioSession();
      _isRecorderInitialized = true;
    });
  }

  Future<void> initializeAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(
      AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.allowBluetooth |
                AVAudioSessionCategoryOptions.defaultToSpeaker,
        avAudioSessionMode: AVAudioSessionMode.spokenAudio,
        avAudioSessionRouteSharingPolicy:
            AVAudioSessionRouteSharingPolicy.defaultPolicy,
        avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
        androidAudioAttributes: const AndroidAudioAttributes(
          contentType: AndroidAudioContentType.speech,
          flags: AndroidAudioFlags.none,
          usage: AndroidAudioUsage.voiceCommunication,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: true,
      ),
    );
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _rippleController.dispose();
    super.dispose();
  }

  Future<String> _getFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/audio.aac';
  }

  Future<void> _startRecording() async {
    try {
      // Request microphone permission using permission_handler

      String path = await _getFilePath();
      print('Starting recording to path: $path');
      await _recorder.startRecorder(
        toFile: path,
        codec: Codec.aacADTS,
      );

      print('After starting - Recorder state: ${_recorder.recorderState}');
      _filePath = path;
      print('Recording started successfully');
    } catch (e, stackTrace) {
      print('Error starting recording: $e');
      print('Stack trace: $stackTrace');
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecorderInitialized) {
      print('Recorder not initialized for stopping');
      return;
    }

    try {
      print('Before stopping - Is recording: ${_recorder.isRecording}');

      String? path = await _recorder.stopRecorder();
      print('Recording stopped. File saved at: $path');

      if (path != null) {
        final file = File(path);
        if (await file.exists()) {
          print('File exists: true');
          print('File size: ${await file.length()} bytes');
          print('File path: ${file.absolute.path}');
          _filePath = path;
          await uploadAudio();
        } else {
          print('File does not exist after recording');
        }
      } else {
        print('No path returned from stopRecorder');
      }
    } catch (e, stackTrace) {
      print('Error stopping recording: $e');
      print('Stack trace: $stackTrace');
    }
  }

  Future<void> _handleTapAsync() async {
    if (_isRecording) {
      await _stopRecording();
      _rippleController.stop();
      _rippleController.reset();
    } else {
      await _startRecording();
      _rippleController.repeat();
    }

    if (mounted) {
      setState(() {
        _isRecording = !_isRecording;
      });
    }
  }

  Future<void> uploadAudio() async {
    if (_filePath != null) {
      try {
        final String baseUrl = EnvConfig.BASE_URL;
        final secureStorage = SecureStorageService();
        final accessToken = await secureStorage.readToken();

        if (accessToken == null) {
          print("No access token available");
          return;
        }

        var url = Uri.parse('$baseUrl/chat/transcript');
        var request = http.MultipartRequest('POST', url);

        // Add authorization header
        request.headers['Authorization'] = 'Bearer $accessToken';

        // Check file before uploading
        final file = File(_filePath!);
        if (!await file.exists() || await file.length() == 0) {
          print("File is empty or doesn't exist");
          return;
        }

        request.files
            .add(await http.MultipartFile.fromPath('file', _filePath!));
        var response = await request.send();

        print("Upload response status: ${response.statusCode}");
        if (response.statusCode == 200) {
          final responseBody = await response.stream.bytesToString();
          print("Upload response: $responseBody");
        }
      } catch (e, stackTrace) {
        print("Upload error: $e");
        print("Stack trace: $stackTrace");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ChatMessagesBloc, ChatMessagesState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () async => await _handleTapAsync(),
          child: AnimatedBuilder(
            animation: _rippleAnimation,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  if (_isRecording) ...[
                    ...List.generate(3, (index) {
                      final delay = index * 0.4;
                      return Transform.scale(
                        scale: _rippleAnimation.value - (delay),
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.primary.withOpacity(
                                (1 - (_rippleAnimation.value - 1 - delay))
                                    .clamp(0, 0.3),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.primary,
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.mic,
                      color: theme.colorScheme.onPrimary,
                      size: 32,
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
