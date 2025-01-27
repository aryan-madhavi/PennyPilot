import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Currencyconvertor extends StatefulWidget {
  const Currencyconvertor({super.key});

  @override
  State<Currencyconvertor> createState() => _CurrencyconvertorState();
}

class _CurrencyconvertorState extends State<Currencyconvertor> {
  String initial_dropdownvalue1 = 'INR(₹)';
  String initial_dropdownvalue2 = 'US Dollar(\$)';
  int? result;

  final Map<String, Map<String, double>> _exchangeRates = {
    'INR(₹)': {
      'US Dollar(\$)': 0.012,
      'Euro(€)': 0.011,
      'Pounds(£)': 0.0098,
      'Yen(¥)': 1.7,
      'INR(₹)': 1.0,
    },
    'US Dollar(\$)': {
      'INR(₹)': 82.0,
      'Euro(€)': 0.91,
      'Pounds(£)': 0.82,
      'Yen(¥)': 140.0,
      'US Dollar(\$)': 1.0,
    },
    'Euro(€)': {
      'INR(₹)': 88.92,
      'Euro(€)': 1.0,
      'Pounds(£)': 0.84,
      'Yen(¥)': 161.08,
      'US Dollar(\$)': 1.03,
    },
    'Pounds(£)': {
      'INR(₹)': 105.69,
      'Euro(€)': 1.19,
      'Pounds(£)': 1.0,
      'Yen(¥)': 191.37,
      'US Dollar(\$)': 1.22,
    },
    'Yen(¥)': {
      'INR(₹)': 0.55,
      'Euro(€)': 0.0062,
      'Pounds(£)': 0.0052,
      'Yen(¥)': 1.0,
      'US Dollar(\$)': 0.0064,
    },
  };

  double _amount = 0.0;
  String _result = '0.0';

  @override
  Widget build(BuildContext context) {
    Widget dropDownVariablefrom = DropdownButton<String>(
      value: initial_dropdownvalue1,
      onChanged: (String? newValue) {
        setState(() {
          initial_dropdownvalue1 = newValue!;
        });
      },
      items: <String>[
        'INR(₹)',
        'Euro(€)',
        'US Dollar(\$)',
        'Pounds(£)',
        'Yen(¥)',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );

    Widget dropDownVariableTo = DropdownButton<String>(
      value: initial_dropdownvalue2,
      onChanged: (String? newValue) {
        setState(() {
          initial_dropdownvalue2 = newValue!;
        });
      },
      items: <String>[
        'US Dollar(\$)',
        'Euro(€)',
        'INR(₹)',
        'Pounds(£)',
        'Yen(¥)',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Currency Converter"),
        backgroundColor: Colors.grey[100],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Amount',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              _amount = double.tryParse(value) ?? 0.0;
                            });
                          },
                          decoration: InputDecoration(
                            label: Text('Enter Amount'),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[600]!),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'From',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                            dropDownVariablefrom,
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              String temp = initial_dropdownvalue1;
                              initial_dropdownvalue1 = initial_dropdownvalue2;
                              initial_dropdownvalue2 = temp;
                            });
                          },
                          icon: Icon(Icons.swap_vert),
                          color: Colors.grey[600],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'To',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                            dropDownVariableTo,
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (_exchangeRates
                                      .containsKey(initial_dropdownvalue1) &&
                                  _exchangeRates[initial_dropdownvalue1]!
                                      .containsKey(initial_dropdownvalue2)) {
                                final double rate =
                                    _exchangeRates[initial_dropdownvalue1]![initial_dropdownvalue2]!;
                                _result = (_amount * rate).toStringAsFixed(2);
                              } else {
                                _result = 'Rate not found';
                                print('Error: Rate not found for $initial_dropdownvalue1 to $initial_dropdownvalue2');
                              }
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.grey[300]),
                            foregroundColor: MaterialStateProperty.all(Colors.black),
                            elevation: MaterialStateProperty.all(5),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            )),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text('Convert'),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _result,
                                style: TextStyle(color: Colors.grey[800], fontSize: 18),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(text: _result));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Result copied to clipboard')),
                                      );
                                    },
                                    icon: Icon(Icons.copy, color: Colors.grey[600]),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
