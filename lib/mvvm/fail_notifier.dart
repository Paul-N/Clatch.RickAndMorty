import 'package:flutter/foundation.dart';
import 'package:rick_and_morty/model/results.dart';

/// A ValueNotifier[T] equivalent but for Fail objects. Does not check if Fail
/// so you can notify same fail multiple times.
class FailNotifier extends ChangeNotifier implements ValueListenable<Fail?> {

  FailNotifier() {
    if (kFlutterMemoryAllocationsEnabled) {
      ChangeNotifier.maybeDispatchObjectCreation(this);
    }
  }

  void notifyFail(Fail fail) {
    _value = fail;
    notifyListeners();
  }

  @override
  Fail? get value => _value;
  Fail? _value;

  @override
  String toString() => '${describeIdentity(this)}($value)';
}