import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/hotel.dart';
import 'booking_screen.dart';
import '../../services/auth_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _searchController = TextEditingController();
  List<Hotel> _searchResults = [];
  List<Hotel> _allHotels = Hotel.sampleHotels;
  
  // Filter state
  String _selectedSort = 'Semua';
  double _minPrice = 0;
  double _maxPrice = 5000000;
  double _minRating = 0;
  Set<String> _selectedFacilities = {};
  
  bool _showFilterModal = false;

  @override
  void initState() {
    super.initState();
    _searchResults = _allHotels;
  }

  void _searchHotels(String query) {
    setState(() {
      _searchResults = _allHotels.where((hotel) {
        final matchesQuery = query.isEmpty ||
            hotel.name.toLowerCase().contains(query.toLowerCase()) ||
            hotel.location.toLowerCase().contains(query.toLowerCase());
        
        final matchesPrice = hotel.price >= _minPrice && hotel.price <= _maxPrice;
        final matchesRating = hotel.rating >= _minRating;
        final matchesFacilities = _selectedFacilities.isEmpty ||
            _selectedFacilities.every((f) => hotel.facilities.contains(f));
        
        return matchesQuery && matchesPrice && matchesRating && matchesFacilities;
      }).toList();
      
      _applySorting();
    });
  }

  void _applySorting() {
    switch (_selectedSort) {
      case 'Termurah':
        _searchResults.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Termahal':
        _searchResults.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Rating Tertinggi':
        _searchResults.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
  }

  void _openFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Filter Pencarian', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 20),
                
                // Rentang Harga
                Text('Rentang Harga', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                RangeSlider(
                  values: RangeValues(_minPrice, _maxPrice),
                  min: 0,
                  max: 5000000,
                  divisions: 10,
                  activeColor: const Color(0xFF2563EB),
                  onChanged: (values) {
                    setModalState(() {
                      _minPrice = values.start;
                      _maxPrice = values.end;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Rp ${_minPrice.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontSize: 12)),
                    Text('Rp ${_maxPrice.toStringAsFixed(0)}', style: GoogleFonts.poppins(fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Rating Minimal
                Text('Rating Minimal', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                Slider(
                  value: _minRating,
                  min: 0,
                  max: 5,
                  divisions: 10,
                  activeColor: const Color(0xFF2563EB),
                  onChanged: (value) => setModalState(() => _minRating = value),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('0 ★', style: GoogleFonts.poppins(fontSize: 12)),
                    Text('${_minRating.toStringAsFixed(1)} ★', style: GoogleFonts.poppins(fontSize: 12)),
                    Text('5 ★', style: GoogleFonts.poppins(fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Fasilitas
                Text('Fasilitas', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: ['Kolam Renang', 'Spa', 'Gym', 'Restoran', 'WiFi Gratis', 'Parkir', 'Bar'].map((facility) {
                    final isSelected = _selectedFacilities.contains(facility);
                    return FilterChip(
                      label: Text(facility, style: GoogleFonts.poppins(fontSize: 12)),
                      selected: isSelected,
                      onSelected: (selected) {
                        setModalState(() {
                          if (selected) {
                            _selectedFacilities.add(facility);
                          } else {
                            _selectedFacilities.remove(facility);
                          }
                        });
                      },
                      backgroundColor: Colors.grey[100],
                      selectedColor: const Color(0xFF2563EB).withOpacity(0.2),
                      checkmarkColor: const Color(0xFF2563EB),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setModalState(() {
                            _minPrice = 0;
                            _maxPrice = 5000000;
                            _minRating = 0;
                            _selectedFacilities.clear();
                          });
                        },
                        style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF2563EB))),
                        child: const Text('Reset'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _searchHotels(_searchController.text);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB)),
                        child: const Text('Terapkan'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isGuest = _authService.isGuest;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Text('Cari Hotel', style: GoogleFonts.poppins(color: const Color(0xFF1E3A8A), fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _searchHotels,
                    decoration: InputDecoration(
                      hintText: 'Cari hotel, lokasi...',
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF2563EB)),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.filter_list, color: Color(0xFF2563EB)),
                        onPressed: isGuest ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Login untuk menggunakan filter')),
                          );
                        } : _openFilterModal,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildSortChip('Semua'),
                      _buildSortChip('Termurah'),
                      _buildSortChip('Termahal'),
                      _buildSortChip('Rating Tertinggi'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: _searchResults.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) => _buildSearchResultCard(_searchResults[index], isGuest),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(String label) {
    final isSelected = _selectedSort == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label, style: GoogleFonts.poppins(fontSize: 12, color: isSelected ? Colors.white : Colors.black87)),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedSort = label;
            _applySorting();
          });
        },
        backgroundColor: Colors.grey[100],
        selectedColor: const Color(0xFF2563EB),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildSearchResultCard(Hotel hotel, bool isGuest) {
    return GestureDetector(
      onTap: () {
        if (isGuest) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login untuk melakukan booking')),
          );
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => BookingScreen(hotel: hotel)));
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF1E3A8A)]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Text(hotel.images[0], style: const TextStyle(fontSize: 30))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(hotel.name, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 12, color: Colors.grey),
                      const SizedBox(width: 2),
                      Text(hotel.location, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                      const SizedBox(width: 8),
                      const Icon(Icons.star, size: 12, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(hotel.rating.toString(), style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${hotel.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')} / malam',
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF2563EB)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text('Hotel tidak ditemukan', style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text('Coba gunakan kata kunci yang berbeda', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500])),
        ],
      ),
    );
  }
}
