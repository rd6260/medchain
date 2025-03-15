import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:medchain/screens/not_authentic_med_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class MedicineVerificationScreen extends StatelessWidget {
  final String content;

  const MedicineVerificationScreen({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    late Map<String, dynamic> data;
    try {
      data = jsonDecode(content);
    } catch (e) {
      return NotAuthenticMedScreen();
    }

    // Format dates for better readability
    final manufactureDate = _formatDate(data['manufacture_date']);
    final expiryDate = _formatDate(data['expiry_date']);

    // Calculate if medicine is expired
    final bool isExpired = _isExpired(data['expiry_date']);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Medicine Verification"),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareDetails(data),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white70],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildVerificationCard(
                context,
                data,
                manufactureDate,
                expiryDate,
                isExpired,
              ),
              const SizedBox(height: 20),
              _buildBlockchainInfoCard(context, data),
              const SizedBox(height: 20),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerificationCard(
    BuildContext context,
    Map<String, dynamic> data,
    String manufactureDate,
    String expiryDate,
    bool isExpired,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8,
      shadowColor: Colors.green.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.verified_rounded,
                  color: Colors.green.shade600,
                  size: 40,
                ),
                const SizedBox(width: 12),
                Text(
                  "Authentic Medicine",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMedicineNameSection(data['name']),
                  const Divider(height: 24),
                  _infoTile(
                    "Manufacturer",
                    data['manufacturer'],
                    Icons.business,
                  ),
                  _infoTile(
                    "Batch Number",
                    data['batch_number'],
                    Icons.confirmation_number,
                  ),
                  _infoTile(
                    "Manufacture Date",
                    manufactureDate,
                    Icons.calendar_today,
                  ),
                  _infoTile(
                    "Expiry Date",
                    expiryDate,
                    Icons.event_busy,
                    isExpired ? Colors.red : null,
                  ),
                ],
              ),
            ),
            if (isExpired) _buildExpiryWarning(),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicineNameSection(String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "MEDICINE NAME",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name.toUpperCase(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildExpiryWarning() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red.shade700),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "This medicine has expired. Please do not use.",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.red.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlockchainInfoCard(
    BuildContext context,
    Map<String, dynamic> data,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8,
      shadowColor: Colors.blue.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Blockchain Verification",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            const SizedBox(height: 16),
            _buildHashEntry(
              "Blockchain TX ID",
              data['blockchain_tx_id'],
              onTap: () => _viewOnBlockchain(data['blockchain_tx_id']),
            ),
            const SizedBox(height: 12),
            _buildHashEntry(
              "Verification Hash",
              data['verificationHash'],
              onTap: () => _copyToClipboard(context, data['verificationHash']),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHashEntry(String title, String value, {VoidCallback? onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'monospace',
                      color: Colors.blue.shade800,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  title.contains("TX ID") ? Icons.open_in_new : Icons.copy,
                  size: 16,
                  color: Colors.blue.shade700,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.qr_code_scanner),
            label: const Text("Scan Another"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6C63FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        OutlinedButton.icon(
          onPressed: () => _reportIssue(context),
          icon: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: const Icon(Icons.report_problem),
          ),
          label: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: const Text("Report Issue"),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.orange.shade800,
            side: BorderSide(color: Colors.orange.shade800),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoTile(
    String title,
    String value,
    IconData icon, [
    Color? valueColor,
  ]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.green.shade700, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateStr; // Return original if parsing fails
    }
  }

  bool _isExpired(String expiryDateStr) {
    try {
      final expiryDate = DateTime.parse(expiryDateStr);
      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
      return false;
    }
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _viewOnBlockchain(String txId) async {
    // Replace with your blockchain explorer URL
    final url = Uri.parse('https://explorer.medchain.com/tx/$txId');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _shareDetails(Map<String, dynamic> data) {
    // Implement share functionality
  }

  void _reportIssue(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Report Counterfeit Medicine'),
            content: const Text(
              'If you suspect this medicine is counterfeit, please submit a report. '
              'Our team will investigate and take appropriate action.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Implement report submission
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Report submitted successfully'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                ),
                child: const Text('Submit Report'),
              ),
            ],
          ),
    );
  }
}
