import 'package:dellight/core/injection/dependency_injection.dart';
import 'package:dellight/core/resources/data_state.dart';
import 'package:dellight/features/chatbot/domain/entities/chat_message.dart';
import 'package:dellight/features/chatbot/domain/repositories/chat_message.repository.dart';
import 'package:dellight/features/chatbot/presentation/blocs/chat_messages_bloc/chat_messages_event.dart';
import 'package:dellight/features/chatbot/presentation/blocs/chat_messages_bloc/chat_messages_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatMessagesBloc extends Bloc<ChatMessagesEvent, ChatMessagesState> {
  final ChatMessageRepository chatMessageRepository =
      getIt<ChatMessageRepository>();

  ChatMessagesBloc() : super(const ChatMessagesInitial()) {
    on<GetChatMessagesEvent>(_onGetChatMessagesEvent);
    on<SendChatMessageEvent>(_onSendChatMessageEvent);
  }

  Future<void> _onGetChatMessagesEvent(
    GetChatMessagesEvent event,
    Emitter<ChatMessagesState> emit,
  ) async {
    // emit(const ChatMessagesLoading());
    final result =
        await chatMessageRepository.getChatMessages(event.accessToken);
    if (result is DataSuccess && result.data != null) {
      emit(ChatMessagesSuccess(chatMessages: result.data!));
    } else if (result is DataFailure) {
      emit(ChatMessagesFailure(statusCode: result.statusCode ?? 1));
    }
  }

  Future<void> _onSendChatMessageEvent(
    SendChatMessageEvent event,
    Emitter<ChatMessagesState> emit,
  ) async {
    List<ChatMessage> chatMessages =
        List.from((state as ChatMessagesSuccess).chatMessages);
    // emit(const ChatMessagesLoading());

    final result = await chatMessageRepository.sendChatMessage(
      event.accessToken,
      event.chatMessage,
    );

    final result2 =
        await chatMessageRepository.getChatMessages(event.accessToken);

    if (result is DataSuccess &&
        result2 is DataSuccess &&
        result2.data != null) {
      chatMessages.add(result.data!);
      emit(ChatMessagesSuccess(chatMessages: result2.data!));
    } else if (result is DataFailure) {
      emit(ChatMessagesFailure(statusCode: result.statusCode ?? 1));
    }
  }
}
