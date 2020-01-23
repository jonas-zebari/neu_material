import 'package:flutter/material.dart';
import 'package:neu_material/neu_material.dart';

const lavender = Color(0xFFDCDCDC);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        backgroundColor: lavender,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              for (final type in NeuMaterialType.values)
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: NeuMaterial(
                    type: type,
                    shape: BoxShape.circle,
                    child: SizedBox(height: 150, width: 150),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
