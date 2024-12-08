import 'dart:ui';

import 'package:dellight/features/chatbot/data/models/chat_message.model.dart';
import 'package:dellight/features/chatbot/domain/entities/chat_message.dart';

class ChatMessageMapper {
  static ChatMessage toEntity(ChatMessageModel model) {
    return ChatMessage(
      role: Role.values[model.role],
      content: model.content,
      timestamp: DateTime.fromMillisecondsSinceEpoch(model.timestamp),
      locale: Locale(model.locale),
    );
  }

  static List<ChatMessage> toEntityList(List<ChatMessageModel> models) {
    return models.map(toEntity).toList();
  }

  static ChatMessageModel toModel(ChatMessage entity) {
    return ChatMessageModel(
      role: entity.role.index,
      content: entity.content,
      timestamp: entity.timestamp.millisecondsSinceEpoch,
      locale: entity.locale.toString(),
    );
  }
}
