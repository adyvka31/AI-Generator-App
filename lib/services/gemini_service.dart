import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/ticket.dart';

class GeminiService {
  static const String apiKey = 'MASUKKAN_API_KEY_GEMINI_ANDA_DISINI';

  Future<String> generateSummary(List<Ticket> tickets) async {
    if (tickets.isEmpty) return "Tidak ada data untuk diringkas.";

    final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
    
    String dataPrompt = tickets.map((t) => "- ${t.title} (${t.status}): ${t.description}").join("\n");
    
    final content = [
      Content.text('Sebagai Project Manager, buat ringkasan progres singkat bahasa Indonesia dari task berikut:\n\n$dataPrompt')
    ];

    try {
      final response = await model.generateContent(content);
      return response.text ?? "Gagal merangkum.";
    } catch (e) {
      return "Gagal koneksi AI: Pastikan ada internet.";
    }
  }
}