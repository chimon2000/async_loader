import 'dart:async';

Future<String> getMessage() {
  return Future.delayed(_timeout, () => 'Welcome to your async screen');
}

Future<String> getError() {
  return Future.delayed(
      _timeout, () => throw ('Something has gone horribly wrong'));
}

const _timeout = const Duration(seconds: 3);
