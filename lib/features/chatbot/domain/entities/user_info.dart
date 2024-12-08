import 'package:equatable/equatable.dart';

class UserInfo extends Equatable {
  final String email;

  const UserInfo({required this.email});

  @override
  List<Object?> get props => [email];
}
