import 'package:boilerplate/core/widgets/rounded_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class HistorySectionScreen extends StatefulWidget {
  @override
  State<HistorySectionScreen> createState() => _HistorySectionScreenState();
}

class _HistorySectionScreenState extends State<HistorySectionScreen> {
  //final _chatController = ChatController();

  //stores:---------------------------------------------------------------------

  // Widget Drawer with 2 part
  // History list on the up top
  // New Chat button on the bottom
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _historyList(),
        _newChatSection(),
      ],
    );
  }

  // History List contains the list of all the stream chats that the user has
  // each listitem is a widgets
  Widget _historyList() {
    return Column(
        children: [
          _title(),
          _historyListItem(),
          _historyListItem(),
          _historyListItem(),
        ],
    );
  }

  Widget _title() {
    return Container(
      height: 50,
      child: Center(
        child: Text('Chat History'),
      ),
    );
  }

  // listItem that is a button contains first message of the chat
  // and the delete listItem button float to the right
  Widget _historyListItem() {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('First Message'),
          _historyListItemDeleteButton(),
        ],
      ),
    );
  }

  // delete button for each listItem
  Widget _historyListItemDeleteButton() {
    return IconButton(
      icon: Icon(Icons.delete),
      onPressed: () {},
    );
  }

  Widget _newChatSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _newChatButton(),
        Text('Version: 1.0.0'),
      ],
    );
  }

  Widget _newChatButton() {
    return Observer(
      builder: (context) {
      return RoundedButtonWidget(
        buttonText: 'New Chat',
        buttonColor: Colors.orangeAccent,
        textColor: Colors.white,
        onPressed: () {},
        );
      },
    );
  }
}
