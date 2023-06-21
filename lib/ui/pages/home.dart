import 'package:demo_sqflite_app/data/database/database_service.dart';
import 'package:demo_sqflite_app/ui/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import '../../data/constants/text_styles.dart';
import '../../data/model/transactions.dart';
import '../widgets/add_widget.dart';
import '../widgets/custom_chip.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = 'All';

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          Text(
            'CashFlow',
            style: textStyle(40, Colors.black, FontWeight.w500),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = 'All';
                    });
                  },
                  child: const CustomChip('All')),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = 'Income';
                    });
                  },
                  child: const CustomChip('Income')),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = 'Expense';
                    });
                  },
                  child: const CustomChip('Expense')),
            ],
          ),
          Expanded(
            child: FutureBuilder(
              future: DatabaseService.instance.getTransaction(selectedCategory),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<Transaction> transactionList = List.generate(
                  snapshot.data!.length.toInt(),
                  (index) => Transaction(
                    id: snapshot.data?[index]['columnID'] as int?,
                    date: snapshot.data![index]['date'] as String?,
                    data: snapshot.data![index]['data'] as double?,
                    type: snapshot.data![index]['type'] as String?,
                  ),
                );

                return GroupedListView<Transaction, String>(
                  cacheExtent: 200,
                  order: GroupedListOrder.DESC,
                  elements: transactionList,
                  // reverse: true,
                  groupHeaderBuilder: (date) {
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        DateFormat('EEEE, dd MMMM, yyyy')
                            .format(DateTime.parse(date.date!)),
                        style: textStyle(20, Colors.black54, FontWeight.w600),
                      ),
                    );
                  },
                  groupBy: (transaction) => DateFormat.MMMd()
                      .format(DateTime.parse(transaction.date!)),
                  itemBuilder: (context, transaction) {
                    return TransactionItem(
                      transaction: transaction,
                      refresh: refresh,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AddTransactionsWidget(function: refresh);
            },
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
