// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:medchain/screens/medicine_varified_screen.dart';
// import 'package:medchain/services/auth_service.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final authService = AuthService();
//   bool isScanning = false;
//   List<ScanResult> recentScans = [
//     ScanResult(
//       medicineId: "MED123456",
//       medicineName: "Paracetamol 500mg",
//       manufacturer: "PharmaCorp",
//       verificationStatus: true,
//       timestamp: DateTime.now().subtract(const Duration(days: 1)),
//     ),
//     ScanResult(
//       medicineId: "MED789012",
//       medicineName: "Amoxicillin 250mg",
//       manufacturer: "MediLabs",
//       verificationStatus: true,
//       timestamp: DateTime.now().subtract(const Duration(days: 3)),
//     ),
//     ScanResult(
//       medicineId: "MED345678",
//       medicineName: "Ibuprofen 400mg",
//       manufacturer: "HealthPharm",
//       verificationStatus: false,
//       timestamp: DateTime.now().subtract(const Duration(days: 5)),
//     ),
//   ];

//   // get onLogout => null;
//   void onLogout() {
//     authService.signOut();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   void _onDetect(BarcodeCapture capture) {
//     final List<Barcode> barcodes = capture.barcodes;
//     // for (final barcode in barcodes) {
//     //   _showScanResultDialog(barcode.rawValue ?? "Unknown");
//     // }

//     if (barcodes[0].rawValue != null) {
//       isScanning = false;
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder:
//               (context) =>
//                   MedicineVerifiedScreen(jsonData: barcodes[0].rawValue!),
//         ),
//       );
//     }
//   }

//   void _startScan() {
//     setState(() {
//       isScanning = true;
//     });

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder:
//           (context) => Container(
//             height: MediaQuery.of(context).size.height * 0.8,
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//             ),
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         "Scan Medicine QR Code",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.close),
//                         onPressed: () {
//                           //controller?.pauseCamera();
//                           Navigator.pop(context);
//                           setState(() {
//                             isScanning = false;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: MobileScanner(
//                     onDetect: _onDetect,
//                     // overlayBuilder: (context, constraints) => ,
//                     // overlay: MobileScannerOverlay(
//                     //   overlayColor: Theme.of(context).primaryColor,
//                     //   borderRadius: 10,
//                     //   borderLength: 30,
//                     //   borderWidth: 10,
//                     //   cutOutSize: MediaQuery.of(context).size.width * 0.8,
//                     // ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Text(
//                     "Position the QR code within the frame to scan",
//                     style: TextStyle(color: Colors.grey.shade600),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//     ).then((_) {
//       //controller?.pauseCamera();
//       setState(() {
//         isScanning = false;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         title: const Row(
//           children: [
//             Icon(Icons.medical_services, color: Colors.teal),
//             SizedBox(width: 8),
//             Text(
//               "MedChain",
//               style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
//             ),
//           ],
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         systemOverlayStyle: SystemUiOverlayStyle.dark,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.person_outline, color: Colors.teal),
//             onPressed: () {
//               // Navigate to profile screen
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.logout, color: Colors.teal),
//             onPressed: onLogout,
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Hero section with scan button
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.shade200,
//                     blurRadius: 10,
//                     offset: const Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   const Text(
//                     "Verify Medicine Authenticity",
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.teal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 16),
//                   const Text(
//                     "Scan the QR code on your medicine package to verify its authenticity using blockchain technology",
//                     style: TextStyle(fontSize: 16, color: Colors.grey),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 30),
//                   ElevatedButton.icon(
//                     onPressed: _startScan,
//                     icon: const Icon(Icons.qr_code_scanner, size: 24),
//                     label: const Text(
//                       "Scan QR Code",
//                       style: TextStyle(fontSize: 18),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.teal,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 30,
//                         vertical: 15,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),

//             // Recent scans section
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Recent Scans",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   recentScans.isEmpty
//                       ? Center(
//                         child: Padding(
//                           padding: const EdgeInsets.all(20),
//                           child: Column(
//                             children: [
//                               Icon(
//                                 Icons.history,
//                                 size: 60,
//                                 color: Colors.grey.shade400,
//                               ),
//                               const SizedBox(height: 16),
//                               Text(
//                                 "No recent scans",
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.grey.shade600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       )
//                       : ListView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: recentScans.length,
//                         itemBuilder: (context, index) {
//                           final scan = recentScans[index];
//                           return Card(
//                             margin: const EdgeInsets.only(bottom: 12),
//                             elevation: 1,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: ListTile(
//                               contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 8,
//                               ),
//                               leading: CircleAvatar(
//                                 backgroundColor:
//                                     scan.verificationStatus
//                                         ? Colors.green.shade100
//                                         : Colors.red.shade100,
//                                 child: Icon(
//                                   scan.verificationStatus
//                                       ? Icons.check
//                                       : Icons.close,
//                                   color:
//                                       scan.verificationStatus
//                                           ? Colors.green.shade700
//                                           : Colors.red.shade700,
//                                 ),
//                               ),
//                               title: Text(
//                                 scan.medicineName,
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     "Manufacturer: ${scan.manufacturer}",
//                                     style: TextStyle(
//                                       fontSize: 13,
//                                       color: Colors.grey.shade700,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 2),
//                                   Text(
//                                     "ID: ${scan.medicineId}",
//                                     style: TextStyle(
//                                       fontSize: 13,
//                                       color: Colors.grey.shade700,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     _formatDate(scan.timestamp),
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.grey.shade500,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               trailing: Icon(
//                                 Icons.arrow_forward_ios,
//                                 size: 16,
//                                 color: Colors.grey.shade400,
//                               ),
//                               onTap: () {
//                                 // Show detailed scan result
//                               },
//                             ),
//                           );
//                         },
//                       ),
//                 ],
//               ),
//             ),

//             // How it works section
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 20),
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.teal.shade50,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "How MedChain Works",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.teal,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   _buildHowItWorksStep(
//                     icon: Icons.qr_code,
//                     title: "Scan",
//                     description: "Scan the QR code on your medicine package",
//                   ),
//                   const SizedBox(height: 12),
//                   _buildHowItWorksStep(
//                     icon: Icons.link,
//                     title: "Verify",
//                     description:
//                         "Our app verifies the medicine on the blockchain",
//                   ),
//                   const SizedBox(height: 12),
//                   _buildHowItWorksStep(
//                     icon: Icons.check_circle,
//                     title: "Trust",
//                     description:
//                         "Get instant confirmation of medicine authenticity",
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: 0,
//         selectedItemColor: Colors.teal,
//         unselectedItemColor: Colors.grey,
//         type: BottomNavigationBarType.fixed,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
//           // BottomNavigationBarItem(icon: Icon(Icons.info), label: "Education"),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             label: "Settings",
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHowItWorksStep({
//     required IconData icon,
//     required String title,
//     required String description,
//   }) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Icon(icon, color: Colors.teal, size: 24),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.teal,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 description,
//                 style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   String _formatDate(DateTime date) {
//     final now = DateTime.now();
//     final difference = now.difference(date);

//     if (difference.inDays == 0) {
//       return "Today";
//     } else if (difference.inDays == 1) {
//       return "Yesterday";
//     } else if (difference.inDays < 7) {
//       return "${difference.inDays} days ago";
//     } else {
//       return "${date.day}/${date.month}/${date.year}";
//     }
//   }
// }

// class ScanResult {
//   final String medicineId;
//   final String medicineName;
//   final String manufacturer;
//   final bool verificationStatus;
//   final DateTime timestamp;

//   ScanResult({
//     required this.medicineId,
//     required this.medicineName,
//     required this.manufacturer,
//     required this.verificationStatus,
//     required this.timestamp,
//   });
// }



import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FAFC),
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            CustomScrollView(
              slivers: [
                // App Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Med',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF3E3F65),
                                ),
                              ),
                              TextSpan(
                                text: 'Chain',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF6C63FF),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.notifications_outlined,
                                color: Color(0xFF3E3F65),
                                size: 22,
                              ),
                            ),
                            SizedBox(width: 12),
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage('https://i.pravatar.cc/150'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Banner
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: NetworkImage('https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=800'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withValues(alpha: 0.3),
                            BlendMode.darken,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Authentic Medicines',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Verify using blockchain technology',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => _openScanner(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF6C63FF),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.qr_code_scanner, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Scan Medicine',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Quick Stats
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatCard(
                          "Today's Scans",
                          '12',
                          Color(0xFF6C63FF).withValues(alpha: 0.1),
                          Icon(Icons.qr_code, color: Color(0xFF6C63FF)),
                        ),
                        _buildStatCard(
                          'Verified',
                          '96%',
                          Color(0xFF4CAF50).withValues(alpha: 0.1),
                          Icon(Icons.verified, color: Color(0xFF4CAF50)),
                        ),
                        _buildStatCard(
                          'Issues',
                          '3',
                          Color(0xFFF44336).withValues(alpha: 0.1),
                          Icon(Icons.warning, color: Color(0xFFF44336)),
                        ),
                      ],
                    ),
                  ),
                ),

                // Recent Verifications
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Scans',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3E3F65),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'See All',
                            style: TextStyle(
                              color: Color(0xFF6C63FF),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Medication List
                SliverList(
                  delegate: SliverChildListDelegate([
                    _buildMedicineItem(
                      'Paracetamol 500mg',
                      'Verified • 2 hours ago',
                      'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=150',
                      true,
                    ),
                    _buildMedicineItem(
                      'Amoxicillin 250mg',
                      'Verified • Yesterday',
                      'https://images.unsplash.com/photo-1550572017-edd951b55104?w=150',
                      true,
                    ),
                    _buildMedicineItem(
                      'Unknown Medicine',
                      'Warning • 3 days ago',
                      'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=150',
                      false,
                    ),
                    SizedBox(height: 80), // Space for bottom nav bar
                  ]),
                ),
              ],
            ),

            // Floating Scan Button
            Positioned(
              right: 20,
              bottom: 90,
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF6C63FF), Color(0xFF5A49F2)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF6C63FF).withValues(alpha: 0.3),
                      spreadRadius: 1,
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
                  onPressed: () => _openScanner(context),
                ),
              ),
            ),
          ],
        ),
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(Icons.home_rounded, 'Home', 0),
              _buildNavItem(Icons.analytics_rounded, 'Reports', 1),
              SizedBox(width: 10), // Space for FAB
              _buildNavItem(Icons.shield_rounded, 'Verify', 2),
              _buildNavItem(Icons.person_rounded, 'Profile', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color bgColor, Icon icon) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon,
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3E3F65),
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicineItem(String name, String status, String imageUrl, bool isVerified) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3E3F65),
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        isVerified ? Icons.check_circle : Icons.warning,
                        size: 14,
                        color: isVerified ? Color(0xFF4CAF50) : Color(0xFFF44336),
                      ),
                      SizedBox(width: 4),
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isVerified ? Color(0xFF4CAF50).withValues(alpha: 0.1) : Color(0xFFF44336).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isVerified ? Icons.shield_rounded : Icons.shield_outlined,
                size: 16,
                color: isVerified ? Color(0xFF4CAF50) : Color(0xFFF44336),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = _selectedIndex == index;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? Color(0xFF6C63FF).withValues(alpha: 0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isSelected ? Color(0xFF6C63FF) : Colors.grey,
              size: 22,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Color(0xFF6C63FF) : Colors.grey,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _openScanner(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Scan Medicine QR Code'),
            backgroundColor: Color(0xFF6C63FF),
          ),
          body: MobileScanner(
            onDetect: (capture) {
              final barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                print('Barcode found! ${barcode.rawValue}');
              }
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}