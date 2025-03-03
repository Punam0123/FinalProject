import 'package:flutter/material.dart';
import 'package:smart1_parking_connect_application/reg_screen.dart';
import 'package:smart1_parking_connect_application/login_screen.dart' as login; // Add a prefix to the login_screen.dart import
import 'package:smart1_parking_connect_application/services/parking_service.dart'; // Correct import of parking_service.dart

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key}); // Use super.key for the constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 40, 39, 50),
              Color.fromARGB(255, 22, 10, 190),
              Color(0xff281537),
            ],
          ),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 200.0),
              child: Image(image: AssetImage('assets/logo.png')),
            ),
            const SizedBox(height: 100),
            const Text(
              'Welcome Back',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
               Navigator.push(
               context,
               MaterialPageRoute(
               builder: (context) => login.LoginScreen(), // Removed 'const'
               ),
               );
              },

              child: Container(
                height: 53,
                width: 320,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white),
                ),
                child: const Center(
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegScreen()),
                );
              },
              child: Container(
                height: 53,
                width: 320,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white),
                ),
                child: const Center(
                  child: Text(
                    'SIGN UP',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            const Text(
              'Login with Social Media',
              style: TextStyle(fontSize: 17, color: Colors.white),
            ),
            const SizedBox(height: 12),
            const Image(image: AssetImage('assets/social.png')),

            // New Section to display parking spots fetched from the API
            FutureBuilder<List<dynamic>>(
              future: ParkingService().getParkingSpots(), // Get the parking spots from the service
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator()); // Show loading spinner
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}')); // Handle error
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No parking spots available')); // Handle empty response
                } else {
                  // Display the list of parking spots
                  var parkingSpots = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: parkingSpots.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(parkingSpots[index]['name']),
                          subtitle: Text(parkingSpots[index]['location']),
                          trailing: Text(parkingSpots[index]['status']),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
