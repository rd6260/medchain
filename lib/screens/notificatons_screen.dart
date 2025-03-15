import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {"title": "Medicine Verified", "body": "Your scanned medicine is authentic.", "time": "5m ago"},
    {"title": "Batch Expiry Warning", "body": "Batch #1234 is expiring soon.", "time": "1h ago"},
    {"title": "New Update", "body": "Blockchain database updated.", "time": "3h ago"},
    {"title": "Scan Alert", "body": "Suspicious medicine detected!", "time": "1d ago"},
  ];

  NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white70],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0),
                leading: Icon(
                  Icons.notifications,
                  color: Color(0xFF6C63FF),
                  size: 30,
                ),
                title: Text(
                  notification["title"]!,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  notification["body"]!,
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
                trailing: Text(
                  notification["time"]!,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
