// ignore_for_file: avoid_print

import 'package:dellight/features/chatbot/data/services/secure_storage.service.dart';
import 'package:dellight/features/chatbot/presentation/blocs/chat_messages_bloc/chat_messages_bloc.dart';
import 'package:dellight/features/chatbot/presentation/blocs/chat_messages_bloc/chat_messages_event.dart';
import 'package:dellight/features/chatbot/presentation/blocs/chat_messages_bloc/chat_messages_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dellight/features/chatbot/presentation/shared/chat_message_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _getChatMessages();
  }

  Future<void> _getChatMessages() async {
    final secureStorage = SecureStorageService();
    final accessToken = await secureStorage.readToken();
    print(accessToken);
    // ignore: use_build_context_synchronously
    context
        .read<ChatMessagesBloc>()
        .add(GetChatMessagesEvent(accessToken: accessToken ?? ''));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _scrollToBottom() async {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('chat_screen'),
      color: Theme.of(context).colorScheme.surface,
      child: BlocConsumer<ChatMessagesBloc, ChatMessagesState>(
        listener: (context, state) async {
          if (state is ChatMessagesSuccess) {
            await _scrollToBottom();
          }
        },
        builder: (context, state) {
          if (state is ChatMessagesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ChatMessagesSuccess) {
            return ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: state.chatMessages.length,
              itemBuilder: (context, index) {
                final message = state.chatMessages[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ChatMessageWidget(
                    message: message,
                  ),
                );
              },
            );
          }
          if (state is ChatMessagesFailure) {
            return Center(
              child: Text('Error: ${state.statusCode}'),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
