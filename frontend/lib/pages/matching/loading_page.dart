import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: RiveAnimation.asset(
          'assets/images/loading_airplane.riv',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
