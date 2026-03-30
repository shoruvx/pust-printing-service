class Order {
  final String orderId;
  final String userId;
  final List<String> files;
  final String token;
  final String status;
  final DateTime estimatedDeliveryTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.orderId,
    required this.userId,
    required this.files,
    required this.token,
    required this.status,
    required this.estimatedDeliveryTime,
    required DateTime createdAt,
    required DateTime updatedAt,
  })  : 
        this.createdAt = createdAt.toUtc(),
        this.updatedAt = updatedAt.toUtc();
}