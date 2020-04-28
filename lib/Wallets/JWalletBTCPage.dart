import 'package:flutter/material.dart';
import 'package:jwallet_core/jwallet_core.dart' as $core;
import 'dart:convert';

class JWalletBTCPage extends StatefulWidget {
  JWalletBTCPage({Key key, this.walletKey,this.product}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String  walletKey;
  final $core.JProductBase product;
  @override
  _JWalletBTCPageState createState() => _JWalletBTCPageState();
}

class _JWalletBTCPageState extends State<JWalletBTCPage> {
  $core.JWalletBTC _wallet;
  String _name;
  String _balance;
  String _xpub;
  String _address;
  String _raw = "";
  var _txs;

  @override
  void initState(){
    super.initState();
    widget.product.getWallet(widget.walletKey).then((value){
      _wallet = value;
      getCloudData();
      setState(() {
        _name = _wallet.name;
        _balance = _wallet.balance;
        _xpub = _wallet.xpub;
        _address = _wallet.address;
        _txs = _wallet.getLocalHistory();
      });

    });
  }

  void signTx() async{
    await _wallet.active();
    await _wallet.verifyPin("1234");

    var fee = await _wallet.getMinerFeeEstimations();
    var preTx = await _wallet.buildTx("11111", "LX1TCdDaEbCNySfxubsUfrRT7Y3P6Yh6Sn", fee.data.halfHourFee);
    var rawTx = await _wallet.signTX(preTx.preTransaction);

    setState((){
      _raw = rawTx.value;
    });
  }

  void getCloudData() async{ 
      var __balance = await _wallet.getCloudBalance();
      var __txs = await _wallet.getCloudHistory();
      setState(() {
        _balance = __balance;
        _txs = __txs;
    });
  }

  @override
  Widget build(BuildContext context) {

      return Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text(_name),
          ), 
          body: Center(
            child:Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(_balance),
                        Text(_xpub),
                        Text(_address),

                        RaisedButton(
                          child: Text("sign tx"),
                          onPressed: signTx,
                        ),

                        Text(_raw),

                        Flexible(
                          child: ListView.builder(
                            itemCount: _txs.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                                child: RaisedButton(
                                  padding: EdgeInsets.symmetric(vertical: 13),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(json.encode(_txs[index].txid)),
                                  
                                ),
                              );
                            },
                          )
                        )

                  ],
          ))

      );

  }
}