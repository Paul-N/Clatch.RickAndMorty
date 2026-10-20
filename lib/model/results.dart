sealed class Result {

}

final class Success extends Result {

}

final class Data<T> extends Result {
  T value;
  Data(T v) : value = v;
}

final class NotFound extends Result {
  String? description;
  NotFound();

  factory NotFound.withDescription(String description) {
    final error =  NotFound();
    error.description = description;
    return error;
  }
}

final class Fail extends Result {
  String? description;

  Fail();

  factory Fail.withDescription(String description) {
    final error =  Fail();
    error.description = description;
    return error;
  }
}