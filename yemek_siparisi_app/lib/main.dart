import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/global_search_screen.dart';
import 'services/api_service.dart';
import 'services/location_service.dart';

void main() {
  runApp(const YemekSiparisiApp());
}

class YemekSiparisiApp extends StatelessWidget {
  const YemekSiparisiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dumanlı Tarifler',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.dark,
          primary: Colors.amber,
          secondary: Colors.amberAccent,
        ),
        useMaterial3: true,
        fontFamily: 'Outfit',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String token;
  final String userRole;
  final String userAddress;

  const MainScreen({
    super.key, 
    required this.userName, 
    required this.userEmail, 
    required this.token, 
    this.userRole = 'Customer',
    this.userAddress = ''
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(userName: widget.userName, userEmail: widget.userEmail, token: widget.token),
      const ExploreScreen(),
      GlobalSearchScreen(token: widget.token),
      CartScreen(token: widget.token),
      ProfileScreen(
        userName: widget.userName, 
        userEmail: widget.userEmail, 
        token: widget.token, 
        userRole: widget.userRole,
        userAddress: widget.userAddress
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20)],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF1E1E1E),
          selectedItemColor: Colors.amber,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Anasayfa'),
            BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: 'Keşfet'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Arama'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Sepet'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLogin = true;
  bool _isLoading = false;
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  List<dynamic> _provinces = [];
  List<dynamic> _districts = [];
  List<dynamic> _neighborhoods = [];
  int? _selectedProvinceId;
  int? _selectedDistrictId;
  int? _selectedNeighborhoodId;

  @override
  void initState() {
    super.initState();
    _loadProvinces();
  }

  Future<void> _loadProvinces() async {
    final provinces = await LocationService.getProvinces();
    setState(() => _provinces = provinces);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E1E1E), Color(0xFF121212)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.local_fire_department_rounded, size: 70, color: Colors.amber),
                  ),
                  const SizedBox(height: 24),
                  const Text('Dumanlı Tarifler', 
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.amber, letterSpacing: 1.2)),
                  Text(_isLogin ? 'Hoş Geldiniz' : 'Aramıza Katılın', 
                    style: const TextStyle(fontSize: 18, color: Colors.white70)),
                  const SizedBox(height: 40),
                  
                  if (!_isLogin) ...[
                    _buildField(_firstNameController, 'Ad', Icons.person),
                    const SizedBox(height: 15),
                    _buildField(_lastNameController, 'Soyad', Icons.person_outline),
                    const SizedBox(height: 15),
                    _buildLocationDropdowns(),
                    const SizedBox(height: 15),
                  ],

                  _buildField(_emailController, 'E-posta', Icons.email, keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 15),
                  _buildField(_passwordController, 'Şifre', Icons.lock, obscureText: true),
                  
                  const SizedBox(height: 40),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleAuth,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 10,
                        shadowColor: Colors.amber.withOpacity(0.5),
                      ),
                      child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.black)
                        : Text(_isLogin ? 'GİRİŞ YAP' : 'KAYIT OL', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => setState(() => _isLogin = !_isLogin),
                    child: Text(_isLogin ? 'Henüz hesabın yok mu? Hemen Katıl' : 'Zaten aramızda mısın? Giriş Yap', 
                      style: const TextStyle(color: Colors.amber)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, IconData icon, {bool obscureText = false, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.amber),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildLocationDropdowns() {
    return Column(
      children: [
        _buildDropdown('İl Seçiniz', _provinces, _selectedProvinceId, (val) {
          setState(() => _selectedProvinceId = val);
          LocationService.getDistricts(val!).then((res) => setState(() => _districts = res));
        }),
        if (_selectedProvinceId != null) ...[
          const SizedBox(height: 15),
          _buildDropdown('İlçe Seçiniz', _districts, _selectedDistrictId, (val) {
            setState(() => _selectedDistrictId = val);
            LocationService.getNeighborhoods(val!).then((res) => setState(() => _neighborhoods = res));
          }),
        ],
        if (_selectedDistrictId != null) ...[
          const SizedBox(height: 15),
          _buildDropdown('Mahalle Seçiniz', _neighborhoods, _selectedNeighborhoodId, (val) {
            setState(() => _selectedNeighborhoodId = val);
          }),
        ],
      ],
    );
  }

  Widget _buildDropdown(String hint, List<dynamic> items, int? val, Function(int?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(15)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isExpanded: true,
          hint: Text(hint, style: const TextStyle(color: Colors.grey)),
          value: val,
          onChanged: onChanged,
          dropdownColor: const Color(0xFF1E1E1E),
          items: items.map((item) => DropdownMenuItem<int>(value: item['id'], child: Text(item['name']))).toList(),
        ),
      ),
    );
  }

  Future<void> _handleAuth() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      if (_isLogin) {
        final result = await ApiService.login(email, password);
        if (result['success']) {
          if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen(
            userName: result['data']['fullName'] ?? 'Kullanıcı', 
            userEmail: email,
            token: result['data']['token'] ?? '',
            userRole: result['data']['role'] ?? 'Customer',
            userAddress: '${result['data']['neighborhood'] ?? ''} ${result['data']['district'] ?? ''}/${result['data']['province'] ?? ''}',
          )));
        } else {
          _msg(result['message'] ?? 'Giriş Başarısız', Colors.red);
        }
      } else {
        String? pName = _provinces.firstWhere((p) => p['id'] == _selectedProvinceId, orElse: () => {'name': ''})['name'];
        String? dName = _districts.firstWhere((d) => d['id'] == _selectedDistrictId, orElse: () => {'name': ''})['name'];
        String? nName = _neighborhoods.firstWhere((n) => n['id'] == _selectedNeighborhoodId, orElse: () => {'name': ''})['name'];

        final result = await ApiService.register(
          '${_firstNameController.text} ${_lastNameController.text}', 
          email, 
          password,
          province: pName,
          district: dName,
          neighborhood: nName
        );
        if (result['success']) {
          setState(() => _isLogin = true);
          _msg('Kayıt Başarılı!', Colors.green);
        } else {
          _msg(result['message'], Colors.red);
        }
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _msg(String m, Color c) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m), backgroundColor: c));
}
