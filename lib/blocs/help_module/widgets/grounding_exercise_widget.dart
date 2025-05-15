import 'package:flutter/material.dart';

class GroundingExerciseWidget extends StatefulWidget {
  const GroundingExerciseWidget({super.key});

  @override
  State<GroundingExerciseWidget> createState() => _GroundingExerciseWidgetState();
}

class _GroundingExerciseWidgetState extends State<GroundingExerciseWidget> {
  final List<bool> _checkedItems = [false, false, false, false, false, false];
  final List<String> _items = [
    "5 cosas que puedes ver:",
    "4 cosas que puedes tocar:",
    "3 cosas que puedes oír:",
    "2 cosas que puedes oler:",
    "1 cosa que puedes saborear:",
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        // Only show the current item and checked items
        if (index > 0 && !_checkedItems[index - 1] && !_checkedItems[index]) {
          return const SizedBox.shrink();
        }

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (index < _items.length - 1) // Don't show checkbox for last item
                      Checkbox(
                        value: _checkedItems[index],
                        onChanged: (value) {
                          setState(() {
                            _checkedItems[index] = value!;
                          });
                        },
                      ),
                    Expanded(
                      child: Text(
                        _items[index],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _checkedItems[index]
                              ? Colors.green.shade700
                              : Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                  ],
                ),
                if (index < _items.length - 1 && _checkedItems[index])
                  const Padding(
                    padding: EdgeInsets.only(left: 48, top: 8),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Escribe tus respuestas aquí...",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                if (index == _items.length - 1) // Description field for last item
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Describe el objeto con todos los detalles que puedas...",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}