import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../widgets/default_button.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onForgotPassword;
  final VoidCallback onSignUp;
  final VoidCallback onGoogleSignIn;
  final VoidCallback onFacebookSignIn;
  final VoidCallback onTwitterSignIn;
  final bool isLoading;
  final String? error;

  const LoginForm({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.onForgotPassword,
    required this.onSignUp,
    required this.onGoogleSignIn,
    required this.onFacebookSignIn,
    required this.onTwitterSignIn,
    required this.isLoading,
    this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                error!,
                style: TextStyle(color: Colors.red),
              ),
            ),
          Row(
            children: [
              Spacer(),
              GestureDetector(
                onTap: onForgotPassword,
                child: Text(
                  "Forgot Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Continue",
            press: () {
              if (emailController.text.isNotEmpty &&
                  passwordController.text.isNotEmpty) {
                context.read<AuthProvider>().signIn(
                      emailController.text,
                      passwordController.text,
                    );
              }
            },
            isLoading: isLoading,
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: TextStyle(fontSize: getProportionateScreenWidth(16)),
              ),
              GestureDetector(
                onTap: onSignUp,
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(16),
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          Text(
            "Or continue with",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(14),
              color: Colors.grey,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SocialButton(
                icon: FontAwesomeIcons.google,
                onTap: onGoogleSignIn,
                color: Colors.red,
                isLoading: isLoading,
              ),
              SizedBox(width: getProportionateScreenWidth(20)),
              SocialButton(
                icon: FontAwesomeIcons.facebook,
                onTap: onFacebookSignIn,
                color: Colors.blue,
                isLoading: isLoading,
              ),
              SizedBox(width: getProportionateScreenWidth(20)),
              SocialButton(
                icon: FontAwesomeIcons.twitter,
                onTap: onTwitterSignIn,
                color: Colors.lightBlue,
                isLoading: isLoading,
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.email_outlined),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.lock_outline),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final bool isLoading;

  const SocialButton({
    Key? key,
    required this.icon,
    required this.onTap,
    required this.color,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: getProportionateScreenWidth(50),
        height: getProportionateScreenWidth(50),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                )
              : FaIcon(
                  icon,
                  color: color,
                  size: getProportionateScreenWidth(24),
                ),
        ),
      ),
    );
  }
}