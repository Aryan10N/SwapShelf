class ChatUser {
  final String id;
  final String name;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String? bookTitle;
  final bool isOnline;

  ChatUser({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.lastMessageTime,
    this.bookTitle,
    this.isOnline = false,
  });
}

class ChatMessage {
  final String message;
  final bool isMe;
  final DateTime timestamp;

  ChatMessage({
    required this.message,
    required this.isMe,
    required this.timestamp,
  });
} 