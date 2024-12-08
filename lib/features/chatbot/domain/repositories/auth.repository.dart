import 'package:dellight/core/resources/data_state.dart';
import 'package:dellight/features/chatbot/domain/entities/auth_request.dart';
import 'package:dellight/features/chatbot/domain/entities/auth_response.dart';

abstract class AuthRepository {
  Future<DataState<AuthResponse>> login(AuthRequest request);
  Future<DataState<AuthResponse>> refreshToken(String refreshToken);
}
