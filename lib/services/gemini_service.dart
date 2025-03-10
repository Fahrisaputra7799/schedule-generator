import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String apiKey = "AIzaSyDYSnPZbCTsAQie6Dbg6Kn-XkAf86Vo8D4";
  static const String baseUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent";

  static Future<String> generateSchedule(
      List<Map<String, dynamic>> tasks) async {
    final prompt = _buildPrompt(tasks);

    final response = await http.post(
      Uri.parse('$baseUrl?key=$apiKey'),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["candidates"][0]["content"]["parts"][0]["text"];
    } else {
      throw Exception("Gagal menghasilkan jadwal: ${response.body}");
    }
  }

  static String _buildPrompt(List<Map<String, dynamic>> tasks) {
    String taskList = tasks
        .map((task) =>
            "- ${task['name']} (Prioritas: ${task['priority']}, Durasi: ${task['duration']} menit, Deadline: ${task['deadline']})")
        .join("\n");

    return "Berikan Saya Rekomendasi Jadwal Yang Bagus Dan Efisien Untuk Menyelesaikan Tugas Berikut: \n$taskList\nSusun jadwal dari pagi hingga malam dengan efisien.";
  }
}
