import 'dart:math';

String generateOrderId() {
  DateTime now = DateTime.now();

  int randomId = Random().nextInt(9999999);
  String orderId = '${now.microsecondsSinceEpoch}_$randomId';

  return orderId;
}
