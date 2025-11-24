import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Details Screen( Pokemon Name )')),
      body: Center(child: _DetailsBody()),
    );
  }
}

class _DetailsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Pokemon Details Here', style: TextStyle(fontSize: 24)),
        SizedBox(height: 16),
        // Add more details widgets here
      ],
    );
  }
}
