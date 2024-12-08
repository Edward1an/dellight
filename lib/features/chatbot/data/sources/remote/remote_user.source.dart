import 'dart:convert';

import 'package:dellight/core/resources/data_state.dart';
import 'package:dellight/env.dart';
import 'package:dellight/features/chatbot/data/models/user_info.model.dart';
import 'package:http/http.dart' as http;

class RemoteUserSource {
  final String _baseUrl = EnvConfig.BASE_URL;

  Future<DataState<UserInfoModel>> getUserInfo(String token) async {
    try {
      final url = '$_baseUrl/users/me';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return DataSuccess(UserInfoModel.fromJson(jsonDecode(response.body)));
      } else {
        return DataFailure(response.statusCode);
      }
    } catch (e) {
      return const DataFailure(500);
    }
  }
}
