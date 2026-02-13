import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String apiKey = 'AIzaSyDeSpzKlk89_lOONWPl-zeaoUikHQ4HlMM';

  Future<String> summarizeTask(
    String title,
    String description, {
    String? customPrompt,
  }) async {
    try {
      // PERBAIKAN UTAMA: Gunakan prefix 'models/' dan pastikan apiKey benar.
      // Jika SDK Anda tetap memaksa v1beta, kita gunakan 'gemini-1.5-flash-latest'
      final model = GenerativeModel(
        model: 'gemini-flash-latest',
        apiKey: apiKey,
      );

      final basePrompt =
          "Berdasarkan tugas berikut:\nJudul: $title\nDeskripsi: $description\n\n";
      final instruction =
          customPrompt ??
          "Buatlah ringkasan detail dan padat dalam bahasa Indonesia.";
      final finalPrompt = "$basePrompt Instruksi pengguna: $instruction";

      final content = [Content.text(finalPrompt)];
      final response = await model.generateContent(content);

      return response.text ?? "Gagal mendapatkan jawaban.";
    } catch (e) {
      // Jika terjadi error model not found, gunakan alternatif penamaan ini:
      try {
        final fallbackModel = GenerativeModel(
          model: 'gemini-pro', // Model paling stabil untuk API v1
          apiKey: apiKey,
        );

        final prompt = "Ringkas tugas ini: $title. Deskripsi: $description";
        final response = await fallbackModel.generateContent([
          Content.text(prompt),
        ]);

        return response.text ?? "Gagal mendapatkan jawaban.";
      } catch (fallbackError) {
        return "Terjadi kesalahan: $e";
      }
    }
  }
}
