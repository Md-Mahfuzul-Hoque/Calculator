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

  void buttonPress(String value) {
    setState(() {
      if (value == 'AC') {
        _output = '0';
        _input = '0';
        _ope = '';
        num1 = 0;
        num2 = 0;
      } else if (value == 'back') {
        if (_input.length > 1) {
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
      } else if (['+', '-', '*', '÷', '%'].contains(value)) {
        if (num1 != 0 && _input == '0' && _ope.isNotEmpty) {
          _ope = value;
          return;
        }

        num1 = double.tryParse(_input) ?? 0;
        _ope = value;
        _input = '0';
        _output = num1.toString().endsWith('.0') ? num1.toStringAsFixed(0) : num1.toString();
        return;
      } else if (value == '=') {
        if (_ope.isEmpty || _input == '0') return;

        num2 = double.tryParse(_input) ?? 0;
        double result = 0;
        String tempOutput = '';

        if (_ope == '+') {
          result = num1 + num2;
        } else if (_ope == '-') {
          result = num1 - num2;
        } else if (_ope == '*') {
          result = num1 * num2;
        } else if (_ope == '÷') {
          if (num2 != 0) {
            result = num1 / num2;
          } else {
            tempOutput = 'Error';
          }
        } else if (_ope == '%') {
          result = num1 % num2;
        }

        if (tempOutput == 'Error') {
          _output = 'Error';
        } else {
          _output = result.toString().endsWith('.0')
              ? result.toStringAsFixed(0)
              : result.toString();
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
    final operatorButtonColor = isDarkMode ? Colors.teal.shade700 : Colors.teal;
    final funcButtonColor = isDarkMode ? Colors.purple.shade800 : Colors.purple;
    final equalButtonColor = isDarkMode ? Colors.red.shade600 : Colors.red;


    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(
                  isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                  color: textColor,
                ),
                onPressed: widget.toggleTheme,
              ),
            ),

            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _output,
                      style: TextStyle(
                        fontSize: 65,
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
                    BuildButton(onclick: () => buttonPress('back'), text: '', icon: Icons.backspace_outlined, color: funcButtonColor),
                    BuildButton(onclick: () => buttonPress('+/-'), text: '+/-', color: funcButtonColor),
                    BuildButton(onclick: () => buttonPress('÷'), text: '÷', color: operatorButtonColor),
                  ],
                ),
                Row(
                  children: [
                    BuildButton(onclick: () => buttonPress('7'), text: '7'), // No color
                    BuildButton(onclick: () => buttonPress('8'), text: '8'), // No color
                    BuildButton(onclick: () => buttonPress('9'), text: '9'), // No color
                    BuildButton(onclick: () => buttonPress('*'), text: '×', color: operatorButtonColor),
                  ],
                ),
                Row(
                  children: [
                    BuildButton(onclick: () => buttonPress('4'), text: '4'), // No color
                    BuildButton(onclick: () => buttonPress('5'), text: '5'), // No color
                    BuildButton(onclick: () => buttonPress('6'), text: '6'), // No color
                    BuildButton(onclick: () => buttonPress('-'), text: '−', color: operatorButtonColor),
                  ],
                ),
                Row(
                  children: [
                    BuildButton(onclick: () => buttonPress('1'), text: '1'), // No color
                    BuildButton(onclick: () => buttonPress('2'), text: '2'), // No color
                    BuildButton(onclick: () => buttonPress('3'), text: '3'), // No color
                    BuildButton(onclick: () => buttonPress('+'), text: '+', color: operatorButtonColor),
                  ],
                ),
                Row(
                  children: [
                    BuildButton(onclick: () => buttonPress('%'), text: '%', color: funcButtonColor),
                    BuildButton(onclick: () => buttonPress('0'), text: '0'), // No color
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