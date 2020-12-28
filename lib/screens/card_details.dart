import 'package:flutter/material.dart';
import 'package:extension/extension.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:binlist/services/networking.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

String url = "https://lookup.binlist.net/$cardNumber";
String cardNumber = "";
String cardScheme = "-";
String cardType = "-";
String cardLength = "-";
String prepaid = "-";
String bankName = "-";
String countryName = "-";

class CardDetails extends StatefulWidget {
  @override
  _CardDetailsState createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  bool showSpinner = false;
  Future<dynamic> getCalledCardMetaData() async {
    BinDetails getBinDetails = BinDetails(url: url);
    var cardMetaData = await getBinDetails.getCardMetadata();

    if (cardMetaData['scheme'] == null) {
      setState(() {
        cardScheme = "-";
      });
    }
    if (cardMetaData['type'] == null) {
      setState(() {
        cardType = "-";
      });
    }

    if (cardMetaData['number']['length'] == null) {
      setState(() {
        cardLength = "-";
      });
    }
    if (cardMetaData['prepaid'] == null) {
      setState(() {
        prepaid = "-";
      });
    }
    if (cardMetaData['bank'] == null) {
      setState(() {
        bankName = "-";
      });
    }
    if (cardMetaData['country'] == null) {
      setState(() {
        countryName = "-";
      });
    }
    setState(() {
      showSpinner = false;
      cardScheme = cardMetaData['scheme'];
      cardType = cardMetaData['type'];
      cardLength = cardMetaData['number']['length'].toString();
      if (cardLength == "null") {
        cardLength = "-";
      }
      prepaid = cardMetaData['prepaid'].toString();
      if (prepaid == "false") {
        prepaid = "No";
      } else if (prepaid == "true") {
        prepaid = "Yes";
      } else if (prepaid == "null") {
        prepaid = "-";
      }
      bankName = cardMetaData['bank']['name'];
      countryName = cardMetaData['country']['name'];
    });
    return cardMetaData;
  }

  final _imputedNumber = TextEditingController();

  void clearCardNumber() {
    setState(() {
      _imputedNumber.clear();
      cardScheme = "-";
      cardType = "-";
      cardLength = "-";
      prepaid = "-";
      bankName = "-";
      countryName = "-";
    });
  }

  @override
  Widget build(BuildContext context) {
    var maskFormatter = MaskTextInputFormatter(
        mask: '#### ####', filter: {"#": RegExp(r'[0-9]')});
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bin List',
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextField(
                      inputFormatters: [maskFormatter],
                      controller: _imputedNumber,
                      onChanged: (value) {
                        String maskedNumber = value;
                        cardNumber =
                            maskedNumber.replaceAll(new RegExp(r'\s'), '');
                        if (cardNumber.length == 8) {
                          setState(() {
                            showSpinner = true;
                          });
                          getCalledCardMetaData();
                        }
                      },
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black54),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.lightBlue, width: 2.0),
                        ),
                        suffix: TextButton(
                          onPressed: clearCardNumber,
                          child: Icon(
                            Icons.clear,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    'Enter the first 8 digits of your card number',
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w200,
                        color: Colors.grey.shade800),
                  )
                ],
              ),
            ),
            Expanded(child: Divider()),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Table(
                        children: [
                          TableRow(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'CARD SCHEME',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 20.0),
                                    child: Text(
                                      cardScheme.capitalizeFirstLetter(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'CARD TYPE',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 20.0),
                                    child: Text(
                                      cardType.capitalizeFirstLetter(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          TableRow(children: [
                            Column(
                              children: [
                                Text(
                                  'LENGTH',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 20.0),
                                  child: Text(
                                    cardLength,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'PREPAID',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 20.0),
                                  child: Text(
                                    prepaid.capitalizeFirstLetter(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ]),
                          TableRow(children: [
                            Column(
                              children: [
                                Text(
                                  'BANK',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 100.0),
                                  child: Text(
                                    bankName.capitalizeFirstLetter(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'COUNTRY',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 100.0),
                                  child: Text(
                                    countryName.capitalizeFirstLetter(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ]),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
