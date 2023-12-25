import 'dart:math';
import 'dart:convert';
import 'package:boilerplate/presentation/history/history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:dart_openai/dart_openai.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}
String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class _ChatScreenState extends State<ChatScreen> {
  //final _chatController = ChatController();

  final List<OpenAIChatCompletionChoiceMessageModel> _historychat = [];
  final List<types.Message> _messages = [];
  final _user = const types.User(id: '1');
  final _agent = const types.User(id: '2');

  //stores:---------------------------------------------------------------------

  @override
  // Screen initiation
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Observer(
        builder: (_) {
          return _buildBody();
        },
      ),
      drawer: HistorySectionScreen(),
      );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black12,
      foregroundColor: Colors.white,
      title: Text('Chat'),
      centerTitle: true,
      actions: [
        _settingButton(),
      ],
    );
  }

  // body: contain an mini appbar to choose role of AI Agent
  // and a listview of chat history
  Widget _buildBody() {
    return Container(
      child: Column(
        children: [
          _buildMiniAppBar(),
          _buildChatBox(),
        ],
      ),
    );
  }

  // Mini appbar contain an text attached with
  // a dropdown options button to choose models in chatbox
  Widget _buildMiniAppBar() {
    return Container(
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          Text('Select models: '),
          AsyncDropdownButton(),
        ],
      ),
    );
  }

  // Async dropdown button: contain a dropdown button
  // to choose models async from listModel()
  Widget AsyncDropdownButton() {
    return FutureBuilder(
      future: listModel(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DropdownButton(
            value: snapshot.data![0],
            onChanged: (value) {
              // _chatController.changeModel(value);
            },
            items: snapshot.data!.map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  // chat history: contain a listview of chat item
  // with avatar and message, chat of user float to the right
  // and chat of AI Agent float to the left
  Widget _buildChatBox() {
    return Expanded(
      child: Chat(
        messages: _messages.map((e) => e).toList(),
        onSendPressed: _handleSendPressed,
        user: _user,
      ),
    );
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText message) async {
    final user_m = types.TextMessage( author: _user,
      id: randomString(),
      text: message.text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    _addMessage(user_m);

    String response = await _openAIResponse(message.text);

    final agent_m = types.TextMessage(
      author: _agent,
      id: randomString(),
      text: response.toString(),
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    _addMessage(agent_m);
  }


  Widget _settingButton() {
    return Observer(
      builder: (context) {
        return IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            //Navigator.pushNamed(context, Routes.settings);
          },
        );
      },
    );
  }

  // return list of model AI
  Future<List<String>> listModel() async {
    final List<OpenAIModelModel> models = await OpenAI.instance.model.list();
    List<String> result = [];
    for(var model in models) {
      result.add(model.id);
    }
    result.sort();

    return result;
  }

  Future<String> _openAIResponse(String message) async {
    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      role: OpenAIChatMessageRole.user,
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(message)
      ],
    );

    _historychat.add(userMessage);

    final chatCompletion = await OpenAI.instance.chat.create(
      model: 'gpt-3.5-turbo-1106',
      n: 1,
      messages: _historychat,
    );

    String response = chatCompletion.choices.first.message.content![0].text!;

    _historychat.add(OpenAIChatCompletionChoiceMessageModel(
      role: OpenAIChatMessageRole.assistant,
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(response)
      ]
    ));
    // or content: chatCompletion.choices.first.message.content

    return response;
  }
}
