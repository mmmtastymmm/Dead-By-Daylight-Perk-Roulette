import 'package:flutter/material.dart';

typedef PerkCheckboxCallback = void Function(bool value);

class PerkCheckbox extends StatefulWidget {
  final String text;
  final PerkCheckboxCallback callback;

  const PerkCheckbox(this.text, this.callback, {Key? key}) : super(key: key);

  @override
  State<PerkCheckbox> createState() => _PerkCheckboxState();
}

class _PerkCheckboxState extends State<PerkCheckbox> {
  bool _checkValue = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(),
          flex: 1,
        ),
        Checkbox(
          value: _checkValue,
          onChanged: (bool? value) {
            setState(() {
              _checkValue = value!;
              widget.callback(value);
            });
          },
          fillColor: MaterialStateProperty.resolveWith((states) => Colors.red),
        ),
        Text(
          widget.text,
          style: const TextStyle(color: Colors.red),
        ),
        Expanded(
          child: Container(),
          flex: 1,
        )
      ],
    );
  }
}
