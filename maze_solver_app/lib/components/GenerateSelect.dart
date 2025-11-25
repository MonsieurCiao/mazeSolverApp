import 'package:flutter/material.dart';

class Generateselect extends StatelessWidget {
  final String algorithm;
  final void Function(String) onChanged;
  const Generateselect({
    required this.algorithm,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: algorithm,
      items: ['DFS', 'PRIM'].map((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) onChanged(newValue);
      },
    );
  }
}
