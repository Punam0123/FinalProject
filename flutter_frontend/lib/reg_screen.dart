import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart1_parking_connect_application/ipconfig.dart';

class RegScreen extends StatefulWidget {
  const RegScreen({super.key});

  @override
  State<RegScreen> createState() => RegScreenState();
}

class RegScreenState extends State<RegScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<void> _registerUser() async {
    print("Register button clicked!"); // Debugging line
    if (_formKey.currentState!.validate()) {
      // Check if passwords match
      if (passwordController.text != confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match!")),
        );
        return;
      }

       String apiUrl =
          "${getIp()}/api/auth/signup/"; // Ensure correct IP

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "username": fullNameController.text,
            "email": emailController.text,
            "password": passwordController.text,
          }),
        );

        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registration Successful!")),
          );
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          final errorData = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorData["error"] ?? "Signup failed!")),
          );
        }
      } catch (e) {
        print("Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1D06C7), Color(0xFF281537)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 22.0, vertical: 60.0),
                  child: Text(
                    'Create Your\nAccount',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(40)),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        buildTextField('Full Name', fullNameController,
                            TextInputType.text),
                        buildTextField('Email Address', emailController,
                            TextInputType.emailAddress),
                        buildTextField('Phone Number', phoneController,
                            TextInputType.phone),
                        buildTextField('Password', passwordController,
                            TextInputType.visiblePassword,
                            isPassword: true),
                        buildTextField(
                            'Confirm Password',
                            confirmPasswordController,
                            TextInputType.visiblePassword,
                            isPassword: true),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            backgroundColor: const Color(0xFF1809BF),
                          ),
                          onPressed: _registerUser, // Call API when pressed
                          child: const Text(
                            'Register',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 20, right: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text("Already have an account? ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFB0B0B0))),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/login');
                                  },
                                  child: const Text("Sign in",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String label, TextEditingController controller, TextInputType inputType,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}
