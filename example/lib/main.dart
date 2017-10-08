import 'dart:async';
import 'package:flutter/material.dart';
import 'package:async_loader/async_loader.dart';

const TIMEOUT = const Duration(seconds: 5);

getMessage() async {
  return new Future.delayed(TIMEOUT, () => 'Welcome to your async screen');
}

void main() {
  runApp(new ExampleApp());
}

class ExampleApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Home(title: 'Async Loader Demo'),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();

  @override
  Widget build(BuildContext context) {
    var _asyncLoader = new AsyncLoader(
      key: _asyncLoaderState,
      getInitialProps: () async => await getMessage(),
      renderLoad: () => new CircularProgressIndicator(),
      renderError: ([error]) =>
          new Text('Sorry, there was an error loading your joke'),
      renderSuccess: ({data}) => new Text(data),
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(child: _asyncLoader),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => _asyncLoaderState.currentState.reload(),
        tooltip: 'Reload',
        child: new Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
