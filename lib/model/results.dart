sealed class Result {

}

final class Success extends Result {

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