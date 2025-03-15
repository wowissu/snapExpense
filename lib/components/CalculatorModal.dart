// show the calculator modal
import 'package:counting/components/Calculator.dart';
import 'package:counting/states/PurchaseRecord.dart';
import 'package:flutter/material.dart';

void showCalculatorModal(BuildContext context, PurchaseRecord purchaseRecord, {void Function()? onDelete}) {
  final contextSize = MediaQuery.of(context).size;
  final contextPadding = MediaQuery.of(context).padding;
  final modalHeight = contextSize.height * 0.9 - contextPadding.top;
  final colorScheme = Theme.of(context).colorScheme;

  showModalBottomSheet<void>(
    // elevation: 1,
    useRootNavigator: true,
    showDragHandle: true,
    enableDrag: false,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (_, StateSetter setSheetState) {
          return Container(
            constraints: BoxConstraints(maxHeight: modalHeight),
            height: modalHeight,
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Calculator(
                    purchaseRecord: purchaseRecord,
                    onCalculate: (CalculatorController ctr) {
                      // update sheet state
                      setSheetState(() {});
                    },
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          child: ElevatedButton(
                            onPressed: () {
                              _showDeleteConfirmationDialog(context, purchaseRecord, onConfirm: onDelete);
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(double.infinity, 48.0),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                              backgroundColor: colorScheme.error,
                            ),
                            child: Text("Delete", style: TextStyle(color: colorScheme.onTertiaryFixed, fontSize: 20)),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child:
                              purchaseRecord.isValid
                                  ? ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size(double.infinity, 48.0),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                      backgroundColor: colorScheme.secondary,
                                    ),
                                    child: Text("Save", style: TextStyle(color: colorScheme.onSecondary, fontSize: 20)),
                                  )
                                  : Container(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

void _showDeleteConfirmationDialog(
  BuildContext parentContext,
  PurchaseRecord purchaseRecord, {
  void Function()? onConfirm,
}) {
  showDialog<void>(
    context: parentContext,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Delete"),
        content: Text("Are you sure you want to delete this purchase record?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(parentContext);

              onConfirm?.call();
            },
            child: Text("Delete"),
          ),
        ],
      );
    },
  );
}
