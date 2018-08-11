# async_loader

A flutter plugin for loading content asynchronously.

![Example](https://raw.githubusercontent.com/chimon2000/async_loader/master/example/example.gif)

## Usage

To use this plugin, add `async_loader` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

### Create instance

```
getMessage() async {
  return new Future.delayed(TIMEOUT, () => 'Welcome to your async screen');
}

...

var _asyncLoader = new AsyncLoader(
    key: _asyncLoaderState,
    initState: () async => await getMessage(),
    renderLoad: () => new CircularProgressIndicator(),
    renderError: ([error]) =>
        new Text('Sorry, there was an error loading your joke'),
    renderSuccess: ({data}) => new Text(data),
);
```

### Trigger reload

```
class ExampleApp extends StatelessWidget {
  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();

  reload() {
      _asyncLoaderState.currentState.reloadState()
  }
}
```

## Full Example

```
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:async_loader/async_loader.dart';

void main() {
  runApp(new ExampleApp());
}

class ExampleApp extends StatelessWidget {
  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();

  @override
  Widget build(BuildContext context) {
    var _asyncLoader = new AsyncLoader(
      key: _asyncLoaderState,
      initState: () async => await getMessage(),
      renderLoad: () => new CircularProgressIndicator(),
      renderError: ([error]) =>
          new Text('Sorry, there was an error loading your joke'),
      renderSuccess: ({data}) => new Text(data),
    );

    return new MaterialApp(
        title: 'Async Loader Demo',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new Scaffold(
          appBar: new AppBar(title: buildTitle('Async Loader Demo')),
          body: new Center(child: _asyncLoader),
          floatingActionButton: new FloatingActionButton(
            onPressed: () => _asyncLoaderState.currentState
                .reloadState()
                .whenComplete(() => print('finished reload')),
            tooltip: 'Reload',
            child: new Icon(Icons.refresh),
          ),
        ));
  }
}

const TIMEOUT = const Duration(seconds: 5);

getMessage() async {
  return new Future.delayed(TIMEOUT, () => 'Welcome to your async screen');
}

buildTitle(String title) {
  return new Padding(
    padding: new EdgeInsets.all(10.0),
    child: new Text('Async Loader Demo'),
  );
}
```
