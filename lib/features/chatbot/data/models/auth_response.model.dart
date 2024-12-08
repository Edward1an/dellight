import 'package:equatable/equatable.dart';

class AuthResponseModel extends Equatable {
  final String accessToken;
  final String refreshToken;

  const AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  @override
  List<Object?> get props => [accessToken, refreshToken];
}
