import 'package:flutter/material.dart';
import 'package:swap_shelf/screens/components/custom_form_field.dart';
import 'package:swap_shelf/screens/components/custom_button.dart';
import 'package:swap_shelf/screens/components/error_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  // Default credentials for testing
  static const String _defaultEmail = 'root';
  static const String _defaultPassword = 'root';

  @override
  void initState() {
    super.initState();
    // Pre-fill the form with default credentials for testing
    _emailController.text = _defaultEmail;
    _passwordController.text = _defaultPassword;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    setState(() {
      _isLoading = true;
    });

    // Simple validation for default credentials
    if (_emailController.text == _defaultEmail && 
        _passwordController.text == _defaultPassword) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      showDialog(
        context: context,
        builder: (context) => ErrorDialog(
          title: 'Login Failed',
          message: 'Please use the default credentials:\nUsername: $_defaultEmail\nPassword: $_defaultPassword',
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'SwapShelf',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6C63FF),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Login to your account',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                CustomFormField(
                  controller: _emailController,
                  label: 'Username',
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 16),
                CustomFormField(
                  controller: _passwordController,
                  label: 'Password',
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Login',
                  onPressed: _handleLogin,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 16),
                Text(
                  'Default credentials for testing:\nUsername: $_defaultEmail\nPassword: $_defaultPassword',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 