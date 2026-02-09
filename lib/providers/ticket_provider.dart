import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ticket.dart';
import '../services/gemini_service.dart';

class TicketProvider with ChangeNotifier {
  String _summary = "Belum ada ringkasan.";
  bool _isGenerating = false;

  String get summary => _summary;
  bool get isGenerating => _isGenerating;

  // Load summary terakhir dari penyimpanan lokal (Fitur Semi-Offline)
  Future<void> loadLocalSummary() async {
    final prefs = await SharedPreferences.getInstance();
    _summary = prefs.getString('last_summary') ?? "Belum ada ringkasan.";
    notifyListeners();
  }

  // Panggil Gemini & Simpan hasilnya ke lokal
  Future<void> generateAiSummary(List<Ticket> currentTickets) async {
    _isGenerating = true;
    notifyListeners();

    String result = await GeminiService().generateSummary(currentTickets);
    
    // Simpan ke lokal agar nanti bisa dibaca tanpa internet
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_summary', result);

    _summary = result;
    _isGenerating = false;
    notifyListeners();
  }
}