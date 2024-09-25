import 'dart:convert';

import 'package:moda/network/network.dart';
import 'package:moda/preferences_manager/preferences_manager.dart';
import 'package:moda/response/karyawan_response.dart';
import 'package:http/http.dart' as http;

class ApiKaryawanService {
  Future<KaryawanResponse> fetchKaryawans(int page) async {
    final prefs = await PreferencesManager.getUserPreferences();
    final tokenType = prefs['tokenType'];
    final accessToken = prefs['accessToken'];

    if (tokenType == null || accessToken == null) {
      throw Exception('Token is not available');
    }

    final response = await http.get(
      Uri.parse(NetworkURL.getKaryawan(page)),
      headers: {
        'Authorization': '$tokenType $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print(responseBody);
      return KaryawanResponse.fromJson(responseBody['data']);
    } else {
      throw Exception('Failed to load karyawans');
    }
  }
}
