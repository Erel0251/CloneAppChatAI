import 'package:boilerplate/domain/entity/chat/chat.dart';

class ChatList {
  final List<ChatItem>? chats;

  ChatList({
    this.chats,
  });

  factory ChatList.fromJson(List<dynamic> json) {
    List<ChatItem> chats = <ChatItem>[];
    chats = json.map((chat) => ChatItem.fromMap(chat)).toList();

    return ChatList(
      chats: chats,
    );
  }
}
