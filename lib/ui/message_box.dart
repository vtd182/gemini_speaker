import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class MessageBox extends StatefulWidget {
  final String text;
  final bool isUserMessage;

  const MessageBox({super.key, required this.text, required this.isUserMessage});

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: widget.isUserMessage ? Colors.blue[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: _buildMessageText(context),
      ),
    );
  }

  Widget _buildMessageText(BuildContext context) {
    List<TextSpan> textSpans = widget.text.split(' ').map((word) {
      return TextSpan(
        text: '$word ',
        style: const TextStyle(color: Colors.black),
        recognizer: TapGestureRecognizer()
          ..onTap = () => _showWordDetails(context, word),
      );
    }).toList();

    return RichText(
      text: TextSpan(children: textSpans),
    );
  }

  void _showWordDetails(BuildContext context, String word) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'You tapped on: $word',
                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              Text(
                'Here you can add more details or actions related to the word "$word".',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
