import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/auth_service.dart';
import '../../models/booking.dart';
import '../welcome_screen.dart';
import '../../models/user_model.dart';

class UserProfileScreen extends StatefulWidget {
  final UserModel? userData;

  const UserProfileScreen({super.key, this.userData});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final AuthService _authService = AuthService();
  bool _isEditing = false;
  
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userData?.name ?? '');
    _emailController = TextEditingController(text: widget.userData?.email ?? '');
    _phoneController = TextEditingController(text: widget.userData?.phone ?? '');
    _photoUrl = widget.userData?.photoUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleLogout() {
    _authService.logout();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Anda telah logout'), backgroundColor: Colors.orange),
    );
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const WelcomeScreen()), (route) => false);
  }

  void _saveProfile() {
    _authService.updateProfile(
      name: _nameController.text,
      phone: _phoneController.text,
      photoUrl: _photoUrl,
    );
    setState(() => _isEditing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil diperbarui'), backgroundColor: Colors.green),
    );
  }

  void _changePhoto() {
    // Simulasi pilih foto (di real app pakai image_picker)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ganti Foto Profil'),
        content: const Text('Fitur ini akan menggunakan galeri/kamera. (Demo: menggunakan avatar default)'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              setState(() => _photoUrl = 'https://ui-avatars.com/api/?background=2563EB&color=fff&name=${Uri.encodeComponent(_nameController.text)}');
              Navigator.pop(context);
            },
            child: const Text('Gunakan Avatar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Profil Saya', style: GoogleFonts.poppins(color: const Color(0xFF1E3A8A), fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit, color: const Color(0xFF2563EB)),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
                if (!_isEditing) {
                  _nameController.text = widget.userData?.name ?? '';
                  _phoneController.text = widget.userData?.phone ?? '';
                }
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF1E3A8A)]),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: ClipOval(
                      child: _photoUrl != null && _photoUrl!.isNotEmpty
                          ? Image.network(_photoUrl!, fit: BoxFit.cover, width: 120, height: 120)
                          : Center(
                              child: Text(
                                _nameController.text.isNotEmpty ? _nameController.text[0].toUpperCase() : 'U',
                                style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
                              ),
                            ),
                    ),
                  ),
                  if (_isEditing)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _changePhoto,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2563EB),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (!_isEditing)
              Text(
                _nameController.text,
                style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700, color: const Color(0xFF1E3A8A)),
              ),
            const SizedBox(height: 24),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoField(label: 'Nama Lengkap', value: _nameController.text, icon: Icons.person_outline, isEditing: _isEditing, controller: _nameController),
                    const Divider(height: 24),
                    _buildInfoField(label: 'Email', value: _emailController.text, icon: Icons.email_outlined, isEditing: false, controller: _emailController),
                    const Divider(height: 24),
                    _buildInfoField(label: 'Nomor Telepon', value: _phoneController.text, icon: Icons.phone_outlined, isEditing: _isEditing, controller: _phoneController, keyboardType: TextInputType.phone),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildBookingHistory(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _handleLogout,
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            if (_isEditing) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Simpan Perubahan'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField({
    required String label,
    required String value,
    required IconData icon,
    required bool isEditing,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: const Color(0xFF2563EB).withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: const Color(0xFF2563EB), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
              if (isEditing)
                TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  decoration: const InputDecoration(isDense: true, border: InputBorder.none),
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
                )
              else
                Text(value.isEmpty ? '-' : value, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookingHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Riwayat Pemesanan', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: const Color(0xFF1E3A8A))),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: Booking.sampleBookings.length,
          itemBuilder: (context, index) {
            final booking = Booking.sampleBookings[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF1E3A8A)]),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(child: Text(booking.hotelImage, style: const TextStyle(fontSize: 24))),
                ),
                title: Text(booking.hotelName, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${booking.checkIn.day}/${booking.checkIn.month} - ${booking.checkOut.day}/${booking.checkOut.month}'),
                    Text(
                      'Rp ${booking.totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: const Color(0xFF2563EB)),
                    ),
                  ],
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: booking.status == 'confirmed' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    booking.status == 'confirmed' ? 'Selesai' : 'Proses',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: booking.status == 'confirmed' ? Colors.green[700] : Colors.orange[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
