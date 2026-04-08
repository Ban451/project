enum PaymentMethod {
  bankTransfer,
  qris,
  creditCard,
}

class PaymentMethodData {
  final PaymentMethod method;
  final String name;
  final String icon;
  final String description;

  PaymentMethodData({
    required this.method,
    required this.name,
    required this.icon,
    required this.description,
  });

  static List<PaymentMethodData> get methods => [
    PaymentMethodData(
      method: PaymentMethod.bankTransfer,
      name: 'Transfer Bank',
      icon: '🏦',
      description: 'BCA, Mandiri, BNI, BRI',
    ),
    PaymentMethodData(
      method: PaymentMethod.qris,
      name: 'QRIS',
      icon: '📱',
      description: 'Scan QR Code via GoPay, OVO, dll',
    ),
    PaymentMethodData(
      method: PaymentMethod.creditCard,
      name: 'Kartu Kredit',
      icon: '💳',
      description: 'Visa, Mastercard, JCB',
    ),
  ];
}

class PaymentDetail {
  final String bookingId;
  final double amount;
  final PaymentMethod method;
  final DateTime paymentDate;
  final String status; // pending, success, failed
  final String? virtualAccount;
  final String? qrCodeUrl;

  PaymentDetail({
    required this.bookingId,
    required this.amount,
    required this.method,
    required this.paymentDate,
    required this.status,
    this.virtualAccount,
    this.qrCodeUrl,
  });
}
