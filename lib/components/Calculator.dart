import 'dart:io';

import 'package:counting/states/PurchaseRecord.dart';
import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';

const _allClean = "AC";
const _openParentheses = "(";
const _closeParentheses = ")";
const _delete = "del";
const _modulo = "%";
const _divide = "/";
const _multiply = "×";
const _subtract = "-";
const _add = "+";

final Map operatorsMatching = {_modulo: '%', _divide: '/', _multiply: '*', _subtract: '-', _add: '+'};

class CalculatorController {
  String _formula = "";
  String get formula => _formula;
  String _value = "";
  String get value => _value;

  void setFormula(String f) {
    _formula = f;
    _value = _calculate(f).toStringAsFixed(2);
  }

  void clear() {
    _formula = "";
    _value = "";
  }

  bool get isValid {
    return _formula.isNotEmpty && _value.isNotEmpty && double.tryParse(_value) != 0;
  }

  num _calculate(String formula) {
    if (formula.isEmpty) {
      return 0;
    }

    final operators = operatorsMatching.keys.map((e) => "\\$e").join();

    try {
      final interpretableFormula = formula
          // remove all empty
          .replaceAll(RegExp(r'\(\)'), "")
          // replace add a * between a ) and a (
          .replaceAll(RegExp(r'\)\('), ")*(")
          // replace add a * between a number and a (
          .replaceAllMapped(RegExp(r'([0-9]{1})\('), (match) {
            return '${match[1]}*(';
          })
          // replace add a * between a number and a )
          .replaceAllMapped(RegExp(r'\)([0-9]{1})'), (match) {
            return ')*${match[1]}';
          })
          // replace add a * between a number and a (
          .replaceAllMapped(RegExp(r'\(([0-9]+)\)'), (match) {
            return match[1]!;
          })
          // replace all operators to programming operators
          .replaceAllMapped(RegExp('[$operators]{1}'), (match) {
            return operatorsMatching[match[0]];
          })
          // remove last character if it's an operator
          .replaceAll(RegExp('[$operators]{1}\$'), "");

      // debugPrint("original formula: $formula");
      // debugPrint("interpretableFormula: $interpretableFormula");
      // debugPrint("interpretableFormula.interpret(): ${interpretableFormula.interpret().toDouble()}");

      return interpretableFormula.interpret();
    } catch (e) {
      debugPrint("error: $e");
      return 0;
    }
  }
}

class Calculator extends StatefulWidget {
  Calculator({super.key, this.width, this.height, this.onCalculate, required this.purchaseRecord});

  // final CalculatorController? controller;
  final double? width;
  final double? height;
  final void Function(CalculatorController result)? onCalculate;
  final PurchaseRecord purchaseRecord;

  @override
  createState() => CalculatorState();
}

class CalculatorState extends State<Calculator> {
  late final CalculatorController _calculatorController;

  final TextEditingController _formulaController = TextEditingController(text: '');
  final ScrollController _textFieldScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _calculatorController = widget.purchaseRecord.calculatorController;
    // initialize the formula controller with the formula from the calculator controller
    _formulaController.text = _calculatorController.formula;
  }

  /// reset the calculator
  void reset() {
    setState(() {
      _calculatorController.clear();
      _formulaController.clear();
      widget.onCalculate?.call(_calculatorController);
    });
  }

  /// delete a character at cursor point
  void delete() {
    final text = _formulaController.text;
    final selection = _formulaController.selection;

    _insertText(
      text: text.substring(0, selection.baseOffset - 1) + text.substring(selection.baseOffset),
      selection: TextSelection.collapsed(offset: selection.baseOffset - 1),
    );
  }

  void _onAddOpenParentheses() {
    final formula = _formulaController.text;
    final cursorOffset = _formulaController.selection.baseOffset;
    final beforeCursor = formula.characters.take(cursorOffset).join();
    final afterCursor = formula.characters.skip(cursorOffset).join();

    _insertText(text: "$beforeCursor($afterCursor", selection: TextSelection.collapsed(offset: cursorOffset + 1));
  }

  void _onAddCloseParentheses() {
    final formula = _formulaController.text;
    final cursorOffset = _formulaController.selection.baseOffset;
    final beforeCursor = formula.characters.take(cursorOffset).join();
    final afterCursor = formula.characters.skip(cursorOffset).join();

    _insertText(text: "$beforeCursor)$afterCursor", selection: TextSelection.collapsed(offset: cursorOffset + 1));
  }

  /// Add an operator to the formula.
  void _onOperatorAdded(String operator) {
    final formula = _formulaController.text;
    final cursorOffset = _formulaController.selection.baseOffset;

    if (
    // cannot add an operator at the beginning of the formula
    cursorOffset == 0 ||
        // cannot add an operator after an operator
        operatorsMatching.containsKey(formula.characters.elementAt(cursorOffset - 1)) ||
        // cannot add an operator before the last character
        (cursorOffset < formula.length && operatorsMatching.containsKey(formula.characters.elementAt(cursorOffset)))) {
      return;
    }

    final beforeCursor = formula.characters.take(cursorOffset).join();
    final afterCursor = formula.characters.skip(cursorOffset).join();

    _insertText(
      text: "$beforeCursor$operator$afterCursor",
      selection: TextSelection.collapsed(offset: cursorOffset + operator.length),
    );
  }

  void _onDotAdded() {
    final formula = _formulaController.text;

    // if the formula already contains a dot, don't add another one
    if (formula.contains('.')) {
      return;
    }

    _insertText(text: "$formula.", selection: TextSelection.collapsed(offset: formula.length + 1));
  }

  void _onNumberAdded(int number) {
    final formula = _formulaController.text;
    final cursorOffset = _formulaController.selection.baseOffset;
    final beforeCursor = formula.characters.take(cursorOffset).join();
    final afterCursor = formula.characters.skip(cursorOffset).join();

    _insertText(
      text: "$beforeCursor$number$afterCursor",
      selection: TextSelection.collapsed(offset: beforeCursor.length + number.toString().length),
    );
  }

  void _insertText({required String text, TextSelection? selection}) {
    _formulaController.value = TextEditingValue(
      text: text,
      selection: selection ?? TextSelection.collapsed(offset: text.length),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _textFieldScrollController.animateTo(
        _textFieldScrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 50),
        curve: Curves.easeOutCirc,
      );
    });

    // update calculator controller
    setState(() {
      _calculatorController.setFormula(text);
      widget.onCalculate?.call(_calculatorController);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget button(String txt, {TextStyle? textStyle, void Function()? onTap}) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: colorScheme.inversePrimary),
          child: Center(child: Text(txt, style: textStyle)),
        ),
      );
    }

    TextStyle valueTextStyle = TextStyle(fontSize: 40, fontWeight: FontWeight.bold);
    TextStyle formulaTextStyle = TextStyle(fontSize: 40, fontWeight: FontWeight.bold); // user input
    TextStyle numberTextStyle = TextStyle(fontSize: 40, fontWeight: FontWeight.bold);
    TextStyle operatorTextStyle = TextStyle(fontSize: 40, fontWeight: FontWeight.bold);

    return Container(
      width: widget.width,
      height: widget.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // formula input
          Container(
            width: double.infinity,
            alignment: Alignment.centerRight,
            child: TextFormField(
              textAlign: TextAlign.right,
              enableSuggestions: false,
              autofocus: true,
              scrollController: _textFieldScrollController,
              keyboardType: TextInputType.none,
              style: formulaTextStyle,
              controller: _formulaController,
              autocorrect: false,
              // disable underline
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                errorBorder: InputBorder.none,
              ),
            ),
          ),

          // value output
          Container(
            width: double.infinity,
            alignment: Alignment.centerRight,
            child: Text(
              _calculatorController.value,
              style: valueTextStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          SizedBox(height: 10),

          // buttons
          GridView.count(
            physics: NeverScrollableScrollPhysics(),
            primary: false,
            shrinkWrap: true,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 4,
            children: <Widget>[
              button(_allClean, textStyle: operatorTextStyle, onTap: () => reset()),
              button(_openParentheses, textStyle: operatorTextStyle, onTap: () => _onAddOpenParentheses()),
              button(_closeParentheses, textStyle: operatorTextStyle, onTap: () => _onAddCloseParentheses()),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: widget.width,
                  height: widget.height,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: colorScheme.inversePrimary),
                  clipBehavior: Clip.antiAlias,
                  child: Image.file(File(widget.purchaseRecord.picture.path), fit: BoxFit.cover),
                ),
              ),
              // button(_modulo, textStyle: operatorTextStyle, onTap: () => _onOperatorAdded(_modulo)),
              button('7', textStyle: numberTextStyle, onTap: () => _onNumberAdded(7)),
              button('8', textStyle: numberTextStyle, onTap: () => _onNumberAdded(8)),
              button('9', textStyle: numberTextStyle, onTap: () => _onNumberAdded(9)),
              button(_divide, textStyle: operatorTextStyle, onTap: () => _onOperatorAdded(_divide)),
              button('4', textStyle: numberTextStyle, onTap: () => _onNumberAdded(4)),
              button('5', textStyle: numberTextStyle, onTap: () => _onNumberAdded(5)),
              button('6', textStyle: numberTextStyle, onTap: () => _onNumberAdded(6)),
              button(_multiply, textStyle: operatorTextStyle, onTap: () => _onOperatorAdded(_multiply)),
              button('1', textStyle: numberTextStyle, onTap: () => _onNumberAdded(1)),
              button('2', textStyle: numberTextStyle, onTap: () => _onNumberAdded(2)),
              button('3', textStyle: numberTextStyle, onTap: () => _onNumberAdded(3)),
              button(_subtract, textStyle: operatorTextStyle, onTap: () => _onOperatorAdded(_subtract)),
              button('0', textStyle: numberTextStyle, onTap: () => _onNumberAdded(0)),
              button('.', textStyle: numberTextStyle, onTap: () => _onDotAdded()),
              button(_delete, textStyle: numberTextStyle, onTap: () => delete()),
              button(_add, textStyle: operatorTextStyle, onTap: () => _onOperatorAdded(_add)),
            ],
          ),
        ],
      ),
    );
  }
}
