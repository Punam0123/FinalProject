
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
   const MainPage({super.key}); // Use super.key for the constructor


  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  DateTime dateTime = DateTime(2025, 1, 12, 9, 10);

  @override
  Widget build(BuildContext context) {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(19),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Date and Time',
              style: TextStyle(fontSize: 29),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              child: Text('${dateTime.year}/${dateTime.month}/${dateTime.day}'),
              onPressed: () async {
                final date = await pickDate();
                if (date == null) return; // pressed 'Cancel'

                setState(() => dateTime = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      dateTime.hour,
                      dateTime.minute,
                    )); // pressed 'OK'
              },
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              child: Text('$hours:$minutes'),
              onPressed: () async {
                final time = await pickTime();
                if (time == null) return; // pressed 'Cancel'

                final newDateTime = DateTime(
                  dateTime.year,
                  dateTime.month,
                  dateTime.day,
                  time.hour,
                  time.minute,
                );
                setState(() => dateTime = newDateTime); // pressed 'OK'
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );

  Future<TimeOfDay?> pickTime() => showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
      );
}