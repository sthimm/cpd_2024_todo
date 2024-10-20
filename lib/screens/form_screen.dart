import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart'; 
import 'package:provider/provider.dart';
import '../models/task_manager.dart';
import '../models/date_picker.dart';
import '../widgets/button_widget.dart'; 

class MyFormPage extends StatelessWidget {
  const MyFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: _MyForm(),
      ),
    );
  }
}

class _MyForm extends StatelessWidget {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescriptionController = TextEditingController();
  final TextEditingController _taskDeadlineController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            controller: _taskNameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'Enter a task name',
            ),
            validator: (String? value) {
              return (value == null || value.trim().isEmpty)
                  ? 'Please enter a task name'
                  : null;
            },
          ),
          const SizedBox(height: 30),
          TextFormField(
            controller: _taskDescriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Enter a task description',
            ),
            validator: (String? value) {
              return (value == null || value.trim().isEmpty)
                  ? 'Please enter a task description'
                  : null;
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
                          taskManager.addTask(Task(_taskNameController.text, _taskDescriptionController.text, datePicker.selectedDate));
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

