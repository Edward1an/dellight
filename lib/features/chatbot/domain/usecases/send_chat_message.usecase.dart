import 'package:dellight/core/resources/data_state.dart';
import 'package:dellight/core/usecase/usecase.dart';
import 'package:dellight/features/chatbot/domain/entities/chat_message.dart';
import 'package:dellight/features/chatbot/domain/repositories/chat_message.repository.dart';

class SendChatMessageUsecase
    implements UseCase<DataState<ChatMessage>, dynamic> {
  final ChatMessageRepository chatMessageRepository;
  final String accessToken;

  SendChatMessageUsecase({
    required this.chatMessageRepository,
    required this.accessToken,
  });

  @override
  Future<DataState<ChatMessage>> call({param}) async {
    return chatMessageRepository.sendChatMessage(accessToken, param);
  }
}
