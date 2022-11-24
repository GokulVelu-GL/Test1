import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rooster/model/chat_model/chat_messagemodel.dart';

class ChatDetailPage extends StatefulWidget {
  String name;
  String reciverImage;
  String time;
  //bool isMessageRead;
  ChatDetailPage({
    @required this.name,
    @required this.reciverImage,
    @required this.time,
    //@required this.isMessageRead
  });

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  MessageList _chatMessage;
  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = new TextEditingController();
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.reciverImage),
                    maxRadius: 20,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.name,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          widget.time,
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.settings,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Consumer<MessageList>(builder: (context, userChatMessage, child) {
          //print(_chatMessage.messages);
          List<ChatMessage> _chatMessage =
              userChatMessage.messages["Maha 😻😻," + widget.name] == null
                  ? []
                  : userChatMessage.messages["Maha 😻😻," + widget.name];
          print(_chatMessage);
          return Stack(
            children: <Widget>[
              ListView.builder(
                itemCount: _chatMessage.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 10, bottom: 10),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    padding:
                        EdgeInsets.only(left: 14, right: 14, top: 8, bottom: 8),
                    child: Align(
                      alignment: (_chatMessage[index].messageType == "receiver"
                          ? Alignment.topLeft
                          : Alignment.topRight),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (_chatMessage[index].messageType == "receiver"
                              ? Colors.grey.shade200
                              : Colors.blue[200]),
                        ),
                        padding: EdgeInsets.all(12),
                        child: Text(
                          _chatMessage[index].messageContent,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  height: 60,
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                              hintText: "Write message...",
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            userChatMessage.messages["Maha 😻😻," + widget.name]
                                .add(
                              ChatMessage(
                                  messageContent: messageController.text,
                                  messageType: "sender"),
                            );
                            // userChatMessage.messages[widget.name + ",Maha 😻😻"]
                            //     .add(
                            //   ChatMessage(
                            //       messageContent: messageController.text,
                            //       messageType: "receiver"),
                            // );
                            messageController.clear();
                          });
                        },
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                        backgroundColor: Colors.blue,
                        elevation: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }));
  }
}
