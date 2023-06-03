import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'INR';

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String currency in currencyList) {
      var newItem = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );
      dropDownItems.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
          getData();
        });
      },
    );
  }

  CupertinoPicker iosPicker() {
    List<Text> pickerItem = [];
    for (String currency in currencyList) {
      pickerItem.add(Text(currency));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 30,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currencyList[selectedIndex];
        });
      },
      children: pickerItem,
    );
  }

  Map coinValues = {};
  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    var data = await CoinData().getCoinData(selectedCurrency);
    isWaiting = false;
    setState(() {
      coinValues = data;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Center(
          child: Text('Coin Ticker'),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CryptoCard(
                  value: isWaiting ? '?' : coinValues['BTC'],
                  selectedCurrency: selectedCurrency,
                  cryptoCurrency: 'BTC'),
              CryptoCard(
                  value: isWaiting ? '?' : coinValues['ETH'],
                  selectedCurrency: selectedCurrency,
                  cryptoCurrency: 'ETH'),
              CryptoCard(
                  value: isWaiting ? '?' : coinValues['LTC'],
                  selectedCurrency: selectedCurrency,
                  cryptoCurrency: 'LTC'),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard(
      {super.key,
      required this.value,
      required this.selectedCurrency,
      required this.cryptoCurrency});
  final String value;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlue,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
          child: Text(
            '1 $cryptoCurrency=$value $selectedCurrency',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
