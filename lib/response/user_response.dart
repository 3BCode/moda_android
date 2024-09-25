import 'package:moda/model/user_model.dart';

class UserResponse {
  final Meta meta;
  final UserModel data;

  UserResponse({
    required this.meta,
    required this.data,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      meta: Meta.fromJson(json['meta']),
      data: UserModel.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meta': meta.toJson(),
      'data': data.toJson(),
    };
  }
}

class Meta {
  final int code;
  final String status;
  final String message;

  Meta({
    required this.code,
    required this.status,
    required this.message,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      code: json['code'],
      status: json['status'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'status': status,
      'message': message,
    };
  }
}
