// lib/providers/ticket_provider.dart
import 'package:flutter/material.dart';
import '../services/gemini_service.dart';
import '../models/ticket.dart';
import '../services/firestore_service.dart';

class TicketProvider with ChangeNotifier {
  final GeminiService _geminiService = GeminiService();
  final FirestoreService _firestoreService = FirestoreService();

  // Local list to store tickets
  List<Ticket> _tickets = [];
  List<Ticket> get tickets => _tickets;

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

  Future<void> removeTicket(String ticketId) async {
    await _firestoreService.deleteTicket(ticketId);
    _tickets.removeWhere((ticket) => ticket.id == ticketId);
    notifyListeners();
  }
}
