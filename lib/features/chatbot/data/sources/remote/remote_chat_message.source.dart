import 'dart:convert';

import 'package:dellight/core/resources/data_state.dart';
import 'package:dellight/env.dart';
import 'package:dellight/features/chatbot/data/models/chat_message.model.dart';
import 'package:http/http.dart' as http;

class RemoteChatMessageSource {
  final String _baseUrl = EnvConfig.BASE_URL;
  final http.Client client;

  RemoteChatMessageSource({required this.client});

  Future<DataState<List<ChatMessageModel>>> getChatMessages(
    String accessToken,
  ) async {
    final response = await client.get(
      Uri.parse('$_baseUrl/chat/messages'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return DataSuccess(
        ChatMessageModel.fromJsonList(jsonDecode(response.body)),
      );
    } else {
      return DataFailure(response.statusCode);
    }
  }

  Future<DataState<ChatMessageModel>> sendChatMessage(
    String accessToken,
    ChatMessageModel message,
  ) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/chat/messages'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(message.toJson()),
    );

    if (response.statusCode == 200) {
      return DataSuccess(ChatMessageModel.fromJson(jsonDecode(response.body)));
    } else {
      return DataFailure(response.statusCode);
    }
  }
}
