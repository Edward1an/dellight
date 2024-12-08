import 'dart:convert';

import 'package:dellight/core/resources/data_state.dart';
import 'package:dellight/env.dart';
import 'package:dellight/features/chatbot/data/models/auth_request.model.dart';
import 'package:dellight/features/chatbot/data/models/auth_response.model.dart';
import 'package:http/http.dart' as http;

class RemoteAuthSource {
  final http.Client client;
  final String _baseUrl = EnvConfig.BASE_URL;

  RemoteAuthSource({required this.client});
  Future<DataState<AuthResponseModel>> login(
    AuthRequestModel request,
  ) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return DataSuccess(AuthResponseModel.fromJson(jsonDecode(response.body)));
    } else {
      return DataFailure(response.statusCode);
    }
  }

  Future<DataState<AuthResponseModel>> refreshToken(String refreshToken) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/auth/refreshToken'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $refreshToken',
      },
    );
    if (response.statusCode == 200) {
      return DataSuccess(AuthResponseModel.fromJson(jsonDecode(response.body)));
    } else {
      return DataFailure(response.statusCode);
    }
  }
}
