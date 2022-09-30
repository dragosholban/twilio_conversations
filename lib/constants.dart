enum ClientSyncStatus { started, listCompleted, completed, failed }

abstract class ConversationEvents {
  static String clientSynchronizationStatusUpdated =
      'clientSynchronizationStatusUpdated';
  static String conversationAdded = 'conversationAdded';
  static String messageAdded = 'messageAdded';
  static String participantUpdated = 'participantUpdated';
}
