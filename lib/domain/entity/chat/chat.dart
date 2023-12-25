class ChatItem {
  final int id;
  final String name;
  final String message;
  final String time;

  ChatItem(
      {required this.id,
      required this.name,
      required this.message,
      required this.time});

  factory ChatItem.fromMap(Map<String, dynamic> json) => ChatItem(
        id: json['id'],
        name: json['name'],
        message: json['message'],
        time: json['time'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'message': message,
      'time': time,
    };
  }
}
