import 'package:flutter/cupertino.dart';

class ChatMessage {
  String messageContent;
  String messageType;
  ChatMessage({@required this.messageContent, @required this.messageType});
}

class MessageList with ChangeNotifier {
  Map<String, List<ChatMessage>> messages = {
    "Maha 😻😻,Maha 😻😻": [
      ChatMessage(messageContent: "Hello, Will", messageType: "receiver"),
      ChatMessage(
          messageContent: "How have you been?", messageType: "receiver"),
    ],
    "Maha 😻😻,Glady's Murphy": [
      ChatMessage(
          messageContent: "Hey Glady's, I am doing fine dude. wbu?",
          messageType: "sender"),
      ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
      ChatMessage(
          messageContent: "Is there any thing wrong?", messageType: "sender")
    ]
  };
}

class GroupChatMessage {
  String name;
  String imageUrl;
  String messageContent;
  String messageType;
  GroupChatMessage(
      {@required this.name,
      @required this.imageUrl,
      @required this.messageContent,
      @required this.messageType});
}
