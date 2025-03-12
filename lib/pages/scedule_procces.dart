import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schedule_generator/pages/schedule_result_page.dart';
import 'package:schedule_generator/services/gemini_service.dart';

class ScheduleProcess extends StatefulWidget {
  final List<Map<String, dynamic>> tasks;
  final VoidCallback onClearTasks;
  final Function(int) onRemoveTask;
  final Function(Map<String, dynamic>) onTaskCompleted;

  const ScheduleProcess({
    super.key,
    required this.tasks,
    required this.onClearTasks,
    required this.onRemoveTask,
    required this.onTaskCompleted,
  });

  @override
  State<ScheduleProcess> createState() => _ScheduleProcessState();
}

class _ScheduleProcessState extends State<ScheduleProcess> {
  bool _isLoading = false; // ✅ Buat indikator loading

  void _completeTask(int index) {
    final task = widget.tasks[index];
    widget.onTaskCompleted(task);
  }

  Future<void> _generateSchedule() async {
    if (widget.tasks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Tambahkan tugas terlebih dahulu!")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String result = await GeminiService.generateSchedule(widget.tasks);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScheduleResultPage(scheduleResult: result),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menghasilkan jadwal! Coba lagi.")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: widget.tasks.isEmpty
                  ? Center(
                      child: Text(
                        'Upps, Belum Ada Tugas!',
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    )
                  : ListView.builder(
                      itemCount: widget.tasks.length,
                      itemBuilder: (context, index) {
                        final task = widget.tasks[index];

                        return Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: IconButton(
                              icon: const Icon(Icons.check_circle, color: Colors.green),
                              onPressed: () => _completeTask(index),
                            ),
                            title: Text(
                              task['name'],
                              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              "Prioritas: ${task['priority']} • Durasi: ${task['duration']} menit",
                              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[700]),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => widget.onRemoveTask(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Jumlah Tugas: ${widget.tasks.length}',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _generateSchedule, // ✅ Panggil fungsi generate jadwal
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white) // ✅ Indikator loading
                      : Text(
                          'Rekomendasi Jadwal',
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
