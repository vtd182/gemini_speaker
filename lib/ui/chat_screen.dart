import 'package:flutter/material.dart';

import 'message_box.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _messages.add({'text': 'Hello!', 'sender': 'AI'});
  }
  void _handleSubmitted(String text) {
    if (text.isEmpty) return;
    _controller.clear();

    setState(() {
      _messages.add({'text': text, 'sender': 'User'});
      _messages.add({'text': 'AI Response to "$text"', 'sender': 'AI'});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gemini Speaker'),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Column(
            children: [
              Expanded(
                child: _buildBodyPage(),
              ),
              _buildTextInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBodyPage() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return MessageBox(
          text: message['text'],
          isUserMessage: message['sender'] == 'User',
        );
      },
    );
  }

  Widget _buildTextInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: _handleSubmitted,
              decoration: const InputDecoration.collapsed(hintText: "Send a message"),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _handleSubmitted(_controller.text),
          ),
        ],
      ),
    );
  }
}
