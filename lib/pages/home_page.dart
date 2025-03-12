import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_schedule.dart';
import 'scedule_procces.dart';
import 'history_shedule.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> tasks = []; // Semua tugas
  final List<Map<String, dynamic>> completedTasks = []; // Tugas yang selesai

  void addTask(Map<String, dynamic> task) {
    setState(() {
      tasks.add(task);
    });
  }

  void clearTasks() {
    setState(() {
      tasks.clear();
      completedTasks.clear(); // Kosongkan juga history
    });
  }

  void removeTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void markTaskAsCompleted(Map<String, dynamic> task) {
    setState(() {
      completedTasks.add(task); // Tambahkan ke daftar history
      tasks.remove(task); // Hapus dari daftar aktif
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Text(
            "Schedule Manager",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {},
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.add), text: "Add"),
              Tab(icon: Icon(Icons.calendar_today), text: "Schedule"),
              Tab(icon: Icon(Icons.history), text: "History"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AddSchedule(onTaskAdded: addTask, onClearTasks: clearTasks),
            ScheduleProcess(
              tasks: tasks,
              onClearTasks: clearTasks,
              onRemoveTask: removeTask,
              onTaskCompleted: markTaskAsCompleted, // Kirim fungsi ini ke ScheduleProcess
            ),
            HistoryShedule(completedTasks: completedTasks), // Kirim daftar tugas selesai
          ],
        ),
      ),
    );
  }
}
