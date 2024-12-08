import 'package:dellight/features/chatbot/data/models/auth_response.model.dart';
import 'package:dellight/features/chatbot/domain/entities/auth_response.dart';

class AuthResponseMapper {
  static AuthResponse toEntity(AuthResponseModel model) {
    return AuthResponse(
      accessToken: model.accessToken,
      refreshToken: model.refreshToken,
    );
  }

  static AuthResponseModel toModel(AuthResponse entity) {
    return AuthResponseModel(
      accessToken: entity.accessToken,
      refreshToken: entity.refreshToken,
    );
  }
}
