import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(CollectionStatusApp());
}

class CollectionStatusApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Collection Status Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CollectionStatusPage(),
    );
  }
}

class CollectionStatusPage extends StatefulWidget {
  @override
  _CollectionStatusPageState createState() => _CollectionStatusPageState();
}

class _CollectionStatusPageState extends State<CollectionStatusPage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  List<String> binLocations = [
    'Melaka International Trade Centre (MITC)',
    'Ayer Keroh',
    'Bukit Beruang',
    'Ayer Keroh',
    'Taman Tasik Utama',
    'Bandaraya Melaka',
    'Klebang',
    'Melaka International Trade Centre (MITC)',
    'Ayer Keroh',
    'Bandaraya Melaka'
  ];

  List<bool> binStatus = List.generate(10, (index) => false);

  // Function to update the status of a bin
  void updateBinStatus(int index, bool value) {
    setState(() {
      binStatus[index] = value;
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize the notification plugin
    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your channel name',
      'your channel description',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Bins Picked Up',
      'Bins have been collected.',
      platformChannelSpecifics,
      payload: 'notification',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Collection Status'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'List of Bins for Collection:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bin ID: ${index + 1}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Location: ${binLocations[index]}',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    value: binStatus[index],
                    onChanged: (bool? value) {
                      updateBinStatus(index, value ?? false);
                    },
                  );
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  print('Updated Bin Status: $binStatus');
                  showNotification(); // Show notification on status update
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Collection Status Updated')),
                  );
                },
                child: Text('Submit Collection Status'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
