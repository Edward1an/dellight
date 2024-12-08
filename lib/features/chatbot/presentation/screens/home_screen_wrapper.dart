// ignore_for_file: require_trailing_commas

import 'package:dellight/features/chatbot/data/services/secure_storage.service.dart';
import 'package:dellight/features/chatbot/domain/entities/chat_message.dart';
import 'package:dellight/features/chatbot/presentation/blocs/chat_messages_bloc/chat_messages_bloc.dart';
import 'package:dellight/features/chatbot/presentation/blocs/chat_messages_bloc/chat_messages_event.dart';
import 'package:dellight/features/chatbot/presentation/screens/chat_screen.dart';
import 'package:dellight/features/chatbot/presentation/screens/settings_screen.dart';
import 'package:dellight/features/chatbot/presentation/screens/voice_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dellight/features/chatbot/presentation/shared/voice_button.dart';

enum HomeScreenType { chat, voice }

class HomeScreenWrapper extends StatefulWidget {
  const HomeScreenWrapper({super.key});

  @override
  State<HomeScreenWrapper> createState() => _HomeScreenWrapperState();
}

class _HomeScreenWrapperState extends State<HomeScreenWrapper>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  HomeScreenType _currentScreen = HomeScreenType.chat;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.4,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
      reverseCurve: Curves.easeInBack,
    ));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentScreen = index == 0 ? HomeScreenType.chat : HomeScreenType.voice;
    });
    if (index == 0) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu, color: theme.colorScheme.onSurface),
          onPressed: () {
            // Add drawer or menu functionality
          },
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/images/icon_logo.png',
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Dellight',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: theme.colorScheme.onSurface),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                child: _currentScreen == HomeScreenType.chat
                    ? const ChatScreen()
                    : const VoiceScreen(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          _currentScreen == HomeScreenType.voice ? const VoiceButton() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: Row(
            children: [
              // Mic/Chat toggle button
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _currentScreen == HomeScreenType.chat
                        ? _scaleAnimation.value
                        : 1.0,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentScreen == HomeScreenType.chat
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surfaceContainerHighest,
                        boxShadow: _currentScreen == HomeScreenType.chat
                            ? [
                                BoxShadow(
                                  color: theme.colorScheme.primary
                                      .withOpacity(0.3),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: IconButton(
                        icon: Icon(
                          _currentScreen == HomeScreenType.chat
                              ? Icons.mic
                              : Icons.chat_bubble_outline,
                          color: _currentScreen == HomeScreenType.chat
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurfaceVariant,
                          size: 24,
                        ),
                        onPressed: () => _onItemTapped(
                            _currentScreen == HomeScreenType.chat ? 1 : 0),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              // Animated content area
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _currentScreen == HomeScreenType.chat
                      ? Row(
                          key: const ValueKey('chat_input'),
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 48,
                                child: TextField(
                                  controller: _messageController,
                                  decoration: InputDecoration(
                                    hintText: 'Type a message...',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(24),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: theme
                                        .colorScheme.surfaceContainerHighest,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              height: 48,
                              child: IconButton(
                                onPressed: () async {
                                  if (_messageController.text.isNotEmpty) {
                                    final message = ChatMessage(
                                      role: Role.user,
                                      content: _messageController.text,
                                      timestamp: DateTime.now(),
                                      locale: Localizations.localeOf(context),
                                    );

                                    final secureStorage =
                                        SecureStorageService();
                                    final accessToken =
                                        await secureStorage.readToken();
                                    // ignore: use_build_context_synchronously
                                    context.read<ChatMessagesBloc>().add(
                                          SendChatMessageEvent(
                                            accessToken: accessToken ?? '',
                                            chatMessage: message,
                                          ),
                                        );
                                    _messageController.clear();
                                  }
                                },
                                icon: Icon(
                                  Icons.send,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(), // Empty widget when in voice mode
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
