import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String apiKey = 'MASUKKAN_API_KEY_GEMINI_ANDA_DISINI';

  Future<String> summarizeTask(String title, String description) async {
    try {
      final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
      final prompt =
          "Buatlah ringkasan singkat dan padat dari tugas berikut ini dalam bahasa Indonesia.\n\nJudul: $title\nDeskripsi: $description";

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      return response.text ?? "Gagal mendapatkan ringkasan.";
    } catch (e) {
      return "Terjadi kesalahan: $e";
    }
  }
}
