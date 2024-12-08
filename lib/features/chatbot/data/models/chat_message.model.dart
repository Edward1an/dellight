import 'package:equatable/equatable.dart';

class ChatMessageModel extends Equatable {
  final int role;
  final String content;
  final int timestamp;
  final String locale;

  const ChatMessageModel({
    required this.role,
    required this.content,
    required this.timestamp,
    required this.locale,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      role: json['role'],
      content: json['content'],
      timestamp: json['timestamp'],
      locale: json['locale'],
    );
  }

  static List<ChatMessageModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ChatMessageModel.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
      'timestamp': timestamp,
      'locale': locale,
    };
  }

  @override
  List<Object?> get props => [role, content, timestamp, locale];
}
