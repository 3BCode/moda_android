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
      throw Exception('Token tidak tersedia');
    }

    final response = await http.post(
      Uri.parse(NetworkURL.pelangganAdd()),
      headers: {
        'Authorization': '$tokenType $accessToken',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'nm_penumpang': pelanggan.nmPenumpang,
        'no_hp': pelanggan.noHp,
      }),
    );

    final responseBody = json.decode(response.body);

    if (response.statusCode == 200) {
      return responseBody;
    } else if (response.statusCode == 422) {
      // Tangani error validasi
      if (responseBody.containsKey('errors')) {
        final errors = responseBody['errors'] as Map<String, dynamic>;
        final errorMessages = <String>[];

        errors.forEach((key, value) {
          if (value is List) {
            errorMessages.addAll(value.cast<String>());
          } else if (value is String) {
            errorMessages.add(value);
          }
        });

        throw Exception(errorMessages.join('\n'));
      } else if (responseBody.containsKey('message')) {
        throw Exception(responseBody['message']);
      } else {
        throw Exception('Terjadi kesalahan validasi');
      }
    } else {
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception(
          'Terjadi kesalahan dalam permintaan: ${response.statusCode}');
    }
  }
}
