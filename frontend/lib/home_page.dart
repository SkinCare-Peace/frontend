import 'package:flutter/material.dart';
import 'face_detector_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face detector'),
      ),
      body: _body(),
    );
  }

  Widget _body() => Center(
        child: SizedBox(
          width: 350,
          height: 80,
          child: OutlinedButton(
            style: ButtonStyle(
              side: WidgetStateProperty.all(
                const BorderSide(
                  color: Colors.blue,
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
              ),
            ),

// 누르면 face detector 로 이동함
            onPressed: ()  => Navigator.push(context,
            MaterialPageRoute(
              builder: (context)=> FaceDetectorPage())),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIconWidget(Icons.arrow_forward_ios),
                const Text(
                  'Go to face detector:',
                  style: TextStyle(fontSize: 20),
                ),
                _buildIconWidget(Icons.arrow_back_ios),
              ],
            ),
          ),
        ),
      );

// 아이콘 생성용 
  Widget _buildIconWidget(final IconData icon) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Icon(
          icon,
          size: 24,
        ),
      );
}

