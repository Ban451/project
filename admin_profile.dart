import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/auth_service.dart';
import '../welcome_screen.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  final AuthService _authService = AuthService();
  bool _isEditing = false;
  
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _authService.currentUser?.name ?? 'Administrator');
    _emailController = TextEditingController(text: _authService.currentUser?.email ?? 'admin@stayvue.com');
    _photoUrl = _authService.currentUser?.photoUrl;
  }

  void _saveProfile() {
    _authService.updateProfile(name: _nameController.text, photoUrl: _photoUrl);
    setState(() => _isEditing = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil admin diperbarui')));
  }

  void _changePhoto() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ganti Foto Profil'),
        content: const Text('Gunakan avatar default?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              setState(() => _photoUrl = 'https://ui-avatars.com/api/?background=1E3A8A&color=fff&name=${Uri.encodeComponent(_nameController.text)}');
              Navigator.pop(context);
            },
            child: const Text('Gunakan Avatar'),
          ),
        ],
      ),
    );
  }

  void _logout() {
    _authService.logout();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const WelcomeScreen()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Profil Admin', style: GoogleFonts.poppins(color: const Color(0xFF1E3A8A), fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit, color: const Color(0xFF2563EB)),
            onPressed: () => setState(() => _isEditing = !_isEditing),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF1E3A8A)]),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 10)],
                  ),
                  child: ClipOval(
                    child: _photoUrl != null && _photoUrl!.isNotEmpty
                        ? Image.network(_photoUrl!, fit: BoxFit.cover)
                        : Center(
                            child: Text(
                              _nameController.text.isNotEmpty ? _nameController.text[0].toUpperCase() : 'A',
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
                        decoration: BoxDecoration(color: const Color(0xFF2563EB), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoField('Nama Admin', _nameController, Icons.person_outline, _isEditing),
                    const Divider(height: 24),
                    _buildInfoField('Email', _emailController, Icons.email_outlined, false),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_isEditing)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), padding: const EdgeInsets.symmetric(vertical: 15)),
                  child: const Text('Simpan Perubahan'),
                ),
              ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, TextEditingController controller, IconData icon, bool isEditing) {
    return Row(
      children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFF2563EB).withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: const Color(0xFF2563EB))),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
              if (isEditing)
                TextField(controller: controller, decoration: const InputDecoration(isDense: true, border: InputBorder.none), style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600))
              else
                Text(controller.text, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}
