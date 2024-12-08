import 'package:flutter/material.dart';
import 'package:dellight/features/chatbot/domain/entities/chat_message.dart';

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUserMessage = message.role == Role.user;
    final alignment =
        isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bubbleColor = isUserMessage ? Colors.green[100] : Colors.blue[100];
    final textColor = isUserMessage ? Colors.green[800] : Colors.blue[800];

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment:
                isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isUserMessage) const CircleAvatar(child: Icon(Icons.person)),
              Flexible(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(color: textColor),
                  ),
                ),
              ),
              if (isUserMessage) const CircleAvatar(child: Icon(Icons.person)),
            ],
          ),
        ),
      ],
    );
  }
}
