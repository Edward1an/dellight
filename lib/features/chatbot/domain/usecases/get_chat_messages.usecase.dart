import 'package:dellight/core/resources/data_state.dart';
import 'package:dellight/core/usecase/usecase.dart';
import 'package:dellight/features/chatbot/domain/entities/chat_message.dart';
import 'package:dellight/features/chatbot/domain/repositories/chat_message.repository.dart';

class GetChatMessagesUsecase
    implements UseCase<DataState<List<ChatMessage>>, dynamic> {
  final String accessToken;
  final ChatMessageRepository chatMessageRepository;

  GetChatMessagesUsecase({
    required this.accessToken,
    required this.chatMessageRepository,
  });

  @override
  Future<DataState<List<ChatMessage>>> call({param}) async {
    return chatMessageRepository.getChatMessages(accessToken);
  }
}
