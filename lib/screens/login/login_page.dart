import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'components/login_form.dart';
import '../../size_config.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize SizeConfig
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SizeConfig().init(context);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: getProportionateScreenHeight(20)),
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(28),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Sign in with your email and password  \nor continue with social media",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return LoginForm(
                        emailController: _emailController,
                        passwordController: _passwordController,
                        onForgotPassword: () {
                          // TODO: Implement forgot password
                        },
                        onSignUp: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        onGoogleSignIn: () {
                          authProvider.signInWithGoogle();
                        },
                        onFacebookSignIn: () {
                          authProvider.signInWithFacebook();
                        },
                        onTwitterSignIn: () {
                          authProvider.signInWithTwitter();
                        },
                        isLoading: authProvider.isLoading,
                        error: authProvider.error,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 