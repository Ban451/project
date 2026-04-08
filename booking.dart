class Booking {
  final String id;
  final String hotelId;
  final String hotelName;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final double totalPrice;
  final String status;
  final String hotelImage;

  Booking({
    required this.id,
    required this.hotelId,
    required this.hotelName,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.totalPrice,
    required this.status,
    required this.hotelImage,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotelId': hotelId,
      'hotelName': hotelName,
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut.toIso8601String(),
      'guests': guests,
      'totalPrice': totalPrice,
      'status': status,
      'hotelImage': hotelImage,
    };
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      hotelId: json['hotelId'],
      hotelName: json['hotelName'],
      checkIn: DateTime.parse(json['checkIn']),
      checkOut: DateTime.parse(json['checkOut']),
      guests: json['guests'],
      totalPrice: json['totalPrice'],
      status: json['status'],
      hotelImage: json['hotelImage'],
    );
  }

  static List<Booking> sampleBookings = [
    Booking(
      id: 'B001',
      hotelId: '1',
      hotelName: 'Grand Hyatt Jakarta',
      checkIn: DateTime.now().add(const Duration(days: 5)),
      checkOut: DateTime.now().add(const Duration(days: 7)),
      guests: 2,
      totalPrice: 3000000,
      status: 'confirmed',
      hotelImage: '🏨',
    ),
    Booking(
      id: 'B002',
      hotelId: '3',
      hotelName: 'Aston Hotel',
      checkIn: DateTime.now().add(const Duration(days: 10)),
      checkOut: DateTime.now().add(const Duration(days: 12)),
      guests: 3,
      totalPrice: 1700000,
      status: 'pending',
      hotelImage: '🏨',
    ),
  ];
}
