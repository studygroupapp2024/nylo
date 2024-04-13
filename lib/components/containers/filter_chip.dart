import 'package:flutter/material.dart';

class MyFilterChip extends StatefulWidget {
  const MyFilterChip({
    super.key,
    required this.onChanged,
    required this.label,
    required this.selected,
  });

  final void Function(bool) onChanged;
  final String label;
  final bool selected;

  @override
  State<MyFilterChip> createState() => MyFilterChipState();
}

class MyFilterChipState extends State<MyFilterChip> {
  late bool _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.label),
      selected: _selected,
      selectedColor: Theme.of(context).colorScheme.tertiaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      onSelected: (value) {
        setState(() => _selected = value);
        widget.onChanged(value);
      },
    );
  }
}
