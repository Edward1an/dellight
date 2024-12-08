import 'package:dellight/features/chatbot/domain/entities/auth_request.dart';
import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckLoginEvent extends AuthEvent {
  const CheckLoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final AuthRequest authRequest;

  const LoginEvent({required this.authRequest});

  @override
  List<Object?> get props => [authRequest];
}

class RefreshTokenEvent extends AuthEvent {
  final String refreshToken;

  const RefreshTokenEvent({required this.refreshToken});

  @override
  List<Object?> get props => [refreshToken];
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();

  @override
  List<Object?> get props => [];
}
