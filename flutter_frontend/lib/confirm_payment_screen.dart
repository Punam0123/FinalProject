import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SmartParkingPaymentScreen extends StatefulWidget {
  final Map<String, dynamic>? parkingDetails;

  const SmartParkingPaymentScreen({
    super.key,
    this.parkingDetails,
  });

  @override
  State<SmartParkingPaymentScreen> createState() =>
      _SmartParkingPaymentScreenState();
}

class _SmartParkingPaymentScreenState extends State<SmartParkingPaymentScreen> {
  final TextEditingController _promoController = TextEditingController();
  bool isPromoApplied = false;
  double discountAmount = 0.0;
  double originalAmount = 250.0; // Default amount

  @override
  void initState() {
    super.initState();
    // Initialize with parking details if available
    if (widget.parkingDetails != null) {
      originalAmount = widget.parkingDetails!['amount'] ?? 250.0;
    }
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void applyPromoCode(String code) {
    // Simple promo code logic
    if (code.toUpperCase() == 'PARK10') {
      setState(() {
        isPromoApplied = true;
        discountAmount = originalAmount * 0.1; // 10% discount
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('10% Discount Applied!')),
      );
    } else if (code.toUpperCase() == 'PARK20') {
      setState(() {
        isPromoApplied = true;
        discountAmount = originalAmount * 0.2; // 20% discount
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('20% Discount Applied!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid Promo Code')),
      );
    }
  }

  double get finalAmount => originalAmount - discountAmount;

  @override
  Widget build(BuildContext context) {
    // Generate parking slot and vehicle details from parking details or use defaults
    final slotName = widget.parkingDetails?['slotName'] ?? 'A-123';
    final vehicleNumber =
        widget.parkingDetails?['vehicleNumber'] ?? 'BA 1 PA 2345';
    final vehicleType = widget.parkingDetails?['vehicleType'] ?? 'Four Wheeler';
    final startTime = widget.parkingDetails?['startTime'] ?? DateTime.now();
    final endTime = widget.parkingDetails?['endTime'] ??
        DateTime.now().add(const Duration(hours: 2));
    final parkingLocation =
        widget.parkingDetails?['location'] ?? 'Central Mall, Kathmandu';

    return Scaffold(
      backgroundColor: const Color(0xFFEEEAF2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Confirm and Pay',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Parking Details Card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Parking Location Info
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.local_parking,
                              color: Colors.blue,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  parkingLocation,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.car_rental,
                                        size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Slot: $slotName',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 16),

                      // Booking Details
                      const Text(
                        'Booking Details',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Vehicle Info Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Vehicle',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            vehicleNumber,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Vehicle Type Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Type',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            vehicleType,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Date Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Date',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            DateFormat('dd MMM, yyyy').format(startTime),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Time Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Time',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            '${DateFormat('h:mm a').format(startTime)} - ${DateFormat('h:mm a').format(endTime)}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Duration Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Duration',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            '${endTime.difference(startTime).inHours} hours',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),

                      // Promo Code Input
                      const Text(
                        'Promo Code',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 8),
                            const Icon(Icons.confirmation_number_outlined,
                                color: Colors.grey),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _promoController,
                                decoration: const InputDecoration(
                                  hintText: 'Enter Promo Code',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward,
                                  color: Colors.grey),
                              onPressed: () {
                                // Apply promo code
                                if (_promoController.text.isNotEmpty) {
                                  applyPromoCode(_promoController.text);
                                }
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),

                      // Payment Summary
                      const Text(
                        'Payment Summary',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Parking Fee Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Parking Fee',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            'Rs. ${originalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),

                      // Discount Row - Show only if a promo is applied
                      if (isPromoApplied) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Discount',
                              style: TextStyle(color: Colors.green),
                            ),
                            Text(
                              '- Rs. ${discountAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 8),
                      const Divider(thickness: 1),
                      const SizedBox(height: 8),

                      // Total Price Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Price',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Rs. ${finalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Payment Method
              const Text(
                'Payment Method',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),

              // Khalti Payment Option
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5C2D91).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      "K",
                      style: TextStyle(
                          color: Color(0xFF5C2D91),
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  title: const Text('Khalti'),
                  subtitle: const Text('Digital Wallet'),
                  trailing: const Icon(Icons.check_circle, color: Colors.green),
                ),
              ),

              const SizedBox(height: 32),

              // Pay Now Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle payment confirmation
                    _processKhaltiPayment(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5C2D91),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Pay Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF5C2D91),
        unselectedItemColor: Colors.grey,
        currentIndex: 2, // Assuming 'Payments' tab is selected
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payments, size: 30),
            label: 'Payments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _processKhaltiPayment(BuildContext context) {
    // Show Khalti payment confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF5C2D91).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                "K",
                style: TextStyle(
                    color: Color(0xFF5C2D91),
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            const SizedBox(width: 8),
            const Text('Khalti Payment'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                'You will be redirected to Khalti to complete your payment.'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Amount:'),
                Text(
                  'Rs. ${finalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('Proceed',
                style: TextStyle(color: Color(0xFF5C2D91))),
            onPressed: () {
              Navigator.pop(context);
              // Simulate Khalti payment process
              _simulateKhaltiPayment(context);
            },
          ),
        ],
      ),
    );
  }

  void _simulateKhaltiPayment(BuildContext context) {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF5C2D91),
        ),
      ),
    );

    // Simulate Khalti payment processing delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close loading dialog

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Payment Successful'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text('Your parking has been confirmed.'),
              const SizedBox(height: 8),
              Text('Amount Paid: Rs. ${finalAmount.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              const Text('A receipt has been sent to your email.'),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('View Booking'),
              onPressed: () {
                Navigator.pop(context); // Close dialog

                // Here you would navigate to the booking details screen
                // For now, we'll just go back to the previous screen
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    });
  }
}

//To use this screen, you would navigate to it like this:

// Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => SmartParkingPaymentScreen(
//       parkingDetails: {
//         'slotName': 'A-123',
//         'vehicleNumber': 'BA 1 PA 2345',
//         'vehicleType': 'Four Wheeler',
//         'startTime': DateTime.now(),
//         'endTime': DateTime.now().add(Duration(hours: 2)),
//         'location': 'Central Mall, Kathmandu',
//         'amount': 250.0,
//       },
//     ),
//   ),
// );
