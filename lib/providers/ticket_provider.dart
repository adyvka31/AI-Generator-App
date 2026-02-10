import 'package:flutter/material.dart';
import '../services/gemini_service.dart';

class TicketProvider with ChangeNotifier {
  final GeminiService _geminiService = GeminiService();
  bool _isSummarizing = false;
  bool get isSummarizing => _isSummarizing;
  String _summary = "No summary generated yet.";
  String get summary => _summary;

  Future<String> getAiSummary(String title, String description) async {
    _isSummarizing = true;
    notifyListeners();

    final result = await _geminiService.summarizeTask(title, description);
    _summary = result;

    _isSummarizing = false;
    notifyListeners();
    return result;
  }
}
