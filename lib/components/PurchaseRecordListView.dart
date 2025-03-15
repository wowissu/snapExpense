import 'package:counting/components/CalculatorModal.dart';
import 'package:counting/components/PurchaseRecordItem.dart';
import 'package:counting/states/PurchaseRecord.dart';
import 'package:flutter/material.dart';

class PurchaseRecordListView extends StatefulWidget {
  const PurchaseRecordListView({super.key, required this.purchaseRecordList});

  final PurchaseRecordList purchaseRecordList;

  @override
  State<PurchaseRecordListView> createState() => _PurchaseRecordListViewState();
}

class _PurchaseRecordListViewState extends State<PurchaseRecordListView> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    void _showCalculatorModal(PurchaseRecord purchaseRecord) {
      showCalculatorModal(
        context,
        purchaseRecord,
        onDelete: () {
          setState(() {
            widget.purchaseRecordList.remove(purchaseRecord);
          });
        },
      );
    }

    return ListView.separated(
      itemCount: widget.purchaseRecordList.length,
      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10.0),
      itemBuilder: (BuildContext context, int index) {
        final record = widget.purchaseRecordList[index];

        return GestureDetector(
          onTap: () {
            _showCalculatorModal(record);
          },
          child: PurchaseRecordItem(
            record: record,
            onDelete: (record) {
              setState(() {
                widget.purchaseRecordList.remove(record);
              });
            },
          ),
        );
      },
    );
  }
}
