import 'package:dellight/features/chatbot/data/models/user_info.model.dart';
import 'package:dellight/features/chatbot/domain/entities/user_info.dart';

class UserInfoMapper {
  static UserInfo toEntity(UserInfoModel model) {
    return UserInfo(email: model.email);
  }

  static UserInfoModel toModel(UserInfo entity) {
    return UserInfoModel(email: entity.email);
  }
}
