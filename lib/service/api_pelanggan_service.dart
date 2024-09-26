import 'dart:convert';

import 'package:moda/model/pelanggan_model.dart';
import 'package:moda/network/network.dart';
import 'package:moda/preferences_manager/preferences_manager.dart';
import 'package:moda/response/pelanggan_response.dart';
import 'package:http/http.dart' as http;

class ApiPelangganService {
  Future<PelangganResponse> fetchPelanggans(int page) async {
    final prefs = await PreferencesManager.getUserPreferences();
    final tokenType = prefs['tokenType'];
    final accessToken = prefs['accessToken'];

    if (tokenType == null || accessToken == null) {
      throw Exception('Token is not available');
    }

    final response = await http.get(
      Uri.parse(NetworkURL.getPelanggan(page)),
      headers: {
        'Authorization': '$tokenType $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print(responseBody);
      return PelangganResponse.fromJson(responseBody['data']);
    } else {
      throw Exception('Failed to load pelanggans');
    }
  }

  Future<Map<String, dynamic>> createPelanggan(PelangganModel pelanggan) async {
    final prefs = await PreferencesManager.getUserPreferences();
    final tokenType = prefs['tokenType'];
    final accessToken = prefs['accessToken'];

    if (tokenType == null || accessToken == null) {
      throw Exception('Token is not available');
    }

    final response = await http.post(
      Uri.parse(NetworkURL.pelangganAdd()),
      headers: {
        'Authorization': '$tokenType $accessToken',
        'Content-Type': 'application/json',
      },
      body: json.encode(pelanggan.toJson()),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create pelanggan');
    }
  }
}
