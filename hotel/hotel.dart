class Hotel {
  final String id;
  final String name;
  final String location;
  final double price;
  final double rating;
  final String description;
  final List<String> facilities;
  final List<String> images;
  final int availableRooms;
  final String imageUrl;

  Hotel({
    required this.id,
    required this.name,
    required this.location,
    required this.price,
    required this.rating,
    required this.description,
    required this.facilities,
    required this.images,
    required this.availableRooms,
    required this.imageUrl,
  });

  static List<Hotel> sampleHotels = [
    Hotel(
      id: '1',
      name: 'Grand Hyatt Jakarta',
      location: 'Jakarta Pusat',
      price: 1500000,
      rating: 4.8,
      description: 'Hotel mewah di pusat kota Jakarta dengan pemandangan kota yang menakjubkan. Dilengkapi dengan kolam renang infinity dan spa terbaik.',
      facilities: ['Kolam Renang', 'Spa', 'Gym', 'Restoran', 'WiFi Gratis', 'Parkir'],
      images: ['🏨', '🌊', '🍽️'],
      availableRooms: 10,
      imageUrl: 'https://picsum.photos/400/300?random=1',
    ),
    Hotel(
      id: '2',
      name: 'The Ritz-Carlton',
      location: 'Jakarta Selatan',
      price: 2500000,
      rating: 4.9,
      description: 'Pengalaman menginap mewah dengan layanan terbaik. Menawarkan pemandangan kota yang spektakuler.',
      facilities: ['Kolam Renang', 'Spa', 'Gym', 'Restoran', 'WiFi Gratis', 'Bar'],
      images: ['🏨', '🍷', '🏊'],
      availableRooms: 5,
      imageUrl: 'https://picsum.photos/400/300?random=2',
    ),
    Hotel(
      id: '3',
      name: 'Aston Hotel',
      location: 'Bandung',
      price: 850000,
      rating: 4.5,
      description: 'Hotel nyaman dengan akses mudah ke pusat perbelanjaan. Cocok untuk liburan keluarga.',
      facilities: ['Kolam Renang', 'Gym', 'Restoran', 'WiFi Gratis', 'Playground'],
      images: ['🏨', '🎮', '🍜'],
      availableRooms: 15,
      imageUrl: 'https://picsum.photos/400/300?random=3',
    ),
    Hotel(
      id: '4',
      name: 'Hotel Indonesia Kempinski',
      location: 'Jakarta Pusat',
      price: 1800000,
      rating: 4.7,
      description: 'Hotel bersejarah di jantung kota Jakarta. Menawarkan pengalaman menginap yang tak terlupakan.',
      facilities: ['Kolam Renang', 'Spa', 'Gym', 'Restoran', 'WiFi Gratis'],
      images: ['🏨', '🎭', '🍸'],
      availableRooms: 8,
      imageUrl: 'https://picsum.photos/400/300?random=4',
    ),
  ];
}
