import 'package:flutter/material.dart';
import 'package:rooster/model/chat_model/chat_messagemodel.dart';

class GroupChatPage extends StatefulWidget {
  String name;
  String reciverImage;
  String time;
  //bool isMessageRead;
  GroupChatPage({
    @required this.name,
    @required this.reciverImage,
    @required this.time,
    //@required this.isMessageRead
  });

  @override
  _GroupChatPageState createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  List<GroupChatMessage> messages = [
    GroupChatMessage(
        name: "",
        messageContent:
            "Hello Guys ✌🏻✌🏻. Welcome to our group. Please to all introduce yourself 🙏🏻🙏🏻.",
        messageType: "sender",
        imageUrl: ""),
    GroupChatMessage(
        name: "Maha 😻😻",
        messageContent: "Hello All, My Name Is Maha",
        messageType: "receiver",
        imageUrl:
            "https://media.istockphoto.com/photos/chocolates-and-candles-picture-id157526954?b=1&k=20&m=157526954&s=170667a&w=0&h=cN2_nZ0Ve8Vx0ZqiclJex-YixEnoy7jGJJEEenSyvbM="),
    GroupChatMessage(
        name: "Maha 😻😻",
        messageContent: "How have you been?",
        messageType: "receiver",
        imageUrl: "https://wallpapercave.com/wp/wp6830746.jpg"),
    GroupChatMessage(
        name: "Andrey Jones",
        messageContent: "Hey Glady's, I am doing fine dude. wbu?",
        messageType: "receiver",
        imageUrl: "https://wallpapercave.com/wp/wp7538969.jpg"),
    GroupChatMessage(
        name: "John Wick",
        messageContent: "How have you been?",
        messageType: "receiver",
        imageUrl:
            "https://1.bp.blogspot.com/-f5b3esN1K-w/YUng5i7uxfI/AAAAAAAAFP4/GyrJowZjZlQcBCj09CXl5TFszSkuOWXDQCLcBGAsYHQ/s600/bike%2Bcouple%2Bphotoshoot.jpeg"),
  ];

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
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: messages.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                padding:
                    EdgeInsets.only(left: 14, right: 14, top: 8, bottom: 8),
                child: Align(
                    alignment: (messages[index].messageType == "receiver"
                        ? Alignment.topLeft
                        : Alignment.topRight),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (messages[index].messageType == "receiver"
                            ? Colors.grey.shade200
                            : Colors.blue[200]),
                      ),
                      padding: EdgeInsets.all(12),
                      child: messages[index].messageType == "receiver"
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // CircleAvatar(
                                //   backgroundImage:
                                //       NetworkImage(messages[index].imageUrl),
                                //   maxRadius: 20,
                                // ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    messages[index].name,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    messages[index].messageContent,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              messages[index].messageContent,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                    )),
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
                        messages.add(
                          GroupChatMessage(
                              messageContent: messageController.text,
                              messageType: "sender",
                              imageUrl: ""),
                        );
                        messageController.clear();
                      });
                    },
                    child: Icon(
                      Icons.flight_takeoff_rounded,
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
      ),
    );
  }
}
