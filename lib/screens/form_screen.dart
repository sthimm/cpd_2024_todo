import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart'; 
import 'package:provider/provider.dart';
import '../models/task_manager.dart';
import '../models/date_picker.dart';
import '../widgets/button_widget.dart'; 

class MyFormPage extends StatelessWidget {
  final String title;

  const MyFormPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: _MyForm(),
      ),
    );
  }
}

class _MyForm extends StatelessWidget {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _taskDeadlineController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String taskName = '';
    String taskDescription = '';

    return Form(
      key: _formkey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'Enter a task name',
            ),
            validator: (String? value) {
              return (value == null || value.trim().isEmpty)
                  ? 'Please enter a task name'
                  : null;
            },
            onSaved: (String? value) {
              taskName = value ?? '';
            },
          ),
          const SizedBox(height: 30),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Enter a task description',
            ),
            validator: (String? value) {
              return (value == null || value.trim().isEmpty)
                  ? 'Please enter a task description'
                  : null;
            },
            onSaved: (String? value) {
              taskDescription = value ?? '';
            },
          ),
          const SizedBox(height: 30),
          TextFormField(
            controller: _taskDeadlineController,
            decoration: const InputDecoration(
              labelText: 'Deadline',
              suffixIcon: Icon(Icons.calendar_today),
            ),
            readOnly: true, 
            onTap: () {
              _showDatePicker(context); 
            }, 
          ),
          const SizedBox(height: 30),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // Zentriert die Schaltflächen horizontal
              children: [
                Consumer2<MyTaskManager, MyDatePicker>(
                  builder: (context, taskManager, datePicker, child) {
                    return MyElevatedButton(
                      text: 'Save',
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          _formkey.currentState!.save();
                          taskManager.addTask(Task(taskName, taskDescription, datePicker.selectedDate));
                          Navigator.pushNamed(context, '/');
                        }
                      },
                    );
                  },
                ),
                const SizedBox(width: 30),
                MyElevatedButton(
                  text: 'Cancel',
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Consumer<MyDatePicker>(
          builder: (context, datePicker, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      CupertinoButton(
                        child: const Text('Done'),
                        onPressed: () {
                          _taskDeadlineController.text = datePicker.selectedDate.toString().substring(0, 10);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: datePicker.selectedDate,
                    onDateTimeChanged: (DateTime newDate) {
                      datePicker.selectDate(newDate);
                    },
                  ),
                ),
              ],
            );
          },
        ); 
      },
    ); 
  }

}

