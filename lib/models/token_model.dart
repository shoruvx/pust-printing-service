class Token {
  String value;
  DateTime dateGenerated;
  String orderId;

  Token({required this.value, required this.dateGenerated, required this.orderId});

  // Logic to reset the token
  void resetToken() {
    // Implement reset logic here<br>
    this.value = '';
    this.dateGenerated = DateTime.now();
    this.orderId = '';
  }
}