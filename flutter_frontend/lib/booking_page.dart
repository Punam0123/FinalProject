import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:http/http.dart' as http;
import 'package:smart1_parking_connect_application/home_screen.dart';
import 'dart:convert'; // For decoding JSON
// import 'home_page.dart';
// import 'profile_page.dart';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? _startTime;
  DateTime? _endTime;
  String? _selectedSlot;
  
  // Change the type of _availableSlots to List<Map<String, dynamic>>
  List<Map<String, dynamic>> _availableSlots = []; 
  
  bool _isBookingInProgress = false;
  bool _isSlotAvailable = false;

  // Fetch available parking slots from the backend
  Future<void> fetchAvailableSlots() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/slots/available/'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        // Change this part to store slots as maps
        _availableSlots = List<Map<String, dynamic>>.from(data);
      });
    } else {
      throw Exception('Failed to load available slots');
    }
  }

  // Book parking slot and proceed to payment
  Future<void> bookSlot() async {
    if (_startTime == null || _endTime == null || _selectedSlot == null) {
      return;
    }

    setState(() {
      _isBookingInProgress = true;
    });

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/slots/book/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'slot_id': _selectedSlot,
        'start_time': _startTime!.toIso8601String(),
        'end_time': _endTime!.toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _isBookingInProgress = false;
        _isSlotAvailable = true;
      });

      final bookingData = json.decode(response.body);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Booking Successful'),
            content: Text('Proceed to payment: \$${bookingData['payment']['amount']}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        _isBookingInProgress = false;
      });

      final errorData = json.decode(response.body);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errorData['error']),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAvailableSlots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Parking Slot'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Available Parking Slots', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: _availableSlots.length,
                itemBuilder: (context, index) {
                  final slot = _availableSlots[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Text('Slot: ${slot['slot_number']}'),
                      subtitle: Text('Status: ${slot['status']}'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedSlot = slot['slot_number'];
                          });
                        },
                        child: Text('Select'),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text('Select Start Time'),
            ElevatedButton(
              onPressed: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                ).then((date) async {
                  if (date != null) {
                    TimeOfDay? timePicked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (timePicked != null) {
                      setState(() {
                        _startTime = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          timePicked.hour,
                          timePicked.minute,
                        );
                      });
                    }
                  }
                });
              },
              child: Text(_startTime == null
                  ? 'Select Start Time'
                  : DateFormat('yyyy-MM-dd HH:mm').format(_startTime!)),
            ),
            SizedBox(height: 20),
            Text('Select End Time'),
            ElevatedButton(
              onPressed: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                ).then((date) async {
                  if (date != null) {
                    TimeOfDay? timePicked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (timePicked != null) {
                      setState(() {
                        _endTime = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          timePicked.hour,
                          timePicked.minute,
                        );
                      });
                    }
                  }
                });
              },
              child: Text(_endTime == null
                  ? 'Select End Time'
                  : DateFormat('yyyy-MM-dd HH:mm').format(_endTime!)),
            ),
            SizedBox(height: 20),
            _isBookingInProgress
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _isSlotAvailable ? null : bookSlot,
                    child: Text('Book Slot'),
                  ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }
        },
      ),
    );
  }
}
