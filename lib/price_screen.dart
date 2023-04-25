import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'dart:convert';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  var eRate;

  @override
  void initState() {
    super.initState();
    getData(selectedCurrency);
  }

  Future<void> getData(String value) async {
    var url =
        'https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC$value';
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var pData = jsonDecode(response.body);
      await updateUI(pData);
      print(url);
      print(pData['last']);
      return pData;
    } else {
      print(response.statusCode);
      setState(() {
        eRate = 'Connection error';
      });
      updateUI(null);
    }
  }

  Future<void> updateUI(dynamic pData) async {
    if (pData != null && pData.containsKey('last')) {
      setState(() {
        eRate = pData['last'];
      });
    } else {
      setState(() {
        eRate = 'Data unavailable';
      });
    }
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];

    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) async {
        await getData(value!);
        setState(() {
          selectedCurrency = value;
          print(value);
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 35,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
        });
        getData(selectedCurrency);
      },
      children: pickerItems,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC =  $eRate $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}







/* DropdownButton(
              value: selectedCurrency,
              items: [
                // for (int i = 0; i < currenciesList.length; i++)
                for (String currency in currenciesList)
                  DropdownMenuItem(
                    value: currency,
                    child: Text(currency),
                  ),
              ],
              onChanged: (value) {
                setState(
                  () {
                    selectedCurrency = value!;
                  },
                );
              },
            ), */
