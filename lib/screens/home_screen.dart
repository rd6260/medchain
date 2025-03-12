import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medchain/screens/medicine_varified_screen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isScanning = false;
  List<ScanResult> recentScans = [
    ScanResult(
      medicineId: "MED123456",
      medicineName: "Paracetamol 500mg",
      manufacturer: "PharmaCorp",
      verificationStatus: true,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ScanResult(
      medicineId: "MED789012",
      medicineName: "Amoxicillin 250mg",
      manufacturer: "MediLabs",
      verificationStatus: true,
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
    ),
    ScanResult(
      medicineId: "MED345678",
      medicineName: "Ibuprofen 400mg",
      manufacturer: "HealthPharm",
      verificationStatus: false,
      timestamp: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  @override
  void dispose() {
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    // for (final barcode in barcodes) {
    //   _showScanResultDialog(barcode.rawValue ?? "Unknown");
    // }

    if (barcodes[0].rawValue != null) {
      isScanning = false;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  MedicineVerifiedScreen(jsonData: barcodes[0].rawValue!),
        ),
      );
    }
  }

  void _showScanResultDialog(String code) {
    // In a real app, we would verify this code against our blockchain
    bool isVerified = code.length > 5; // Dummy verification logic

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              isVerified ? "Authentic Medicine" : "Verification Failed",
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("QR Code: $code"),
                const SizedBox(height: 8),
                Text(
                  isVerified
                      ? "This medicine is verified on the blockchain and is authentic."
                      : "This medicine could not be verified. It may be counterfeit.",
                  style: TextStyle(
                    color:
                        isVerified
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (isVerified) {
                    // Add to recent scans in a real app
                    setState(() {
                      recentScans.insert(
                        0,
                        ScanResult(
                          medicineId: code,
                          medicineName: "Sample Medicine",
                          manufacturer: "Sample Manufacturer",
                          verificationStatus: true,
                          timestamp: DateTime.now(),
                        ),
                      );
                      if (recentScans.length > 10) {
                        recentScans.removeLast();
                      }
                    });
                  }
                },
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  void _startScan() {
    setState(() {
      isScanning = true;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Scan Medicine QR Code",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          //controller?.pauseCamera();
                          Navigator.pop(context);
                          setState(() {
                            isScanning = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: MobileScanner(
                    onDetect: _onDetect,
                    // overlayBuilder: (context, constraints) => ,
                    // overlay: MobileScannerOverlay(
                    //   overlayColor: Theme.of(context).primaryColor,
                    //   borderRadius: 10,
                    //   borderLength: 30,
                    //   borderWidth: 10,
                    //   cutOutSize: MediaQuery.of(context).size.width * 0.8,
                    // ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Position the QR code within the frame to scan",
                    style: TextStyle(color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
    ).then((_) {
      //controller?.pauseCamera();
      setState(() {
        isScanning = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.medical_services, color: Colors.teal),
            SizedBox(width: 8),
            Text(
              "MedChain",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.teal),
            onPressed: () {
              // Navigate to profile screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.teal),
            onPressed: () {
              // Navigate to notifications screen
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section with scan button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Verify Medicine Authenticity",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Scan the QR code on your medicine package to verify its authenticity using blockchain technology",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: _startScan,
                    icon: const Icon(Icons.qr_code_scanner, size: 24),
                    label: const Text(
                      "Scan QR Code",
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Recent scans section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Recent Scans",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  recentScans.isEmpty
                      ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Icon(
                                Icons.history,
                                size: 60,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "No recent scans",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: recentScans.length,
                        itemBuilder: (context, index) {
                          final scan = recentScans[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              leading: CircleAvatar(
                                backgroundColor:
                                    scan.verificationStatus
                                        ? Colors.green.shade100
                                        : Colors.red.shade100,
                                child: Icon(
                                  scan.verificationStatus
                                      ? Icons.check
                                      : Icons.close,
                                  color:
                                      scan.verificationStatus
                                          ? Colors.green.shade700
                                          : Colors.red.shade700,
                                ),
                              ),
                              title: Text(
                                scan.medicineName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    "Manufacturer: ${scan.manufacturer}",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "ID: ${scan.medicineId}",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatDate(scan.timestamp),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.grey.shade400,
                              ),
                              onTap: () {
                                // Show detailed scan result
                              },
                            ),
                          );
                        },
                      ),
                ],
              ),
            ),

            // How it works section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "How MedChain Works",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildHowItWorksStep(
                    icon: Icons.qr_code,
                    title: "Scan",
                    description: "Scan the QR code on your medicine package",
                  ),
                  const SizedBox(height: 12),
                  _buildHowItWorksStep(
                    icon: Icons.link,
                    title: "Verify",
                    description:
                        "Our app verifies the medicine on the blockchain",
                  ),
                  const SizedBox(height: 12),
                  _buildHowItWorksStep(
                    icon: Icons.check_circle,
                    title: "Trust",
                    description:
                        "Get instant confirmation of medicine authenticity",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "Education"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorksStep({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.teal, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return "Today";
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} days ago";
    } else {
      return "${date.day}/${date.month}/${date.year}";
    }
  }
}

class ScanResult {
  final String medicineId;
  final String medicineName;
  final String manufacturer;
  final bool verificationStatus;
  final DateTime timestamp;

  ScanResult({
    required this.medicineId,
    required this.medicineName,
    required this.manufacturer,
    required this.verificationStatus,
    required this.timestamp,
  });
}
