import 'package:flutter/material.dart';
import 'package:neu_material/neu_material.dart';

const lavender = Color(0xFFC5B5FF);
const grey = Color(0xFFDCDCDC);

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

const Duration _duration = Duration(milliseconds: 100);
const Offset _kInitialElevation = Offset(5, 5);
const Offset _kDepressedElevation = Offset.zero;
const double _kInitialBlur = 8.0;
const double _kDepressedBlur = 0.0;

class _MyAppState extends State<MyApp> {
  Offset _iconElevation = _kInitialElevation;
  double _iconBlur = _kInitialBlur;
  bool _pressed = false;

  void _onTap() {
    setState(() {
      _pressed = !_pressed;
      _iconElevation = _pressed ? _kDepressedElevation : _kInitialElevation;
      _iconBlur = _pressed ? _kDepressedBlur : _kInitialBlur;
    });
  }

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
                duration: _duration,
                margin: space,
                padding: space,
                colorFactor: 1.05,
                shadowFactor: 1.15,
                surfaceCurve: SurfaceCurve.concave,
                borderRadius: BorderRadius.circular(12),
                child: Text('Button!'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Toggle button =>'),
                  GestureDetector(
                    onTap: _onTap,
                    child: NeuMaterial(
                      duration: _duration,
                      margin: EdgeInsets.all(12),
                      padding: space,
                      blur: _iconBlur,
                      elevation: _iconElevation,
                      surfaceCurve: SurfaceCurve.convex,
                      shape: BoxShape.circle,
                      child: Icon(Icons.refresh),
                    ),
                  ),
                ],
              ),
              NeuMaterial(
                duration: _duration,
                margin: EdgeInsets.only(left: 16, top: 4, right: 16, bottom: 6),
                padding: EdgeInsets.symmetric(horizontal: 48, vertical: 8),
                borderRadius: BorderRadius.circular(12),
                shadowFactor: 1.25,
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
