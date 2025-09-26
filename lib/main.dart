import 'package:flutter/material.dart';
import 'screens/admin/admin_login_screen.dart';
import 'screens/admin/admin_user_info_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/patients_list_screen.dart';
import 'screens/admin/doctors_list_screen.dart';
import 'screens/admin/add_doctor_screen.dart';
import 'screens/admin/inventory_screen.dart';
import 'screens/admin/schedule_screen.dart';
import 'screens/admin/edit_inventory_screen.dart';
import 'screens/admin/add_inventory_screen.dart';
import 'screens/admin/settings_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/patient/patient_login_signup_screen.dart';
import 'screens/patient/patients_dashboard_screen.dart';
import 'screens/patient/patient_profile_screen.dart';
import 'screens/patient/book_appointment_screen.dart';
import 'screens/patient/appointment_confirmation_screen.dart';
import 'screens/patient/help_screen.dart';
import 'screens/patient/faq_detail_screen.dart';
import 'screens/patient/chat_support_screen.dart';
import 'screens/patient/medication_history_screen.dart';
import 'screens/patient/medication_reminder_screen.dart';

void main() {
  runApp(const MedsApp());
}

class MedsApp extends StatelessWidget {
  const MedsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EMeds',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1976D2),
          primary: const Color(0xFF1976D2),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          filled: true,
          fillColor: Color(0xFFF5F5F5),
        ),
      ),
  home: const SplashScreen(),
      routes: {
  '/splash': (context) => const SplashScreen(),
  '/login': (context) => const LoginHomeScreen(),
  '/signup': (context) => const PatientLoginSignUpScreen(initialSignUp: true),
  '/forgot': (context) => const PlaceholderScreen(title: 'Forgot Password'),
  '/adminLogin': (context) => const AdminLoginScreen(),
  '/adminUserInfo': (context) => const AdminUserInfoScreen(),
  '/adminDashboard': (context) => const AdminDashboardScreen(),
  '/patientsList': (context) => const PatientsListScreen(),
  '/doctorsList': (context) => const DoctorsListScreen(),
  '/addDoctorScreen': (context) => const AddDoctorScreen(),
  '/inventory': (context) => const InventoryScreen(),
  '/editInventory': (context) => const EditInventoryScreen(),
  '/addInventory': (context) => const AddInventoryScreen(),
  '/schedule': (context) => const ScheduleScreen(),
  '/settings': (context) => const SettingsScreen(),
  '/patientDashboard': (context) => const PatientsDashboardScreen(),
  '/patientProfile': (context) => const PatientProfileScreen(),
  '/medicationHistory': (context) => const MedicationHistoryScreen(),
  '/patientInventory': (context) => const PlaceholderScreen(title: 'Patient Inventory'),
  '/medicationReminder': (context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return MedicationReminderScreen(prefill: args);
  },
  '/bookAppointment': (context) => const BookAppointmentScreen(),
  '/appointmentConfirmation': (context) => const AppointmentConfirmationScreen(),
  '/help': (context) => const HelpScreen(),
  '/chatSupport': (context) => const ChatSupportScreen(),
  '/faqDetail': (context) => const FaqDetailScreen(),
      },
    );
  }
}

class LoginHomeScreen extends StatefulWidget {
  const LoginHomeScreen({Key? key}) : super(key: key);

  @override
  State<LoginHomeScreen> createState() => _LoginHomeScreenState();
}

class _LoginHomeScreenState extends State<LoginHomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.widgets_outlined, size: 36, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        Text('EMeds', style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),

                    const SizedBox(height: 32),

                    Text('Login', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/signup'),
                          child: const Text('Sign up'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Please enter your email';
                              final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}");
                              if (!emailRegex.hasMatch(value)) return 'Please enter a valid email';
                              return null;
                            },
                          ),

                          const SizedBox(height: 12),

                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                            obscureText: _obscurePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Please enter your password';
                              if (value.length < 6) return 'Password must be at least 6 characters';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (v) => setState(() => _rememberMe = v ?? false),
                            ),
                            const Text('Remember me'),
                          ],
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/forgot'),
                          child: const Text('Forgot Password ?'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          final email = _emailController.text.trim();
                          final pass = _passwordController.text;
                          final user = mockPatients.firstWhere((p) => p['email'] == email && p['password'] == pass, orElse: () => {});
                          if (user.isNotEmpty) {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PatientsDashboardScreen()));
                          } else {
                            _showSnackBar('Invalid credentials (mock)');
                          }
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14.0),
                        child: Text('Log In'),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: const [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('Or'),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),

                    const SizedBox(height: 12),

                    OutlinedButton.icon(
                      onPressed: () => _showSnackBar('Continue with Facebook (mock)'),
                      icon: const Icon(Icons.facebook),
                      label: const Text('Continue with Facebook'),
                    ),

                    const SizedBox(height: 12),

                    OutlinedButton(
                      onPressed: () => Navigator.pushNamed(context, '/adminLogin'),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text('ADMIN / STAFF'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title Screen',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
