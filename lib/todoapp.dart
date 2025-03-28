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

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Form Page',
          style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: Color.fromARGB(255, 0, 0, 0)),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Task Date:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Poppins', color: Color.fromARGB(255, 0, 0, 0))),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => _pickDate(context),
                      child: Text(_selectedDate == null
                          ? "Select a date and time"
                          : DateFormat('dd-MM-yyyy HH:mm').format(_selectedDate!)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _pickDate(context),
                    ),
                  ],
                ),
                if (!_isDateSelected)
                  const Text(
                    "Please select a date",
                    style: TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 10),
                 Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _taskController,
                        decoration: const InputDecoration(
                          labelText: "Task Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter some text";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _addTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 53, 154, 201),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      ),
                      child: const Text("Submit", style: TextStyle(color: Colors.white,fontFamily: 'Poppins')),
                    ),
                  ],
                 ),
                 const SizedBox(height: 20),
                 const Text("List Tasks", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,fontFamily: 'Poppins')),
                 Expanded(
                  child: ListView.builder(
                    itemCount: listTugas.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          title: Text(
                            listTugas[index]['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins'
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Deadline: " +
                                    DateFormat('dd-MM-yyyy HH:mm').format(listTugas[index]['date']),
                                style: const TextStyle(color: Color.fromARGB(255, 134, 140, 144),fontWeight: FontWeight.bold,fontFamily: 'Poppins'),
                              ),
                              Text(
                                listTugas[index]['done'] ? "Done" : "Not Done",
                                style: TextStyle(
                                  color: listTugas[index]['done'] ? const Color.fromARGB(255, 25, 114, 28) : const Color.fromARGB(255, 147, 35, 27),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins'
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                                icon: Icon(
                                  listTugas[index]['done'] ? Icons.check_circle : Icons.radio_button_unchecked,
                                  color: listTugas[index]['done'] ? Colors.green : const Color.fromARGB(255, 111, 111, 111),
                                ),
                            onPressed: () => _toggleTaskStatus(index),
                          ),
                           tileColor: const Color.fromARGB(255, 189, 220, 235),
                        ),
                      );
                    },
                  ),
                 ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}