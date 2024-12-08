import 'package:equatable/equatable.dart';

class AuthResponse extends Equatable {
  final String accessToken;
  final String refreshToken;

  const AuthResponse({required this.accessToken, required this.refreshToken});

  @override
  List<Object?> get props => [accessToken, refreshToken];
}
