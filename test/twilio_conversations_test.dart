import 'package:flutter_test/flutter_test.dart';
import 'package:twilio_conversations/twilio_conversations.dart';
import 'package:twilio_conversations/twilio_conversations_platform_interface.dart';
import 'package:twilio_conversations/twilio_conversations_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTwilioConversationsPlatform
    with MockPlatformInterfaceMixin
    implements TwilioConversationsPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final TwilioConversationsPlatform initialPlatform = TwilioConversationsPlatform.instance;

  test('$MethodChannelTwilioConversations is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTwilioConversations>());
  });

  test('getPlatformVersion', () async {
    TwilioConversations twilioConversationsPlugin = TwilioConversations();
    MockTwilioConversationsPlatform fakePlatform = MockTwilioConversationsPlatform();
    TwilioConversationsPlatform.instance = fakePlatform;

    expect(await twilioConversationsPlugin.getPlatformVersion(), '42');
  });
}
