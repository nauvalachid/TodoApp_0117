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