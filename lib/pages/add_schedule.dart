import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddSchedule extends StatefulWidget {
  final Function(Map<String, dynamic>) onTaskAdded;
  final VoidCallback onClearTasks;

  const AddSchedule({
    super.key,
    required this.onTaskAdded,
    required this.onClearTasks,
  });

  @override
  State<AddSchedule> createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  final TextEditingController taskController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  String? priority;

  void _addTask() {
    if (taskController.text.isNotEmpty &&
        durationController.text.isNotEmpty &&
        priority != null) {
      widget.onTaskAdded({
        "name": taskController.text,
        "priority": priority!,
        "duration": int.tryParse(durationController.text) ?? 30,
      });

      // Tampilkan snackbar setelah tugas ditambahkan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                "Tugas berhasil ditambahkan!",
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Reset input
      taskController.clear();
      durationController.clear();
      setState(() => priority = null);
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tambah Jadwal Baru",
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          // Input Nama Tugas
          _buildTextField(controller: taskController, label: "Nama Tugas"),
          const SizedBox(height: 12),

          // Input Durasi
          _buildTextField(
            controller: durationController,
            label: "Durasi (menit)",
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),

          // Dropdown Prioritas
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade400),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: DropdownButton<String>(
              value: priority,
              hint: Text("Pilih Prioritas", style: GoogleFonts.poppins(fontSize: 14)),
              isExpanded: true,
              underline: const SizedBox(),
              onChanged: (value) => setState(() => priority = value),
              items: ["Tinggi", "Sedang", "Rendah"]
                  .map((priorityMember) => DropdownMenuItem(
                        value: priorityMember,
                        child: Text(priorityMember, style: GoogleFonts.poppins(fontSize: 14)),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 20),

          // Tombol Tambah Tugas
          Center(
            child: ElevatedButton(
              onPressed: _addTask,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                "Tambahkan Tugas",
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
