import 'package:dellight/core/resources/data_state.dart';
import 'package:dellight/features/chatbot/data/mappers/auth_request.mapper.dart';
import 'package:dellight/features/chatbot/data/mappers/auth_response.mapper.dart';
import 'package:dellight/features/chatbot/data/sources/remote/remote_auth.source.dart';
import 'package:dellight/features/chatbot/domain/entities/auth_request.dart';
import 'package:dellight/features/chatbot/domain/entities/auth_response.dart';
import 'package:dellight/features/chatbot/domain/repositories/auth.repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteAuthSource remoteAuthSource;

  AuthRepositoryImpl({required this.remoteAuthSource});

  @override
  Future<DataState<AuthResponse>> login(AuthRequest request) async {
    final response =
        await remoteAuthSource.login(AuthRequestMapper.toModel(request));
    if (response.data != null) {
      return DataSuccess(AuthResponseMapper.toEntity(response.data!));
    }
    return DataFailure(response.statusCode ?? 500);
  }

  @override
  Future<DataState<AuthResponse>> refreshToken(String refreshToken) async {
    final response = await remoteAuthSource.refreshToken(refreshToken);
    if (response.data != null) {
      return DataSuccess(AuthResponseMapper.toEntity(response.data!));
    }
    return DataFailure(response.statusCode ?? 500);
  }
}
