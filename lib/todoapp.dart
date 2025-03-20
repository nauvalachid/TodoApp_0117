import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _taskController = TextEditingController();
  List<Map<String, dynamic>> listTugas = [];
  DateTime? _selectedDate;
  bool _isDateSelected = true; // Untuk validasi
}

void _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _isDateSelected = true; // Validasi berhasil
        });
      }
    }
  }

  void _addTask() {
  setState(() {
      _isDateSelected = _selectedDate != null; // Validasi Task Date
    });

  if (_key.currentState!.validate() && _selectedDate != null) {
    setState(() {
      listTugas.add({
        'name': _taskController.text,
        'date': _selectedDate,
        'done': false,
      });
      _taskController.clear();
      _selectedDate = null;
    });

    // Tampilkan Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Task added successfully"),
        backgroundColor: Colors.teal,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

  void _toggleTaskStatus(int index) {
    setState(() {
      listTugas[index]['done'] = !listTugas[index]['done'];
    });
  }