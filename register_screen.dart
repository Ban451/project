import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Color(0xFF1E3A8A), size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Register',
          style: GoogleFonts.poppins(
            color: const Color(0xFF1E3A8A),
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Create account text
                Text(
                  'Buat Akun Baru',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E3A8A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Daftar untuk memulai',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Nama field
                _buildTextField(
                  label: 'Nama',
                  hint: 'masukan nama lengkap',
                  controller: _nameController,
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 20),
                
                // Email field
                _buildTextField(
                  label: 'Email',
                  hint: 'masukan email',
                  controller: _emailController,
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 20),
                
                // Password field
                _buildTextField(
                  label: 'Password',
                  hint: 'masukan password',
                  controller: _passwordController,
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
                
                const SizedBox(height: 30),
                
                // Register button
                Center(
                  child: GestureDetector(
                    onTap: () => _showSnackbar('Register berhasil'),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      width: 240,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2563EB), Color(0xFF1E3A8A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2563EB).withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Register',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // Login link
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                        children: [
                          const TextSpan(text: 'Sudah punya akun? '),
                          TextSpan(
                            text: 'Login',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2563EB),
                              decoration: TextDecoration.underline,
                              decorationColor: const Color(0xFF2563EB),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E3A8A),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(
                color: Colors.grey[400],
                fontSize: 14,
              ),
              prefixIcon: Icon(icon, color: const Color(0xFF2563EB), size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(),
        ),
        duration: const Duration(milliseconds: 500),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}