
class History {
  static int total = 0;
  final int id = History.total;
  final String fistMessage;

  History({required this.fistMessage}){
    History.total += 1;
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fistMessage': fistMessage,
    };
  }
}
