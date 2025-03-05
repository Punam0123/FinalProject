import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart1_parking_connect_application/ipconfig.dart';

class ParkingService {
    String baseUrl = "${getIp()}/api/";

  // Method to fetch parking spots
  Future<List<dynamic>> getParkingSpots() async {
    final response = await http.get(Uri.parse("${baseUrl}parking-spots/"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Convert JSON response to a list
    } else {
      throw Exception("Failed to load parking spots");
    }
  }
}
