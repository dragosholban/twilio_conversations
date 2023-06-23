import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:twilio_conversations/participant.dart';
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
    DateTime? dateCreated,
    int? messageIndex,
    @Default(false) bool hasMedia,
    @Default([]) List<Map<String, String>> medias,
    String? attributes,
    Participant? participant,
    String? author,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  factory Message.fromMap(Map map) {
    final List<Map<String, String>> medias = [];
    for (final media in map['attachedMedia'] ?? []) {
      medias.add({
        'sid': media['mediaSid'],
        'contentType': media['mediaContentType'],
      });
    }

    Participant? participant;
    if (map['participant.sid'] != null &&
        map['participant.conversationSid'] != null) {
      participant = Participant(
        sid: map['participant.sid'],
        conversationSid: map['participant.conversationSid'],
        identity: map['participant.identity'],
        attributes: map['participant.attributes'],
      );
    }

    final message = Message(
      sid: map['sid'],
      body: map['body'],
      dateCreated: DateTime.parse(map['dateCreated']),
      messageIndex: map['messageIndex'],
      hasMedia: map['hasMedia'] ?? false,
      medias: medias,
      attributes: map['attributes'],
      participant: participant,
      author: map['author'],
    );

    return message;
  }

  Future<String?> getTemporaryContentUrlForMediaSid(String sid) {
    return TwilioConversationsPlatform.instance
        .getTemporaryContentUrlForMediaSid(sid);
  }

  Future setAttribute(
    String conversationSid,
    int messageIndex,
    String attributeName,
    dynamic attributeValue,
  ) {
    return TwilioConversationsPlatform.instance.setAttributeForMessage(
      conversationSid,
      messageIndex,
      attributeName,
      attributeValue,
    );
  }
}
