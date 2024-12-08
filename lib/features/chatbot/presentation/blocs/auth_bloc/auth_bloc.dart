import 'package:dellight/core/injection/dependency_injection.dart';
import 'package:dellight/core/resources/data_state.dart';
import 'package:dellight/features/chatbot/data/mappers/user_info.mapper.dart';
import 'package:dellight/features/chatbot/data/services/secure_storage.service.dart';
import 'package:dellight/features/chatbot/data/sources/remote/remote_user.source.dart';
import 'package:dellight/features/chatbot/domain/entities/user_info.dart';
import 'package:dellight/features/chatbot/domain/repositories/auth.repository.dart';
import 'package:dellight/features/chatbot/presentation/blocs/auth_bloc/auth_event.dart';
import 'package:dellight/features/chatbot/presentation/blocs/auth_bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository = getIt<AuthRepository>();
  final SecureStorageService secureStorageService =
      getIt<SecureStorageService>();

  AuthBloc() : super(const AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RefreshTokenEvent>(_onRefreshToken);
    on<CheckLoginEvent>(_onCheckLogin);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onCheckLogin(
    CheckLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    final String? token = await secureStorageService.readToken();
    final String? refreshToken = await secureStorageService.readRefreshToken();
    if (token != null && refreshToken != null) {
      try {
        add(RefreshTokenEvent(refreshToken: token));
      } catch (e) {
        await secureStorageService.deleteTokens();
        emit(const AuthInitial());
      }
    } else {
      emit(const AuthInitial());
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await secureStorageService.deleteTokens();
    emit(const AuthInitial());
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await authRepository.login(event.authRequest);

    if (result is DataSuccess && result.data != null) {
      await secureStorageService.writeToken(result.data!.accessToken);
      await secureStorageService.writeRefreshToken(result.data!.refreshToken);
      try {
        final userInfo = await getUserInfo(result.data!.accessToken);
        emit(AuthSuccess(userInfo: userInfo));
      } catch (e) {
        emit(const AuthFailure(statusCode: 500));
      }
    } else if (result is DataFailure) {
      emit(AuthFailure(statusCode: result.statusCode ?? 1));
    }
  }

  Future<void> _onRefreshToken(
    RefreshTokenEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await authRepository.refreshToken(event.refreshToken);
    if (result is DataSuccess && result.data != null) {
      await secureStorageService.writeToken(result.data!.accessToken);
      await secureStorageService.writeRefreshToken(result.data!.refreshToken);
      final userInfo = await getUserInfo(result.data!.accessToken);
      emit(AuthSuccess(userInfo: userInfo));
    } else if (result is DataFailure) {
      emit(AuthFailure(statusCode: result.statusCode ?? 1));
    }
  }

  Future<UserInfo> getUserInfo(String token) async {
    final response = await RemoteUserSource().getUserInfo(token);
    if (response is DataSuccess && response.data != null) {
      return UserInfoMapper.toEntity(response.data!);
    }
    throw Exception('Failed to get user info');
  }
}
