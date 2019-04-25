import 'dart:async';

import 'package:flutter/widgets.dart';

typedef Widget RenderLoadCallback();
typedef Widget RenderErrorCallback([dynamic error]);
typedef Widget RenderSuccessCallback({dynamic data});
typedef Future<Object> InitStateCallback();

enum LoadingState { Error, Loading, Success }

class AsyncLoader extends StatefulWidget {
  final RenderLoadCallback renderLoad;
  final RenderSuccessCallback renderSuccess;
  final RenderErrorCallback renderError;
  final InitStateCallback initState;
  final bool forceReload;

  AsyncLoader(
      {Key key,
        this.forceReload = false,
        this.renderLoad,
        this.renderSuccess,
        this.renderError,
        this.initState})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new AsyncLoaderState();
}

class AsyncLoaderState extends State<AsyncLoader> {
  var _loadingState = LoadingState.Loading;
  dynamic _data;
  dynamic _error;
  bool reloaded = false;

  @override
  void initState() {
    super.initState();
    _initState();
  }

  Future<void> reloadState() {
    return _initState();
  }

  Future<void> _initState() async {
    if (!mounted) return;

    setState(() {
      _loadingState = LoadingState.Loading;
    });

    try {
      var data = await widget.initState();

      if (!mounted) return;

      setState(() {
        _data = data;
        _loadingState = LoadingState.Success;
      });

      reloaded = true;
    } catch (e) {
      print(e);
      setState(() {
        _error = e;
        _data = null;
        _loadingState = LoadingState.Error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingState == LoadingState.Loading) return widget.renderLoad();
    if (_loadingState == LoadingState.Error) return widget.renderError(_error);

    if (widget.forceReload && !reloaded){
      reloadState();
    }
    reloaded = false;
    return widget.renderSuccess(data: _data);
  }
}
