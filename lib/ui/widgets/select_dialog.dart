import 'package:flutter/material.dart';

class SelectDialog extends StatelessWidget {
  final List<Map> items;
  SelectDialog({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => InkWell(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Theme.of(context).colorScheme.primary))),
              child: Text(
                items[index]['text'],
                style: const TextStyle(fontSize: 18),
              ),
            ),
            onTap: () => Navigator.of(context).pop(items[index]['value']),
          ),
        ),
      ),
    );
  }
}
