import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class MessageBox extends StatefulWidget {
  final String text;
  final bool isUserMessage;

  const MessageBox({super.key, required this.text, required this.isUserMessage});

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  final FlutterTts _flutterTts = FlutterTts();
  bool isListening = false;
  int _currentWordIndex = -1;
  List<String> words = [];

  @override
  void initState() {
    super.initState();
    words = widget.text.split(' ');
    _flutterTts.setCompletionHandler(() {
      if (_currentWordIndex < words.length - 1) {
        setState(() {
          _currentWordIndex++;
        });
        _speak(words[_currentWordIndex]);
      } else {
        setState(() {
          isListening = false;
          _currentWordIndex = -1;
        });
      }
    });

    _flutterTts.setStartHandler(() {
      setState(() {
        isListening = true;
      });
    });

    _flutterTts.setErrorHandler((msg) {
      setState(() {
        isListening = false;
      });
    });

   _flutterTts.setSharedInstance(true);
    _flutterTts.setIosAudioCategory(IosTextToSpeechAudioCategory.ambient,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers
        ],
        IosTextToSpeechAudioMode.voicePrompt
    );

  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMessageText(context),
            const SizedBox(height: 10.0),
            _buildToolBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildToolBar() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildPlayVoice(),
        const SizedBox(width: 35.0),
        _buildTranslate(),
      ],
    );
  }

  Widget _buildPlayVoice() {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isListening) {
            _flutterTts.stop();
          } else {
            _currentWordIndex = 0;
            _speak(words[_currentWordIndex]);
          }
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isListening
              ? const Icon(Icons.pause, size: 20,)
              : const Icon(Icons.volume_up_rounded, size: 20,),
          const SizedBox(width: 5),
          Text(isListening ? 'Stop' : 'Play', style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildTranslate() {
    return GestureDetector(
      onTap: () {
        setState(() {
          // Tạm thời chỉ để toggle qua lại
        });
      },
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.translate, size: 18,),
          SizedBox(width: 5),
          Text('Translate', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildMessageText(BuildContext context) {
    List<TextSpan> textSpans = words.asMap().entries.map((entry) {
      int index = entry.key;
      String word = entry.value;
      return TextSpan(
        text: '$word ',
        style: TextStyle(
          color: _currentWordIndex == index ? Colors.blue : Colors.black,
          fontWeight: _currentWordIndex == index ? FontWeight.bold : FontWeight.normal,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () => _showWordDetails(context, word),
      );
    }).toList();

    return RichText(
      text: TextSpan(children: textSpans),
    );
  }

  void _speak(String word) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.4);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(word);
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
