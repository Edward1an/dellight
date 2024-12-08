import 'package:dellight/features/chatbot/domain/entities/chat_message.dart';
import 'package:equatable/equatable.dart';

sealed class ChatMessagesState extends Equatable {
  const ChatMessagesState();

  @override
  List<Object?> get props => [];
}

class ChatMessagesInitial extends ChatMessagesState {
  const ChatMessagesInitial();
  @override
  List<Object?> get props => [];
}

class ChatMessagesLoading extends ChatMessagesState {
  const ChatMessagesLoading();
  @override
  List<Object?> get props => [];
}

class ChatMessagesSuccess extends ChatMessagesState {
  final List<ChatMessage> chatMessages;

  const ChatMessagesSuccess({required this.chatMessages});

  @override
  List<Object?> get props => [chatMessages];
}

class ChatMessagesFailure extends ChatMessagesState {
  final int statusCode;
  const ChatMessagesFailure({required this.statusCode});
  @override
  List<Object?> get props => [statusCode];
}
