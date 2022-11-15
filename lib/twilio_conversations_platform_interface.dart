import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'twilio_conversations_method_channel.dart';

abstract class TwilioConversationsPlatform extends PlatformInterface {
  /// Constructs a TwilioConversationsPlatform.
  TwilioConversationsPlatform() : super(token: _token);

  static final Object _token = Object();

  static TwilioConversationsPlatform _instance =
      MethodChannelTwilioConversations();

  /// The default instance of [TwilioConversationsPlatform] to use.
  ///
  /// Defaults to [MethodChannelTwilioConversations].
  static TwilioConversationsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TwilioConversationsPlatform] when
  /// they register themselves.
  static set instance(TwilioConversationsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool?> initClient(String token) {
    throw UnimplementedError('initClient() has not been implemented.');
  }

  Future<bool?> shutdown() {
    throw UnimplementedError('shutdown() has not been implemented.');
  }

  Future<List?> myConversations() {
    throw UnimplementedError('myConversations() has not been implemented.');
  }

  Future<Map?> getMessageByIndex(String sid, int index) {
    throw UnimplementedError('getMessageByIndex() has not been implemented.');
  }

  Future<Map?> getConversation(String sid) {
    throw UnimplementedError('getConversation() has not been implemented.');
  }

  Future<int?> getMessagesCount(String sid) {
    throw UnimplementedError('getMessagesCount() has not been implemented.');
  }

  Future<int?> getUnreadMessagesCount(String sid) {
    throw UnimplementedError(
        'getUnreadMessagesCount() has not been implemented.');
  }

  Future<int?> setAllMessagesRead(String sid) {
    throw UnimplementedError('setAllMessagesRead() has not been implemented.');
  }

  Future<List?> getMessages(String sid) {
    throw UnimplementedError('getMessages() has not been implemented.');
  }

  Future<String?> getTemporaryContentUrlForMediaSid(String sid) {
    throw UnimplementedError(
        'getTemporaryContentUrlForMediaSid() has not been implemented.');
  }

  Future sendMessage({
    required String conversationSid,
    String? body,
    String? path,
    String? mimeType,
    Map<String, dynamic>? attributes,
  }) {
    throw UnimplementedError('sendMessage() has not been implemented.');
  }

  Future<bool?> getConversationUserIsOnline(String sid) {
    throw UnimplementedError(
        'getConversationUserIsOnline() has not been implemented.');
  }

  Stream<Map> getTwilioConversationsStream() {
    throw UnimplementedError(
        'getTwilioConversationsStream() has not been implemented.');
  }

  Future typing(String sid) {
    throw UnimplementedError('typing() has not been implemented.');
  }

  Future registerFCMToken(String token) {
    throw UnimplementedError('registerFCMToken() has not been implemented.');
  }

  Future registerAPNToken(String token) {
    throw UnimplementedError('registerAPNToken() has not been implemented.');
  }
}
