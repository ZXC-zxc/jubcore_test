import 'package:flutter/material.dart';
import 'package:jubcore_test/Wallets/JWalletBTCPage.dart';
import 'package:jwallet_core/jwallet_core.dart' as $core;

class JProductHDPage extends StatefulWidget {
  JProductHDPage({Key key, this.productKey}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String  productKey;
  @override
  _JProductHDPageState createState() => _JProductHDPageState();
}

class _JProductHDPageState extends State<JProductHDPage> {
  $core.JProductHD _product;
  String _name;

  void _newWallet() async{
    String walletKey = await _product.newWallet("234",null,"https://ltc.jubiterwallet.com.cn", $core.WalletType.LTC);
    $core.JWalletLTC _wallet = await _product.getWallet<$core.JWalletLTC>(walletKey);
    await _wallet.init();

    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });
  }
  @override
  void initState(){
    super.initState();
    $core.getJProductManager().getProduct(widget.productKey).then((value){
      setState(() {
        _product = value;
        _name = _product.name;
      });
    });
  }

@override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text(_name),
          ), 
          body: Center(
                  child: ListView.builder(
                    itemCount: _product.enumWallets().length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: RaisedButton(
                          padding: EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => new JWalletBTCPage(walletKey:_product.enumWallets()[index],product:_product)
                            ),
                          );
                        },
                          child: Text(_product.enumWallets()[index]),
                        ),
                      );
                    },
                  ),
                ),
          floatingActionButton: FloatingActionButton(
                  onPressed: _newWallet,
                  tooltip: 'Increment',
                  child: Icon(Icons.add),
                )
    );
  }


}