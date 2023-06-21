import 'package:demo_sqflite_app/data/database/database_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddTransactionsWidget extends StatefulWidget {
  const AddTransactionsWidget({Key? key, required this.function}) : super(key: key);
  final Function function;
  @override
  State<AddTransactionsWidget> createState() => _AddTransactionsWidgetState();
}

class _AddTransactionsWidgetState extends State<AddTransactionsWidget> {
  TextEditingController textEditingController = TextEditingController();
  String dropdownValue = 'Income';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add'),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: TextFormField(
              controller: textEditingController,
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(label: Text('Amount')),
            ),
          ),
          DropdownButton(
            value: dropdownValue,
            hint: const Text('Choose'),
            items: const [
              DropdownMenuItem(
                value: 'Income',
                child: Text('Income'),
              ),
              DropdownMenuItem(
                value: 'Expense',
                child: Text('Expense'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                dropdownValue = value!;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.function();
            Navigator.of(context).pop();
            textEditingController.clear();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
        TextButton(
          onPressed: () async {
            int success = await DatabaseService.instance.addTransactions({
              DatabaseService.type: dropdownValue,
              DatabaseService.date: DateTime.now().toIso8601String(),
              DatabaseService.data: double.parse(textEditingController.text)
            });
            if (kDebugMode) {
              print(success);
            }
            widget.function();
            // ignore: use_build_context_synchronously
            Navigator.of(context).pop();
            textEditingController.clear();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
