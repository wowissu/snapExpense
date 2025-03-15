import 'dart:io';

import 'package:counting/helpers/currencyHelper.dart';
import 'package:counting/states/PurchaseRecord.dart';
import 'package:flutter/material.dart';

class PurchaseRecordItem extends StatefulWidget {
  const PurchaseRecordItem({super.key, required this.record, this.onDelete});

  final PurchaseRecord record;
  final void Function(PurchaseRecord)? onDelete;
  @override
  State<PurchaseRecordItem> createState() => _PurchaseRecordItemState();
}

class _PurchaseRecordItemState extends State<PurchaseRecordItem> {
  @override
  Widget build(BuildContext context) {
    final record = widget.record;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      color: colorScheme.inversePrimary,
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Dismissible(
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 10.0),
          child: Icon(Icons.delete),
        ),
        direction: DismissDirection.endToStart,
        key: Key(record.picture.path),
        child: ListTile(
          dense: true,
          leading: CircleAvatar(backgroundImage: Image.file(File(record.picture.path), fit: BoxFit.cover).image),
          title: Text(CurrencyHelper.format(double.parse(record.price)), style: TextStyle(fontSize: 25)),
          subtitle: Text(record.formula, style: TextStyle(fontSize: 12)),
          trailing: Text(record.name.isEmpty ? "Untitled" : record.name, style: TextStyle(fontSize: 15)),
        ),
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            this.widget.onDelete?.call(record);
          }
        },
      ),
    );
  }
}
