import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:twilio_conversations/twilio_conversations.dart';
import 'package:twilio_conversations/user.dart';

part 'participant.freezed.dart';
part 'participant.g.dart';

@freezed
class Participant with _$Participant {
  const Participant._();

  const factory Participant({
    required String sid,
    required String conversationSid,
    String? identity,
    String? attributes,
  }) = _Participant;

  factory Participant.fromJson(Map<String, dynamic> json) =>
      _$ParticipantFromJson(json);

  Map<String, dynamic>? getAttributesAsJson() {
    if (attributes != null) {
      try {
        final result = json.decode(attributes!);

        return result;
      } catch (_) {}
    }

    return null;
  }

  Future<User?> getUser() async {
    final result = await TwilioConversations().participantApi.getUser(
          conversationSid: conversationSid,
          participantSid: sid,
        );

    if (result != null) {
      return User.fromJson(Map<String, dynamic>.from(result));
    }

    return null;
  }
}
