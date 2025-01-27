import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:penny_pilot/database/db_txns.dart';
import 'package:penny_pilot/pages/home_page.dart';
import 'package:penny_pilot/utils/icon_list.dart';
import 'package:penny_pilot/models/transaction.dart';
import 'package:penny_pilot/widgets/transaction_options_dialog.dart';

class TransactionTile extends StatefulWidget {
  TransactionTile({
    super.key,
    required this.txn,
    required this.page,
  });

  var appicons = AppIcons();
  final Txn? txn;
  final int page;

  @override
  State<TransactionTile> createState() => _TransactionTile();
}

class _TransactionTile extends State<TransactionTile> {
  Txn? txn;
  Color? color;

  @override
  void initState() {
    super.initState();
    txn = widget.txn!;
      color = txn!.type == 'Expenses' 
        ? Colors.red 
        : Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 10),
              color: Colors.grey.withOpacity(0.09),
              blurRadius: 10,
              spreadRadius: 4,
            ),
          ],
        ),
        child: ListTile(
          minVerticalPadding: 10,
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          leading: SizedBox(
            width: 70,
            height: 100,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: color?.withOpacity(0.2),
              ),
              child: Center(
                child: FaIcon( (txn!.type == 'Expenses')
                    ? widget.appicons.getExpenseCategoryIcon(txn!.category)
                    : widget.appicons.getIncomeCategoryIcon(txn!.category) 

                ),
              ), 
            ),
          ),  
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(txn?.category ?? '')),
              Row(
                children: [
                  Icon(Icons.currency_rupee_sharp, color: color, size: 17),
                  Text(
                    '${txn?.amount ?? 0.0}',
                    style: TextStyle(color: color, fontSize: 17),
                  )
                ],
              ),
              const SizedBox(width: 5),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    txn?.description ?? '!!!!',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  Text(
                    txn?.date ?? "DD / MM / YYYY",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: TransactionOptions(
                            page: widget.page,
                            txn: txn,
                            editTxnState: EditTxnStates.edit,
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.edit, color: Colors.grey),
                  ),
                  IconButton(
                    onPressed: () async {
                      await DatabaseTxn.instance.deleteTxn(txn!);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage(selectedIndex: widget.page)),
                      );
                    }, 
                    icon: Icon(Icons.delete, color: Colors.grey,)
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
