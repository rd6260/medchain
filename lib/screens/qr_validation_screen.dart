import 'dart:convert';
import 'package:flutter/material.dart';

class QRValidationScreen extends StatelessWidget {
  final String content;

  const QRValidationScreen({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = jsonDecode(content);

    return Scaffold(
      appBar: AppBar(
        title: Text("Medicine Details"),
        backgroundColor: Colors.green.shade700,
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 10,
          shadowColor: Colors.greenAccent,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_rounded,
                  color: Colors.green,
                  size: 90,
                ),
                SizedBox(height: 16),
                Text(
                  "Medicine Verified",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
                Divider(thickness: 1, height: 30),
                _infoTile("Name", data['name']),
                _infoTile("Manufacturer", data['manufacturer']),
                _infoTile("Batch Number", data['batch_number']),
                _infoTile("Manufacture Date", data['manufacture_date']),
                _infoTile("Expiry Date", data['expiry_date']),
                _infoTile("Blockchain TX ID", data['blockchain_tx_id']),
                _infoTile("Verification Hash", data['verificationHash']),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back),
                  label: Text("Back"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.label_important, color: Colors.green.shade700, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "$title: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                  ),
                  TextSpan(
                    text: value,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
