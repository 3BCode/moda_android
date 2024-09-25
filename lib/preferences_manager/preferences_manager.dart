import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {
  static Future<Map<String, String>> getUserPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    int? idValue = preferences.getInt("id");
    int? loketIdValue = preferences.getInt("loketId");
    String? nameValue = preferences.getString("name");
    String? emailValue = preferences.getString("email");
    String? levelValue = preferences.getString("level");
    String? namaLoketValue = preferences.getString("namaLoket");
    String? accessTokenValue = preferences.getString("accessToken");
    String? tokenTypeValue = preferences.getString("tokenType");

    // Tambahkan pernyataan print untuk debugging
    print('Data yang diambil dari SharedPreferences:');
    print('ID: $idValue');
    print('Loket ID: $loketIdValue');
    print('Name: $nameValue');
    print('Email: $emailValue');
    print('Level: $levelValue');
    print('Nama Loket: $namaLoketValue');
    print('Access Token: $accessTokenValue');
    print('Token Type: $tokenTypeValue');

    return {
      'id': idValue?.toString() ?? "",
      'loketId': loketIdValue?.toString() ?? "",
      'name': nameValue ?? "",
      'email': emailValue ?? "",
      'level': levelValue ?? "",
      'namaLoket': namaLoketValue ?? "",
      'accessToken': accessTokenValue ?? "",
      'tokenType': tokenTypeValue ?? "",
    };
  }
}
