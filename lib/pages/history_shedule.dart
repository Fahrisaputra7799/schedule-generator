import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryShedule extends StatelessWidget {
  final List<Map<String, dynamic>> completedTasks;

  const HistoryShedule({super.key, required this.completedTasks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: completedTasks.isEmpty
          ? Center(
              child: Text(
                'Upps, Belum Ada History!',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: completedTasks.length,
              itemBuilder: (context, index) {
                final task = completedTasks[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: const Icon(Icons.check_circle, color: Colors.green),
                    title: Text(
                      task['name'],
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      "Prioritas: ${task['priority']} • Durasi: ${task['duration']} menit",
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[700]),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
