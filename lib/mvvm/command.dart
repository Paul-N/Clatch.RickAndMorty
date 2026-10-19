import 'package:flutter/foundation.dart';

typedef FutureFunction0 = Future Function();

final class AsyncCommand0 extends ChangeNotifier {
  AsyncCommand0(this._action);

  final FutureFunction0 _action;
  bool _running = false;

  /// True when the action is running.
  bool get running => _running;

  Future<void> execute() async {
    // Ensure the action can't launch multiple times.
    // e.g. avoid multiple taps on button
    if (_running) return;

    // Notify listeners.
    // e.g. button shows loading state
    _running = true;

    try {
      await _action();
    } finally {
      _running = false;
      notifyListeners();
    }
  }
}