import '../service/gemini_api_service.dart';

abstract class GeminiRepository {
  Future<String> sendMessage(String message);
}

class GeminiRepositoryImpl implements GeminiRepository {
  final GeminiApiService apiService;

  GeminiRepositoryImpl({required this.apiService});

  @override
  Future<String> sendMessage(String message) async {
    return await apiService.sendMessage(message);
  }
}
