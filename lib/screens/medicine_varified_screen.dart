import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MedicineVerifiedScreen extends StatelessWidget {
  final String jsonData;

  const MedicineVerifiedScreen({super.key, required this.jsonData});

  @override
  Widget build(BuildContext context) {
    // Decode JSON data
    Map<String, dynamic> medicineData;
    try {
      medicineData = json.decode(jsonData);
      // print(medicineData);
    } catch (e) {
      return _buildErrorScreen(context, "Invalid data format");
    }

    // Extract medicine information
    final String name = medicineData['name'] ?? 'N/A';
    final String id = medicineData['drug_id'] ?? 'N/A';
    final String batchNumber = medicineData["batch_number"] ?? "N/A";
    final String manufacturingDate = medicineData['manufacture_date'] ?? 'N/A';
    final String expiryDate = medicineData['expiry_date'] ?? 'N/A';

    // Format dates if they are valid
    String formattedManufDate = manufacturingDate;
    String formattedExpDate = expiryDate;

    try {
      if (manufacturingDate != 'N/A') {
        final DateTime mDate = DateTime.parse(manufacturingDate);
        formattedManufDate = DateFormat('dd MMM yyyy').format(mDate);
      }

      if (expiryDate != 'N/A') {
        final DateTime eDate = DateTime.parse(expiryDate);
        formattedExpDate = DateFormat('dd MMM yyyy').format(eDate);
      }
    } catch (e) {
      // Use the original strings if parsing fails
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification Result'),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Verification Badge
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.verified, size: 80, color: Colors.teal),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Verified',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'This medicine has been verified as authentic',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // Medicine Information Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.2),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Medicine Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildInfoRow('ID', id),
                    const Divider(height: 30),
                    _buildInfoRow('Name', name),
                    const Divider(height: 30),
                    _buildInfoRow('Manufacturing Date', formattedManufDate),
                    const Divider(height: 30),
                    _buildInfoRow('Expiry Date', formattedExpDate),
                    const Divider(height: 30),
                    _buildInfoRow('Batch Number', batchNumber),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorScreen(BuildContext context, String message) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification Error'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 20),
            Text(
              message,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
