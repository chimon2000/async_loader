import 'dart:async';

import 'package:flutter/widgets.dart';

typedef Widget RenderLoadCallback();
typedef Widget RenderIdleCallback();
typedef Widget RenderErrorCallback([dynamic error]);
typedef Widget RenderSuccessCallback({dynamic data});
typedef Widget RenderCallback(
    {dynamic data,
    dynamic error,
    bool isError,
    bool isIdle,
    bool isLoading,
    bool isSuccess});

typedef Future<dynamic> FutureFn();

enum LoadingState { Error, Loading, Success }

class AsyncLoader extends StatefulWidget {
  final RenderLoadCallback renderLoad;
  final RenderIdleCallback renderIdle;
  final RenderSuccessCallback renderSuccess;
  final RenderErrorCallback renderError;
  final RenderCallback render;
  final FutureFn fn;
  final bool loadOnMount;

  AsyncLoader(
      {Key key,
      @required this.fn,
      this.renderLoad = renderEmpty,
      this.renderSuccess = renderEmpty,
      this.renderIdle = renderEmpty,
      this.renderError = renderErrorEmpty,
      this.render = renderEmpty,
      this.loadOnMount = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new AsyncLoaderState();
}

class AsyncLoaderState extends State<AsyncLoader> {
  Future future;
  bool shouldLoad;

  @override
  void initState() {
    super.initState();
    _initState();
  }

  void _initState() {
    if (!mounted) return;

    if (widget.loadOnMount) load();
  }

  Future load() {
    var newFuture = widget.fn();
    setState(() {
      shouldLoad = true;
      future = newFuture;
    });

    return newFuture;
  }

  _renderIdle() {
    return widget.renderIdle != null
        ? widget.renderIdle()
        : widget.render(isIdle: true);
  }

  _renderLoad() {
    return widget.renderLoad != null
        ? widget.renderLoad()
        : widget.render(isLoading: true);
  }

  _renderError(error) {
    return widget.renderError != null
        ? widget.renderError(error)
        : widget.render(isError: true, error: error);
  }

  _renderSuccess(data) {
    return widget.renderSuccess != null
        ? widget.renderSuccess(data: data)
        : widget.render(isSuccess: true, data: data);
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<Object>(
        future: future,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return _renderIdle();
            case ConnectionState.active:
            case ConnectionState.waiting:
              return _renderLoad();
            case ConnectionState.done:
              if (snapshot.hasError) return _renderError(snapshot.error);
              return _renderSuccess(snapshot.data);
          }
          return renderEmpty();
        });
  }
}

Widget renderErrorEmpty([dynamic error]) =>
    new Container(width: 0.0, height: 0.0);

Widget renderEmpty(
        {dynamic data,
        dynamic error,
        bool isError,
        bool isIdle,
        bool isLoading,
        bool isSuccess}) =>
    new Container(width: 0.0, height: 0.0);
