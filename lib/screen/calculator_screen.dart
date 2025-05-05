import 'package:flutter/material.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'profil.dart';  // Import the profile screen

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String displayinput = "";
  String displayoutput = "";
  List<String> history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory(); // Load saved history when the app starts
  }

  // Load the history from SharedPreferences
  void _loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      history = prefs.getStringList('history') ?? [];
    });
  }

  // Save the history to SharedPreferences
  void _saveHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('history', history);
  }

  void onInput(String input) {
    setState(() {
      if (input == "C") {
        displayinput = "";
        displayoutput = "";
      } else if (input == "=") {
        String replacedInput = displayinput.replaceAll("x", "*");
        try {
          displayoutput = _evaluateExpression(replacedInput);
          // Add the input and output to history
          String historyEntry = "$displayinput = $displayoutput";
          if (!history.contains(historyEntry)) {
            history.insert(0, historyEntry); // Insert at the beginning to keep latest first
            _saveHistory(); // Save the updated history
          }
        } catch (e) {
          displayoutput = "Error";
        }
      } else {
        displayinput += input;
      }
    });
  }

  String _evaluateExpression(String expression) {
    try {
      final result = _calculate(expression);
      return result.toString();
    } catch (e) {
      return "Error";
    }
  }

  double _calculate(String expression) {
    final regExp = RegExp(r'([0-9\.]+|[-+*/^()])');
    final matches = regExp.allMatches(expression);
    List<String> tokens = [];
    
    for (var match in matches) {
      tokens.add(match.group(0)!);
    }

    List<String> postfix = _infixToPostfix(tokens);
    return _evaluatePostfix(postfix);
  }

  List<String> _infixToPostfix(List<String> tokens) {
    List<String> output = [];
    List<String> stack = [];
    Map<String, int> precedence = {'+': 1, '-': 1, '*': 2, '/': 2, '^': 3};

    for (var token in tokens) {
      if (RegExp(r'[0-9\.]').hasMatch(token)) {
        output.add(token);
      } else if (token == '(') {
        stack.add(token);
      } else if (token == ')') {
        while (stack.isNotEmpty && stack.last != '(') {
          output.add(stack.removeLast());
        }
        stack.removeLast();
      } else {
        while (stack.isNotEmpty &&
            precedence[token]! <= precedence[stack.last]!) {
          output.add(stack.removeLast());
        }
        stack.add(token);
      }
    }

    while (stack.isNotEmpty) {
      output.add(stack.removeLast());
    }

    return output;
  }

  double _evaluatePostfix(List<String> postfix) {
    List<double> stack = [];

    for (var token in postfix) {
      if (RegExp(r'[0-9\.]').hasMatch(token)) {
        stack.add(double.parse(token));
      } else {
        double b = stack.removeLast();
        double a = stack.removeLast();
        switch (token) {
          case '+':
            stack.add(a + b);
            break;
          case '-':
            stack.add(a - b);
            break;
          case '*':
            stack.add(a * b);
            break;
          case '/':
            stack.add(a / b);
            break;
          case '^':
            stack.add(pow(a, b).toDouble());
            break;
          default:
            throw FormatException('Unknown operator: $token');
        }
      }
    }

    return stack.last;
  }

  @override
  Widget build(BuildContext context) {
    List<String> button = [
      "7", "8", "9", "/",
      "4", "5", "6", "x",
      "1", "2", "3", "-",
      "C", "0", "=", "+",
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Row(
          children: [
            // Title: "Calculator"
            const Text(
              "Calculator",
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 10),
            // Scrollable History Section
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Scroll horizontally
                child: Row(
                  children: history.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // When a history button is pressed, set it as the input
                          setState(() {
                            var parts = entry.split(" = ");
                            displayinput = parts[0];
                            displayoutput = parts[1];
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.withOpacity(0.2),
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                        ),
                        child: Text(
                          entry,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black,
        actions: [
          // Profile button
          IconButton(
            icon: Icon(Icons.account_circle, size: 30, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Current input/output area
            Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    displayinput,
                    style: TextStyle(color: Colors.white, fontSize: 24),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 8),
                  Text(
                    displayoutput,
                    style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 32),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 19.0),
              child: Divider(color: Colors.white.withOpacity(0.2)),
            ),
            // Calculator Button Grid
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: button.length,
                itemBuilder: (context, index) {
                  Color textcolor = Colors.white;
                  Color backgroundColor = Colors.grey.withOpacity(0.2);

                  if (button[index] == "-" || button[index] == "x" || button[index] == "+" || button[index] == "/") {
                    textcolor = Colors.green;
                  }
                  if (button[index] == "=") {
                    textcolor = Colors.black;
                    backgroundColor = Colors.green;
                  }
                  if (button[index] == "C") {
                    textcolor = Colors.black;
                    backgroundColor = Colors.red;
                  }

                  return Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      color: backgroundColor,
                      child: Text(
                        button[index],
                        style: TextStyle(color: textcolor, fontSize: 24),
                      ),
                      onPressed: () {
                        onInput(button[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
