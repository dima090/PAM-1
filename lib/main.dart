import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(CurrencyConverterApp());
}

class CurrencyConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Currency Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CurrencyConverterScreen(),
    );
  }
}

class CurrencyConverterScreen extends StatefulWidget {
  @override
  _CurrencyConverterScreenState createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  String _selectedFromCurrency = 'MDL';
  String _selectedToCurrency = 'USD';
  double _inputAmount = 1000.00;
  double _exchangeRate = 17.65;
  double _convertedAmount = 0.0;

  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _inputController.text = _inputAmount.toStringAsFixed(2);
    _calculateConversion();
  }

  void _calculateConversion() {
    if (_selectedFromCurrency == 'MDL') {
      _convertedAmount = _inputAmount / _exchangeRate;
    } else {
      _convertedAmount = _inputAmount * _exchangeRate;
    }
  }

  void _swapCurrencies() {
    setState(() {
      String tempCurrency = _selectedFromCurrency;
      _selectedFromCurrency = _selectedToCurrency;
      _selectedToCurrency = tempCurrency;

      double tempAmount = _inputAmount;
      _inputAmount = _convertedAmount;
      _convertedAmount = tempAmount;

      _inputController.text = _inputAmount.toStringAsFixed(2);
      _calculateConversion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Currency Converter',
            style: TextStyle(color: Colors.blue[900]),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.blue[900]),
      ),
      body: Container(
        color: Colors.grey[300],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCurrencyInputSection(),
            SizedBox(height: 20),
            _buildConvertedAmountSection(),
            SizedBox(height: 40),
            _buildExchangeRateSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyInputSection() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildCurrencyDropdown(_selectedFromCurrency),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _inputController,
                  decoration: InputDecoration(
                    hintText: 'Introduceți suma',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[300],
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _inputAmount = double.tryParse(value) ?? 0.0;
                      _calculateConversion();
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildSwapButton(),
          SizedBox(height: 16),
          Row(
            children: [
              _buildCurrencyDropdown(_selectedToCurrency),
              SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Text(
                    _convertedAmount.toStringAsFixed(2),
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSwapButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[900],
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(Icons.swap_vert, color: Colors.white),
        onPressed: _swapCurrencies,
      ),
    );
  }

  Widget _buildCurrencyDropdown(String selectedCurrency) {
    return DropdownButton<String>(
      value: selectedCurrency,
      items: <String>['MDL', 'USD'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Row(
            children: [
              _buildCurrencyFlag(value),
              SizedBox(width: 10),
              Text(value),
            ],
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          if (selectedCurrency == _selectedFromCurrency) {
            _selectedFromCurrency = newValue!;
          } else {
            _selectedToCurrency = newValue!;
          }
          _calculateConversion();
        });
      },
    );
  }

  Widget _buildCurrencyFlag(String currencyCode) {
    String flagAsset =
    currencyCode == 'MDL' ? 'assets/mdl_flag.png' : 'assets/usd_flag.png';
    return Image.asset(
      flagAsset,
      width: 30,
      height: 20,
    );
  }

  Widget _buildConvertedAmountSection() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Converted Amount:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            '\$ $_convertedAmount',
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildExchangeRateSection() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Text(
            '1 USD =',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              _exchangeRate.toStringAsFixed(2),
              style: TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(width: 8),
          Text(
            'MDL',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
