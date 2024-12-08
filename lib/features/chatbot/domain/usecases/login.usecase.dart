import 'package:dellight/core/resources/data_state.dart';
import 'package:dellight/core/usecase/usecase.dart';
import 'package:dellight/features/chatbot/domain/entities/auth_request.dart';
import 'package:dellight/features/chatbot/domain/entities/auth_response.dart';
import 'package:dellight/features/chatbot/domain/repositories/auth.repository.dart';

class LoginUsecase implements UseCase<DataState<AuthResponse>, dynamic> {
  final AuthRepository authRepository;
  final AuthRequest request;

  LoginUsecase({required this.authRepository, required this.request});

  @override
  Future<DataState<AuthResponse>> call({param}) async {
    return authRepository.login(request);
  }
}
