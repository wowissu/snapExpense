import 'dart:collection';

import 'package:camera/camera.dart';
import 'package:counting/components/Calculator.dart';

class PurchaseRecord {
  String name = "";
  final XFile picture;
  final CalculatorController calculatorController;

  String get formula => calculatorController.formula;
  String get price => calculatorController.value;

  PurchaseRecord({required this.picture, required this.calculatorController});

  bool get isValid {
    return picture.path.isNotEmpty && calculatorController.isValid;
  }
}

class PurchaseRecordList extends ListBase<PurchaseRecord> implements List<PurchaseRecord> {
  final List<PurchaseRecord> _innerList = [];

  @override
  PurchaseRecord operator [](int index) {
    return _innerList[index];
  }

  @override
  void operator []=(int index, PurchaseRecord value) {
    _innerList[index] = value;
  }

  @override
  int get length => _innerList.length;

  @override
  set length(int newLength) => _innerList.length = newLength;

  @override
  void add(PurchaseRecord element) {
    _innerList.add(element);
  }

  @override
  void addAll(Iterable<PurchaseRecord> iterable) {
    _innerList.addAll(iterable);
  }
}
