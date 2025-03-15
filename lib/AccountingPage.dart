import 'dart:io';

import 'package:camera/camera.dart';
import 'package:counting/components/Calculator.dart';
import 'package:counting/components/CalculatorModal.dart';
import 'package:counting/components/CameraScreen.dart';
import 'package:counting/components/PurchaseRecordListView.dart';
import 'package:counting/helpers/currencyHelper.dart';
import 'package:counting/states/PurchaseRecord.dart';
import 'package:flutter/material.dart';

class AccountingPage extends StatefulWidget {
  const AccountingPage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<AccountingPage> createState() => _AccountingPageState();
}

class _AccountingPageState extends State<AccountingPage> {
  late PageController _pageViewController;
  static PurchaseRecordList _purchaseRecordList = PurchaseRecordList();

  _addPurchaseRecord(PurchaseRecord purchaseRecord) {
    _purchaseRecordList.add(purchaseRecord);
  }

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    void _showCalculatorModal(PurchaseRecord purchaseRecord) {
      showCalculatorModal(
        context,
        purchaseRecord,
        onDelete: () {
          setState(() {
            _purchaseRecordList.remove(purchaseRecord);
          });
        },
      );
    }

    Widget pictureBox(PurchaseRecord purchaseRecord) {
      return GestureDetector(
        onTap: () {
          _showCalculatorModal(purchaseRecord);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(color: colorScheme.primary, width: 1.0, strokeAlign: BorderSide.strokeAlignOutside),
          ),
          clipBehavior: Clip.antiAlias,
          width: 48.0,
          height: 48.0,
          margin: const EdgeInsets.all(5.0),
          child: Image.file(
            File(purchaseRecord.picture.path),
            fit: BoxFit.cover,
            // width: double.infinity,
            // height: double.infinity,
          ),
        ),
      );
    }

    return PageView(
      onPageChanged: (int index) {
        debugPrint(index.toString());
      },
      controller: _pageViewController,
      children: [
        Scaffold(
          body: Stack(
            // fit: StackFit.expand,
            children: [
              // Container(width: 80, height: 80),
              CameraScreen(
                onTakePicture: (XFile xFile) async {
                  setState(() {
                    final purchaseRecord = PurchaseRecord(picture: xFile, calculatorController: CalculatorController());
                    _addPurchaseRecord(purchaseRecord);
                    _showCalculatorModal(purchaseRecord);
                  });
                },
                abovePanelChild: SizedBox(
                  height: 58.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [for (final record in _purchaseRecordList) pictureBox(record)],
                  ),
                ),
              ),
            ],
          ),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text('Accounting'),
            leading: IconButton(
              onPressed: () {
                _pageViewController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
              },
              icon: Icon(Icons.arrow_back),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: PurchaseRecordListView(purchaseRecordList: _purchaseRecordList),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
