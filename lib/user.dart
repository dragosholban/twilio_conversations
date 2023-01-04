import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const User._();

  const factory User({
    String? identity,
    String? friendlyName,
    String? attributes,
    bool? isOnline,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic>? getAttributesAsJson() {
    if (attributes != null) {
      try {
        final result = json.decode(attributes!);

        return result;
      } catch (_) {}
    }

    return null;
  }
}
