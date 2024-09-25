import 'dart:convert';

import 'package:moda/network/network.dart';
import 'package:moda/preferences_manager/preferences_manager.dart';
import 'package:moda/response/tiket_response.dart';
import 'package:http/http.dart' as http;

class ApiTiketService {
  Future<TiketResponse> fetchTikets(int page) async {
    final prefs = await PreferencesManager.getUserPreferences();
    final tokenType = prefs['tokenType'];
    final accessToken = prefs['accessToken'];

    if (tokenType == null || accessToken == null) {
      throw Exception('Token is not available');
    }

    final response = await http.get(
      Uri.parse(NetworkURL.getTiket(page)),
      headers: {
        'Authorization': '$tokenType $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print(responseBody);
      return TiketResponse.fromJson(responseBody['data']);
    } else {
      throw Exception('Failed to load tikets');
    }
  }
}
