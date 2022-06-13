class Storage {
  static late String token;
  static late String marketId;
  static late String productId;
  static late String employeeId;
  static late String invoiceId;

  static void resetEmployeeId() {
    employeeId = '';
  }

  static void resetProductId() {
    productId = '';
  }

  static void resetToken() {
    token = '';
  }

  String useToken() {
    return token;
  }
}