// lib/providers/ticket_provider.dart
import 'package:flutter/material.dart';
import '../services/gemini_service.dart';
import '../models/ticket.dart';

class TicketProvider with ChangeNotifier {
  final GeminiService _geminiService = GeminiService();

  bool _isSummarizing = false;
  bool get isSummarizing => _isSummarizing;

  String _summary = "";
  String get summary => _summary;

  Future<void> getAiSummary(
    String title,
    String description, {
    String? userPrompt,
  }) async {
    _isSummarizing = true;
    _summary = "";
    notifyListeners();

    final result = await _geminiService.summarizeTask(
      title,
      description,
      customPrompt: userPrompt,
    );
    _summary = result;

    _isSummarizing = false;
    notifyListeners();
  }
}
