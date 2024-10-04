import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
  }

  class _HomePageState extends State<HomePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Face detector'),
      ),
      body: _body(),
    );
  }
    Widget _body()=>Center(
      child: SizedBox(
        width: 350,
        height: 80,
        child: OutlinedButton(
          style: ButtonStyle(
            side: WidgetStateProperty.all(
              const BorderSide(
                color: Colors.blue,width: 1.0, style: BorderStyle.solid,
              ),
            ),
          ),
          onPressed: () {  },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 24,
                ),
              ),
              Text('Go to face detector:',
                style: TextStyle(
                    fontSize: 20),
              )
            ],
          ),
        ),

      ),
    );
}