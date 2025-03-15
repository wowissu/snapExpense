import 'package:counting/AccountingPage.dart';
import 'package:counting/HomePage.dart';
import 'package:flutter/material.dart';

class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return HomePage(title: 'title title');
  } 
}

class CameraRoute extends StatelessWidget {
  const CameraRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Camera Route')),
      body: AccountingPage()
    );
  } 
}