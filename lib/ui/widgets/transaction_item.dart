import 'package:demo_sqflite_app/data/model/transactions.dart';
import 'package:flutter/material.dart';

import '../../data/constants/text_styles.dart';
import '../../data/database/database_service.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem(
      {Key? key, required this.transaction, required this.refresh})
      : super(key: key);
  final Transaction transaction;
  final Function refresh;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Image.asset(
              height: 30,
              width: 30,
              'assets/images/${transaction.type?.toLowerCase()}.png'),
          title: Text(
            '${transaction.data}',
            style: textStyle(20, Colors.black, FontWeight.w600),
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.delete_forever_rounded,
              color: Colors.redAccent,
            ),
            onPressed: () {
              DatabaseService.instance.deleteTransactions(transaction.id);
              refresh();
            },
          ),
        ),
      ),
    );
  }
}
