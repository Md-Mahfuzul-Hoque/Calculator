import 'package:flutter/material.dart';
import 'widget/build_button.dart';

class Calculator extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  Calculator({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _output = '0';
  String _input = '0';
  String _ope = '';
  double num1 = 0;
  double num2 = 0;

  List<String> _history = [];
  bool _showHistory = false;

  double calculateResult(double n1, String operator, double n2) {
    if (operator == '+') return n1 + n2;
    if (operator == '-') return n1 - n2;
    if (operator == '*') return n1 * n2;
    if (operator == '÷') {
      return (n2 != 0) ? n1 / n2 : double.nan;
    }
    return 0;
  }

  void buttonPress(String value) {
    setState(() {
      if (value == 'AC') {
        _output = '0';
        _input = '0';
        _ope = '';
        num1 = 0;
        num2 = 0;
        _history = [];
      } else if (value == 'history') {
        _showHistory = !_showHistory;
        return;
      } else if (value == 'back') {
        if (_input.length > 1 && _input != 'Error') {
          _input = _input.substring(0, _input.length - 1);
        } else {
          _input = '0';
        }
        _output = _input;
      } else if (value == '+/-') {
        if (_input != '0' && _input != 'Error') {
          if (_input.startsWith('-')) {
            _input = _input.substring(1);
          } else {
            _input = '-$_input';
          }
          _output = _input;
        }
      } else if (value == '.') {
        if (!_input.contains('.')) {
          _input += value;
        }
        _output = _input;
      } else if (value == '%') {
        if (_input != '0' && _input != 'Error') {
          double val = double.tryParse(_input) ?? 0;
          double result = val / 100;

          _output = result.toString();
          _input = _output;
          num1 = result;
          _ope = '';
          num2 = 0;
        }
        return;
      } else if (['+', '-', '*', '÷'].contains(value)) {
        if (_ope.isNotEmpty && _input != '0') {
          num2 = double.tryParse(_input) ?? 0;
          double result = calculateResult(num1, _ope, num2);

          _output = result.toString().endsWith('.0')
              ? result.toStringAsFixed(0)
              : result.toString();

          num1 = result;
          _ope = value;
          _input = '0';
          return;
        }

        if (num1 == 0) {
          num1 = double.tryParse(_input) ?? 0;
        }

        _ope = value;
        _input = '0';
        _output = num1.toString().endsWith('.0') ? num1.toStringAsFixed(0) : num1.toString();
        return;
      } else if (value == '=') {
        if (_ope.isEmpty || _input == '0') return;

        num2 = double.tryParse(_input) ?? 0;
        double result = calculateResult(num1, _ope, num2);
        String tempOutput = '';

        if (result.isNaN) {
          tempOutput = 'Error';
        }

        String num1Str = num1.toString().endsWith('.0') ? num1.toStringAsFixed(0) : num1.toString();
        String num2Str = num2.toString().endsWith('.0') ? num2.toStringAsFixed(0) : num2.toString();

        if (tempOutput == 'Error') {
          _output = 'Error';
          _history.insert(0, "$num1Str $_ope $num2Str = Error");
        } else {
          _output = result.toString().endsWith('.0')
              ? result.toStringAsFixed(0)
              : result.toString();
          _history.insert(0, "$num1Str $_ope $num2Str = $_output");
        }

        _input = _output;
        num1 = double.tryParse(_output) ?? 0;
        _ope = '';
        num2 = 0;
      } else {
        if (_input == '0') {
          _input = value;
        } else {
          _input += value;
        }
        _output = _input;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = widget.isDarkMode;
    final bgColor = isDarkMode ? Colors.black : Colors.grey[200];
    final textColor = isDarkMode ? Colors.white : Colors.black;

    final funcButtonColor = isDarkMode ? Colors.deepPurple : Colors.purple;
    final operatorButtonColor = isDarkMode ? Colors.teal : Colors.teal.shade700;

    final equalButtonColor = isDarkMode ? Colors.white : Colors.red;

    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.history,
                    color: textColor,
                    size: isLandscape ? 20 : 28,
                  ),
                  onPressed: () => buttonPress('history'),
                ),

                IconButton(
                  icon: Icon(
                    isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                    color: textColor,
                  ),
                  onPressed: widget.toggleTheme,
                ),
              ],
            ),

            Expanded(
              child: _showHistory
                  ? Container(
                alignment: Alignment.topRight,
                padding: const EdgeInsets.all(20),
                constraints: isLandscape
                    ? BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4)
                    : null,
                child: ListView.builder(
                  reverse: true,
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    final historyItem = _history[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        historyItem,
                        style: TextStyle(
                          fontSize: isLandscape ? 18 : 24,
                          color: textColor.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.end,
                      ),
                    );
                  },
                ),
              )
                  : Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _output,
                      style: TextStyle(
                        fontSize: isLandscape ? 45 : 65,
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Column(
              children: [
                Row(
                  children: [
                    BuildButton(onclick: () => buttonPress('AC'), text: 'AC', color: funcButtonColor),

                    BuildButton(onclick: () => buttonPress('back'), text: '', icon: Icons.backspace, color: funcButtonColor),

                    BuildButton(onclick: () => buttonPress('+/-'), text: '+/-', color: funcButtonColor),
                    BuildButton(onclick: () => buttonPress('÷'), text: '÷', color: operatorButtonColor),
                  ],
                ),
                Row(
                  children: [
                    BuildButton(onclick: () => buttonPress('7'), text: '7'),
                    BuildButton(onclick: () => buttonPress('8'), text: '8'),
                    BuildButton(onclick: () => buttonPress('9'), text: '9'),
                    BuildButton(onclick: () => buttonPress('*'), text: '×', color: operatorButtonColor),
                  ],
                ),
                Row(
                  children: [
                    BuildButton(onclick: () => buttonPress('4'), text: '4'),
                    BuildButton(onclick: () => buttonPress('5'), text: '5'),
                    BuildButton(onclick: () => buttonPress('6'), text: '6'),
                    BuildButton(onclick: () => buttonPress('-'), text: '−', color: operatorButtonColor),
                  ],
                ),
                Row(
                  children: [
                    BuildButton(onclick: () => buttonPress('1'), text: '1'),
                    BuildButton(onclick: () => buttonPress('2'), text: '2'),
                    BuildButton(onclick: () => buttonPress('3'), text: '3'),
                    BuildButton(onclick: () => buttonPress('+'), text: '+', color: operatorButtonColor),
                  ],
                ),
                Row(
                  children: [
                    BuildButton(onclick: () => buttonPress('%'), text: '%', color: funcButtonColor),
                    BuildButton(onclick: () => buttonPress('0'), text: '0'),
                    BuildButton(onclick: () => buttonPress('.'), text: '.', color: funcButtonColor),
                    BuildButton(onclick: () => buttonPress('='), text: '=', color: equalButtonColor),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}