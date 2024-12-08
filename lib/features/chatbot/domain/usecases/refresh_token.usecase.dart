import 'package:dellight/core/resources/data_state.dart';
import 'package:dellight/core/usecase/usecase.dart';
import 'package:dellight/features/chatbot/domain/entities/auth_response.dart';
import 'package:dellight/features/chatbot/domain/repositories/auth.repository.dart';

class RefreshTokenUsecase implements UseCase<DataState<AuthResponse>, dynamic> {
  final AuthRepository authRepository;
  final String refreshToken;

  RefreshTokenUsecase({
    required this.authRepository,
    required this.refreshToken,
  });

  @override
  Future<DataState<AuthResponse>> call({param}) async {
    return authRepository.refreshToken(refreshToken);
  }
}
