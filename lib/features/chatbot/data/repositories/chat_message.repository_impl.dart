import 'package:dellight/core/resources/data_state.dart';
import 'package:dellight/features/chatbot/data/mappers/chat_message.mapper.dart';
import 'package:dellight/features/chatbot/data/sources/remote/remote_chat_message.source.dart';
import 'package:dellight/features/chatbot/domain/entities/chat_message.dart';
import 'package:dellight/features/chatbot/domain/repositories/chat_message.repository.dart';

class ChatMessageRepositoryImpl implements ChatMessageRepository {
  final RemoteChatMessageSource remoteChatMessageSource;

  ChatMessageRepositoryImpl({required this.remoteChatMessageSource});

  @override
  Future<DataState<List<ChatMessage>>> getChatMessages(
    String accessToken,
  ) async {
    final response = await remoteChatMessageSource.getChatMessages(accessToken);
    if (response.data != null) {
      return DataSuccess(ChatMessageMapper.toEntityList(response.data!));
    }
    return DataFailure(response.statusCode ?? 500);
  }

  @override
  Future<DataState<ChatMessage>> sendChatMessage(
    String accessToken,
    ChatMessage message,
  ) async {
    final response = await remoteChatMessageSource.sendChatMessage(
      accessToken,
      ChatMessageMapper.toModel(message),
    );
    if (response.data != null) {
      return DataSuccess(ChatMessageMapper.toEntity(response.data!));
    }
    return DataFailure(response.statusCode ?? 500);
  }
}
