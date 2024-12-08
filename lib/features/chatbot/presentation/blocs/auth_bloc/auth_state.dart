import 'package:dellight/features/chatbot/domain/entities/user_info.dart';
import 'package:equatable/equatable.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
  @override
  List<Object?> get props => [];
}

class AuthLoading extends AuthState {
  const AuthLoading();
  @override
  List<Object?> get props => [];
}

class AuthSuccess extends AuthState {
  final UserInfo userInfo;

  const AuthSuccess({required this.userInfo});

  @override
  List<Object?> get props => [userInfo];
}

class AuthFailure extends AuthState {
  final int statusCode;
  const AuthFailure({required this.statusCode});
  @override
  List<Object?> get props => [statusCode];
}
