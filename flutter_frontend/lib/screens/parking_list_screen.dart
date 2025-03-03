import 'package:flutter/material.dart';
import '../services/parking_service.dart'; // Import ParkingService

class ParkingListScreen extends StatefulWidget {
  const ParkingListScreen({super.key}); // Use 'super.key' to pass the key parameter

  @override
  ParkingListScreenState createState() => ParkingListScreenState();
}

class ParkingListScreenState extends State<ParkingListScreen> {
  List<dynamic> parkingSpots = []; // To store fetched parking spots
  bool isLoading = true; // For loading state

  @override
  void initState() {
    super.initState();
    // Call the function to fetch parking spots
    fetchParkingSpots();
  }

  // Function to fetch parking spots
  Future<void> fetchParkingSpots() async {
    ParkingService parkingService = ParkingService();

    try {
      // Call the method from ParkingService
      List<dynamic> spots = await parkingService.getParkingSpots();

      // Update the state with the fetched data
      setState(() {
        parkingSpots = spots;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error fetching parking spots: $e"); // Use debugPrint instead of print
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parking Spots')), // Use const Text widget
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Use const CircularProgressIndicator
          : ListView.builder(
              itemCount: parkingSpots.length,
              itemBuilder: (context, index) {
                var spot = parkingSpots[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text('Spot ${spot['id']}'),
                    subtitle: Text(spot['status'] ? '✅ Available' : '❌ Occupied'),
                  ),
                );
              },
            ),
    );
  }
}
