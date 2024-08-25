import 'package:flutter/material.dart';
import '../repository/gemini_repository.dart';
import '../service/gemini_api_service.dart';
import 'message_box.dart';
import '../secrets.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final GeminiRepository _repository;

  @override
  void initState() {
    super.initState();
    _messages.add({'text': 'Hello!', 'sender': 'AI'});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
    final apiService = GeminiApiService(apiKey: geminiApiKey);
    _repository = GeminiRepositoryImpl(apiService: apiService);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmitted(String text) async {
    if (text.isEmpty) return;
    final response = await _repository.sendMessage(text);
    print(response);
    _controller.clear();

    setState(() {
      _messages.add({'text': text, 'sender': 'User'});
      _messages.add({'text': response, 'sender': 'AI'});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
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
      controller: _scrollController,
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
