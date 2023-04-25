import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'reusable_card.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  int selectedIndex = 20;
  var eRateB;
  var eRateE;
  var eRateL;
  List cryptos = ['BTC', 'ETH', 'LTC'];

  @override
  void initState() {
    super.initState();
    getData(
      selectedCurrency,
    );
  }

  Future<void> getData(
    String value,
  ) async {
    // var url =
    //     'https://exchange-rates.abstractapi.com/v1/live/?api_key=a89da6d4deba412b9aeaa0757317466b&base=BTC&target=$value';

    // Get the API key from the environment.
    String apiKey = 'a89da6d4deba412b9aeaa0757317466b';

    // Create the URL for the API request.
    Uri url = Uri.parse('https://exchange-rates.abstractapi.com/v1/live');
    url = url.replace(queryParameters: {
      'api_key': apiKey,
      'base': selectedCurrency,
      'target': 'BTC,ETH,LTC',
    });

    http.Response response = await http.get((url));
    if (response.statusCode == 200) {
      var pData = jsonDecode(response.body);
      await updateUI(pData);
      print(pData);
      print(url);

      return pData;
    } else {
      print(response.statusCode);
      setState(() {
        eRateB = 'Connection error';
        eRateE = 'Connection error';
        eRateL = 'Connection error';
      });
      updateUI(null);
    }
  }

  Future<void> updateUI(dynamic pData) async {
    if (pData != null) {
      setState(() {
        var eRB = 1 / jsonDecode(pData['exchange_rates']['BTC'].toString());
        var eRE = 1 / jsonDecode(pData['exchange_rates']['ETH'].toString());
        var eRL = 1 / jsonDecode(pData['exchange_rates']['LTC'].toString());
        eRateB = eRB.roundToDouble().toString();
        eRateE = eRE.roundToDouble().toString();
        eRateL = eRL.roundToDouble().toString();
      });
    } else {
      setState(() {
        eRateB = 'Data unavailable';
        eRateE = 'Data unavailable';
        eRateL = 'Data unavailable';
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
        setState(() {
          selectedCurrency = value!;
          print(value);
        });
        await getData(value!);
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
      onSelectedItemChanged: (selectedIndex) async {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];

          print(currenciesList[selectedIndex]);
          print(selectedIndex);
        });
        String selected = selectedCurrency.toString();
        await getData(selected);
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
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              children: [
/*                 for (String crypto in cryptos) */
                ReusableCard(
                  selectedCurrency: selectedCurrency,
                  crypto: 'BTC',
                  eRate: eRateB,
                ),
                ReusableCard(
                  selectedCurrency: selectedCurrency,
                  crypto: 'ETH',
                  eRate: eRateE,
                ),
                ReusableCard(
                  selectedCurrency: selectedCurrency,
                  crypto: 'LTC',
                  eRate: eRateL,
                ),
              ],
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
            // child: iOSPicker(),
          ),
        ],
      ),
    );
  }
}
