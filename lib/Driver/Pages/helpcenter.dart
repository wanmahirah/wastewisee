import 'package:flutter/material.dart';

class DriverHelpCenter extends StatefulWidget {
  const DriverHelpCenter({super.key});

  @override
  State<DriverHelpCenter> createState() => _DriverHelpCenterState();
}

class _DriverHelpCenterState extends State<DriverHelpCenter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HELP CENTER"),
      ),
    );
  }
}
