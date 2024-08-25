import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiApiService {
  final GenerativeModel _model;

  GeminiApiService({required String apiKey})
      : _model = GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: apiKey);

  Future<String> sendMessage(String message) async {
    try {
      final ChatSession session = _model.startChat();
      final response = await session.sendMessage(Content.text(message));
      return response.text ?? 'No response from AI';
    } catch (e) {
      throw Exception('Error communicating with AI: $e');
    }
  }
}
