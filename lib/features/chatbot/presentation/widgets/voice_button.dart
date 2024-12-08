// ignore_for_file: avoid_print

import 'dart:async';

import 'package:dellight/env.dart';
import 'package:dellight/features/chatbot/data/services/secure_storage.service.dart';
import 'package:dellight/features/chatbot/presentation/blocs/chat_messages_bloc/chat_messages_bloc.dart';
import 'package:dellight/features/chatbot/presentation/blocs/chat_messages_bloc/chat_messages_event.dart';
import 'package:dellight/features/chatbot/presentation/blocs/chat_messages_bloc/chat_messages_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';

class VoiceButton extends StatefulWidget {
  const VoiceButton({super.key});

  @override
  State<VoiceButton> createState() => _VoiceButtonState();
}

class _VoiceButtonState extends State<VoiceButton>
    with SingleTickerProviderStateMixin {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  late AnimationController _rippleController;
  late Animation<double> _rippleAnimation;
  bool _isPulsing = false;
  String? _filePath;

  Future<bool> requestMicrophonePermission() async {
    var status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<void> initializeRecorder() async {
    await _recorder.openRecorder();
  }

  Future<void> startRecording() async {
    await _recorder.startRecorder(
      toFile: "audio.aac",
      codec: Codec.aacADTS,
    );
  }

  Future<void> uploadAudio() async {
    if (_filePath != null) {
      final String baseUrl = EnvConfig.BASE_URL;
      var url = Uri.parse('$baseUrl/chat/transcript');
      var request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('audio', _filePath!));
      var response = await request.send();
      if (response.statusCode == 200) {
        print("Audio uploaded successfully");
      } else {
        print("Failed to upload audio: ${response.statusCode}");
      }
    }
  }

  Future<void> stopRecording() async {
    String? filePath = await _recorder.stopRecorder();
    print("Recording stopped. File saved at: $filePath");
    _filePath = filePath;
    await uploadAudio();
  }

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
    unawaited(initializeRecorder());
  }

  Future<void> _togglePulsing() async {
    if (_isPulsing) {
      await stopRecording();
      print("Recording stopped");
      final accessToken = await SecureStorageService().readToken();
      context
          .read<ChatMessagesBloc>()
          .add(GetChatMessagesEvent(accessToken: accessToken!));
    } else {
      await startRecording();
      print("Recording started");
    }
    setState(() {
      _isPulsing = !_isPulsing;
    });
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ChatMessagesBloc, ChatMessagesState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: _togglePulsing,
          child: AnimatedBuilder(
            animation: _rippleAnimation,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  if (_isPulsing) ...[
                    // Ripple circles
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
                  // Main button
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
