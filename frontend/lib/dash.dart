// dash.dart
import 'package:flutter/material.dart';

class DashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dash Page'),
      ),
      body: Center(
        child: Text('대시보드 화면!'),
      ),
    );
  }
}
