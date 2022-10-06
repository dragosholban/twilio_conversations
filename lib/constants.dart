enum ClientSyncStatus { started, listCompleted, completed, failed }

abstract class ConversationEvents {
  static const String clientSynchronizationStatusUpdated =
      'clientSynchronizationStatusUpdated';
  static const String conversationAdded = 'conversationAdded';
  static const String messageAdded = 'messageAdded';
  static const String participantUpdated = 'participantUpdated';
  static const String userUpdated = 'userUpdated';
  static const String typingStarted = 'typingStarted';
  static const String typingEnded = 'typingEnded';
}
