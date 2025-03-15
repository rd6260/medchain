import 'package:flutter/material.dart';
import 'package:medchain/screens/qr_validation_screen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  bool _isProcessing = false;

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing || capture.barcodes.isEmpty) return;

    setState(() {
      _isProcessing = true;
    });

    final String? scannedData = capture.barcodes.first.rawValue;
    if (scannedData != null) {
      // Navigate to QRValidationScreen with the scanned data
      // Navigator.pushReplacementNamed(
      //   context,
      //   '/qrValidation',
      //   arguments: scannedData,
      // );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QRValidationScreen(content: scannedData),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(onDetect: _onDetect),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(16),
              color: Colors.black54,
              child: Text(
                "Align the QR code within the frame to scan",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
