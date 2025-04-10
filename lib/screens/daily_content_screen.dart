import 'package:flutter/material.dart';

class DailyContentScreen extends StatefulWidget {
  const DailyContentScreen({super.key});

  @override
  State<DailyContentScreen> createState() => _DailyContentScreenState();
}

class _DailyContentScreenState extends State<DailyContentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Daily Content Screen'),
      ),
    );
  }
}
