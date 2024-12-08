import 'package:equatable/equatable.dart';

class UserInfoModel extends Equatable {
  final String email;

  const UserInfoModel({required this.email});

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(email: json['email']);
  }

  Map<String, dynamic> toJson() {
    return {'email': email};
  }

  @override
  List<Object?> get props => [email];
}
