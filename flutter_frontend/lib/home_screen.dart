import 'package:flutter/material.dart';
import 'package:smart1_parking_connect_application/details_screen.dart';
import 'models/parking_spot.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/smart_parking_logo.png',
              height: 40,
            ),
            const SizedBox(width: 10),
            const Text('Smart Parking Finder'),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          const Expanded(child: ParkingGrid()),
        ],
      ),
    );
  }
}

class ParkingGrid extends StatelessWidget {
  const ParkingGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final parkingSpots = [
      ParkingSpot(
          name: "A1",
          location: "Garrage",
          distance: 0.5,
          available: true,
          price: 3.0),
      ParkingSpot(
          name: "B2",
          location: "Garrage",
          distance: 1.2,
          available: false,
          price: 4.0),
      ParkingSpot(
          name: "C3",
          location: "Garrage",
          distance: 2.5,
          available: true,
          price: 2.0),
      ParkingSpot(
          name: "D4",
          location: "Garrage",
          distance: 3.0,
          available: true,
          price: 5.0),
      ParkingSpot(
          name: "E5",
          location: "Garrage",
          distance: 1.0,
          available: false,
          price: 3.0),
      ParkingSpot(
          name: "F6",
          location: "Garrage",
          distance: 0.8,
          available: true,
          price: 4.0),
    ];

    final List<String> vehicleImages = [
      'assets/sport-car.png',
      'assets/green_vehicle.png',
      'assets/yellow_vehicle.png',
      'assets/skyblue_vehicle.png',
      'assets/yellow1_vehicle.png',
      'assets/red_vehicle.png'
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.2,
        ),
        itemCount: parkingSpots.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ParkingDetailScreen(spot: parkingSpots[index]),
                ),
              );
            },
            child: ParkingSlot(
              slotNumber: index + 1,
              price: parkingSpots[index].price.toInt(),
              vehicleImage: vehicleImages[index],
              isFirstSlot: index == 0,
              isSecondSlot: index == 1,
              isThirdSlot: index == 2,
            ),
          );
        },
      ),
    );
  }
}

class ParkingSlot extends StatelessWidget {
  final int slotNumber;
  final int price;
  final String vehicleImage;
  final bool isFirstSlot;
  final bool isSecondSlot;
  final bool isThirdSlot;

  const ParkingSlot({
    super.key,
    required this.slotNumber,
    required this.price,
    required this.vehicleImage,
    required this.isFirstSlot,
    required this.isSecondSlot,
    required this.isThirdSlot,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          color: isFirstSlot
              ? Colors.red.withOpacity(0.2)
              : isThirdSlot
                  ? Colors.yellow.withOpacity(0.2)
                  : isSecondSlot
                      ? Colors.white
                      : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              vehicleImage,
              height: 80,
              width: 80,
            ),
            SizedBox(height: 8),
            Text(
              'Slot $slotNumber',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              '\$$price/hr',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}
