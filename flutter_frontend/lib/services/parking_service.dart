import 'dart:convert';
import 'package:http/http.dart' as http;

class ParkingService {
  static const String baseUrl = "http://127.0.0.1:8000/api/";

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
