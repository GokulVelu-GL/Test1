import 'package:flutter/material.dart';
import 'package:rooster/model/chat_model/chat_user.dart';
import 'package:rooster/ui/GroupChart/conversationList.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatUsers> chatUsers = [
    ChatUsers(
      name: "Jane Russel",
      messageText: "Awesome Setup",
      imageURL:
          "https://media.istockphoto.com/photos/chocolates-and-candles-picture-id157526954?b=1&k=20&m=157526954&s=170667a&w=0&h=cN2_nZ0Ve8Vx0ZqiclJex-YixEnoy7jGJJEEenSyvbM=",
      time: "Now",
      isGroup: false,
    ),
    ChatUsers(
      name: "Glady's Murphy",
      messageText: "That's Great",
      imageURL: "https://wallpapercave.com/wp/wp6830746.jpg",
      time: "Yesterday",
      isGroup: false,
    ),
    ChatUsers(
      name: "Maha 😻😻",
      messageText: "Hey where are you?",
      imageURL: "https://wallpapercave.com/wp/wp7538969.jpg",
      time: "31 Mar",
      isGroup: false,
    ),
    ChatUsers(
      name: "Andrey Jones",
      messageText: "Can you please share the file?",
      imageURL:
          "https://www.sheymarinphotography.com/website/wp-content/uploads/2013/04/tenley_0384.jpg",
      time: "24 Feb",
      isGroup: false,
    ),
    ChatUsers(
      name: "John Wick",
      messageText: "How are you?",
      imageURL:
          "https://1.bp.blogspot.com/-f5b3esN1K-w/YUng5i7uxfI/AAAAAAAAFP4/GyrJowZjZlQcBCj09CXl5TFszSkuOWXDQCLcBGAsYHQ/s600/bike%2Bcouple%2Bphotoshoot.jpeg",
      time: "18 Feb",
      isGroup: false,
    ),
    ChatUsers(
      name: "AirCargo eAWB team",
      messageText: "How are you?",
      imageURL: "https://wallpaperaccess.com/full/900018.jpg",
      time: "now",
      isGroup: true,
    ),
    ChatUsers(
      name: "Ground handling team",
      messageText: "Check now",
      imageURL:
          "https://www.aircargonews.net/wp-content/uploads/2020/04/shutterstock_651052612.jpg",
      time: "18 Feb",
      isGroup: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "ChatBox",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Theme.of(context).primaryColorLight,
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.add,
                            color: Theme.of(context).accentColor,
                            size: 20,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            "Add New",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey.shade100)),
                ),
              ),
            ),
            ListView.builder(
              itemCount: chatUsers.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ConversationList(
                  name: chatUsers[index].name,
                  messageText: chatUsers[index].messageText,
                  imageUrl: chatUsers[index].imageURL,
                  time: chatUsers[index].time,
                  isMessageRead: (index == 0 || index == 3) ? true : false,
                  isGroup: chatUsers[index].isGroup,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
