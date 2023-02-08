import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class NumericStepButton extends StatefulWidget {
  final int minValue;
  final int maxValue;
  int counter;

  final ValueChanged<int> onChanged;

  NumericStepButton(
      {super.key, this.minValue = 0, this.maxValue = 10, required this.onChanged, required this.counter});

  @override
  State<NumericStepButton> createState() {
    return _NumericStepButtonState();
  }
}

class _NumericStepButtonState extends State<NumericStepButton> {


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        MacosIconButton(
          icon: const MacosIcon(
            CupertinoIcons.minus,
            color: Colors.white54,
          ),
          onPressed: () {
            setState(() {
              if (widget.counter > widget.minValue) {
                widget.counter--;
              }
              widget.onChanged((widget.counter).toInt());
            });
          },
        ),
        Text(
          widget.counter.toString(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        MacosIconButton(
          icon: const MacosIcon(
            CupertinoIcons.plus,
            color: Colors.white54,
          ),
          onPressed: () {
            setState(() {
              if (widget.counter < widget.maxValue) {
                widget.counter++;
              }
              widget.onChanged(widget.counter.toInt());
            });
          },
        ),
      ],
    );
  }
}