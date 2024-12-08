import 'package:dellight/core/resources/data_state.dart';
import 'package:dellight/features/chatbot/domain/entities/chat_message.dart';

abstract class ChatMessageRepository {
  Future<DataState<List<ChatMessage>>> getChatMessages(String accessToken);
  Future<DataState<ChatMessage>> sendChatMessage(
    String accessToken,
    ChatMessage message,
  );
}
