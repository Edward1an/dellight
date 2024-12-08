import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum Role {
  user,
  assistant,
}

class ChatMessage extends Equatable {
  final Role role;
  final String content;
  final DateTime timestamp;
  final Locale locale;

  const ChatMessage({
    required this.role,
    required this.content,
    required this.timestamp,
    required this.locale,
  });

  @override
  List<Object?> get props => [role, content, timestamp, locale];
}
