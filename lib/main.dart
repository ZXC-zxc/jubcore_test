import 'package:flutter/material.dart';
import './Products/JProductHDPage.dart';
import 'package:jwallet_core/jwallet_core.dart' as $core;
import 'dart:convert';

void main(){
  $core.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

 
class _MyHomePageState extends State<MyHomePage> {

  //根据不同的类型，进入不同的页面
  Widget _createProductPage(String productKey){
    Map<String,dynamic> jKey = json.decode(productKey);
    switch ($core.ProductType.values[jKey["pType"]]) {
      case $core.ProductType.HD:
      case $core.ProductType.JubiterBlade:
      case $core.ProductType.Import:
      return new JProductHDPage(productKey: productKey); 
      default:
      //应该返回一个异常页面，先这样
      return new JProductHDPage(productKey: productKey); 
    } 
  }

  void _newProduct() async{
    await $core.getJProductManager().newProductHD("HDWallet1","gauge hole clog property soccer idea cycle stadium utility slice hold chief", "","1234","提示1234");
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
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
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child:FutureBuilder<List<String>>(
        future: $core.getJProductManager().enumProductsByType(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // 请求已结束
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              // 请求失败，显示错误
              return Text("Error: ${snapshot.error}");
            } else {
              // 请求成功，显示数据
              return ListView.builder(
                itemCount: snapshot.data.length,
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
                              builder: (context) => _createProductPage(snapshot.data[index])
                            ),
                          );
                        },
                      child: Text(snapshot.data[index]),
                    ),
                  );
                },
              );
            }
          } else {
            // 请求未结束，显示loading
            return CircularProgressIndicator();
          }
          },)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newProduct,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
