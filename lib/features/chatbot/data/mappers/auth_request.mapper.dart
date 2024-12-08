import 'package:dellight/features/chatbot/data/models/auth_request.model.dart';
import 'package:dellight/features/chatbot/domain/entities/auth_request.dart';

class AuthRequestMapper {
  static AuthRequest toEntity(AuthRequestModel model) {
    return AuthRequest(email: model.email, password: model.password);
  }

  static AuthRequestModel toModel(AuthRequest entity) {
    return AuthRequestModel(email: entity.email, password: entity.password);
  }
}
