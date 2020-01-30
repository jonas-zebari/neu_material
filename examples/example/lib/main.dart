import 'package:flutter/material.dart';
import 'package:neu_material/neu_material.dart';

const lavender = Color(0xFFC5B5FF);
const grey = Color(0xFFDCDCDC);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const space = EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    return MaterialApp(
      theme: ThemeData(
        accentColor: Colors.black,
        primaryColor: grey,
        scaffoldBackgroundColor: grey,
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 1,
            ),
          ),
        ),
      ),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              NeuMaterial(
                margin: space,
                padding: space,
                borderRadius: BorderRadius.circular(12),
                child: Text('Button!'),
              ),
              NeuMaterial(
                margin: EdgeInsets.all(12),
                padding: space,
                shape: BoxShape.circle,
                child: Icon(Icons.refresh),
              ),
              NeuMaterial(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.symmetric(horizontal: 48, vertical: 8),
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Text field!!1!',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
