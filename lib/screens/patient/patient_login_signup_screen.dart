import 'package:flutter/material.dart';
import 'patients_dashboard_screen.dart';

// In-memory mock patients list
final List<Map<String, dynamic>> mockPatients = [
  {
    'fullName': 'John Doe',
    'email': 'john@gmail.com',
    'password': 'password123',
    'birthDate': '01-01-1990',
    'phone': '+63 9123456789',
  },
];

class PatientLoginSignUpScreen extends StatefulWidget {
  final bool initialSignUp;
  const PatientLoginSignUpScreen({Key? key, this.initialSignUp = false})
    : super(key: key);

  @override
  State<PatientLoginSignUpScreen> createState() =>
      _PatientLoginSignUpScreenState();
}

class _PatientLoginSignUpScreenState extends State<PatientLoginSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isSignUp = false;
  // controllers
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _birthCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _obscure = true;

  void _register() {
    final newPatient = {
      'fullName': _nameCtrl.text.trim(),
      'email': _emailCtrl.text.trim(),
      'password': _passCtrl.text,
      'birthDate': _birthCtrl.text,
      'phone': _phoneCtrl.text,
    };
    mockPatients.add(newPatient);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Registered (mock)')));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const PatientsDashboardScreen()),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    _birthCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // initialize mode from widget parameter
    if (widget.initialSignUp && !isSignUp) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => setState(() => isSignUp = true),
      );
    }
    return Scaffold(
      appBar: AppBar(
        // remove the default burger menu by not providing a drawer
        automaticallyImplyLeading: false,
        title: const Text('EmedPortal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isSignUp) ...[
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(labelText: 'Full Name'),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Enter full name'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Enter email';
                      final re = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}");
                      if (!re.hasMatch(v.trim())) return 'Enter valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _birthCtrl,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Birth Date',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final d = await showDatePicker(
                            context: context,
                            initialDate: DateTime(1990),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (d != null)
                            _birthCtrl.text =
                                '${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}-${d.year}';
                        },
                      ),
                    ),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Select birth date' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phoneCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      prefixText: '+63 ',
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Enter phone' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passCtrl,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      labelText: 'Set Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (v) => (v == null || v.length < 6)
                        ? 'Password must be 6+ chars'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _confirmCtrl,
                    obscureText: _obscure,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                    ),
                    validator: (v) =>
                        v != _passCtrl.text ? 'Passwords do not match' : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Image picker not implemented (mock)',
                                ),
                              ),
                            ),
                        child: const Text('+ INSERT'),
                      ),
                      const SizedBox(width: 12),
                      const Text('Profile Picture (optional)'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) _register();
                    },
                    child: const Text('Register'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(
                      context,
                      '/login',
                    ),
                    child: const Text('Already have an account? Login'),
                  ),
                ] else ...[
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Enter email' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passCtrl,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Enter password' : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // login
                        final email = _emailCtrl.text.trim();
                        final pass = _passCtrl.text;
                        final user = mockPatients.firstWhere(
                          (p) => p['email'] == email && p['password'] == pass,
                          orElse: () => {},
                        );
                        if (user.isNotEmpty) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const PatientsDashboardScreen(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Invalid credentials (mock)'),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text('Login'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false),
                    child: const Text('Don\'t have an account? Sign Up'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
