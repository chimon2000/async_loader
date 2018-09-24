import 'dart:async';
import 'package:flutter/material.dart';
import 'package:async_loader/async_loader.dart';
import 'package:example/api.dart';

class SimplePage extends StatelessWidget {
  SimplePage({
    this.title = 'Simple Example',
    this.loadOnMount = true,
    this.fn = getMessage,
    this.timeout = 0,
  });

  final bool loadOnMount;
  final String title;
  final int timeout;
  final Future<dynamic> Function() fn;

  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();

  @override
  Widget build(BuildContext context) {
    var _asyncLoader = new AsyncLoader(
      key: _asyncLoaderState,
      loadOnMount: this.loadOnMount,
      fn: this.fn,
      timeout: this.timeout,
      renderLoad: () => new CircularProgressIndicator(),
      renderError: ([error]) =>
          new Text('Sorry, there was an error loading your future'),
      renderSuccess: ({data}) => new Text(data),
      renderIdle: ({data}) => new Text('Idle'),
    );

    return Scaffold(
      appBar: new AppBar(title: buildTitle(this.title)),
      body: new Center(child: _asyncLoader),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => _asyncLoaderState.currentState
            .load()
            .whenComplete(() => print('finished reload')),
        tooltip: 'Reload',
        child: new Icon(Icons.refresh),
      ),
    );
  }
}

Widget buildTitle(String title) {
  return new Padding(
    padding: new EdgeInsets.all(10.0),
    child: new Text(title),
  );
}
