import 'package:flutter/material.dart';
import 'package:maze_solver_app/main.dart';

class SizeSlider extends StatefulWidget {
  const SizeSlider({super.key});

  @override
  State<SizeSlider> createState() => SizeSliderState();
}

class SizeSliderState extends State<SizeSlider> {
  double _sizeSliderValue = 20;

  @override
  Widget build(BuildContext context) {
    double max = 100;
    double min = 5;
    return Slider(
      value: _sizeSliderValue,
      max: max,
      min: min,
      // divisions: ((max - min) / 6).toInt(),
      onChanged: (double value) {
        setState(() {
          _sizeSliderValue = value;
          cellSizeNotifier.value = value.toInt();
        });
      },
    );
  }
}
