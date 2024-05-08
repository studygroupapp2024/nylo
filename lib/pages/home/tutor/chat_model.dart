class ChatModel {
  final String userID;
  final String message;
  final DateTime timeStamp;

  ChatModel({
    required this.userID,
    required this.message,
    required this.timeStamp,
  });

  //send
  Map<String, dynamic> toMap() {
    return {
      'userid': userID,
      'message': message,
      'timestamp': timeStamp,
    };
  }

  //fetch
  static ChatModel fromMap(Map<String, dynamic> map) {
    return ChatModel(
      userID: map['userid'],
      message: map['message'],
      timeStamp: DateTime.fromMicrosecondsSinceEpoch(map['timestamp'] * 1000),
    );
  }
}
