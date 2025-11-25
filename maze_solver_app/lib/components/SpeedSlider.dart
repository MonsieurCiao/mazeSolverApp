import 'package:flutter/material.dart';
import 'package:maze_solver_app/main.dart';

class SpeedSlider extends StatefulWidget {
  const SpeedSlider({super.key});

  @override
  State<SpeedSlider> createState() => SpeedSliderState();
}

class SpeedSliderState extends State<SpeedSlider> {
  double _speedSliderValue = 20;

  @override
  Widget build(BuildContext context) {
    double max = 500;
    double min = 0;
    return Slider(
      value: _speedSliderValue,
      max: max,
      min: min,
      // divisions: ((max - min) / 6).toInt(),
      onChanged: (double value) {
        setState(() {
          _speedSliderValue = value;
          speedNotifier.value = value.toInt();
        });
      },
    );
  }
}
