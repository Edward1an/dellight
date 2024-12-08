import 'package:equatable/equatable.dart';
import 'package:dellight/features/chatbot/domain/entities/chat_message.dart';

sealed class ChatMessagesEvent extends Equatable {
  const ChatMessagesEvent();

  @override
  List<Object?> get props => [];
}

class GetChatMessagesEvent extends ChatMessagesEvent {
  final String accessToken;

  const GetChatMessagesEvent({required this.accessToken});

  @override
  List<Object?> get props => [accessToken];
}

class SendChatMessageEvent extends ChatMessagesEvent {
  final String accessToken;
  final ChatMessage chatMessage;

  const SendChatMessageEvent({
    required this.accessToken,
    required this.chatMessage,
  });

  @override
  List<Object?> get props => [accessToken, chatMessage];
}
