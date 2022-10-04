import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:twilio_conversations/twilio_conversations_platform_interface.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
class Message with _$Message {
  const Message._();

  const factory Message({
    required String sid,
    String? body,
    String? lastMessageDate,
    String? participantIdentity,
    DateTime? dateCreated,
    @Default(false) bool hasMedia,
    @Default([]) List<String> mediaSids,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  factory Message.fromMap(Map map) {
    final List<String> mediaSids = [];
    for (final media in map['attachedMedia'] ?? []) {
      mediaSids.add(media['mediaSid']);
    }

    final message = Message(
      sid: map['messageSid'],
      body: map['messageBody'],
      dateCreated: DateTime.parse(map['date']),
      participantIdentity: map['participantIdentity'],
      hasMedia: map['hasMedia'] ?? false,
      mediaSids: mediaSids,
    );

    return message;
  }

  Future<String?> getTemporaryContentUrlForMediaSid(String sid) {
    return TwilioConversationsPlatform.instance
        .getTemporaryContentUrlForMediaSid(sid);
  }
}
