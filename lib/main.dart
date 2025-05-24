import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:firebase_core/firebase_core.dart'; // Import FirebaseCore
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swap_shelf/firebase_options.dart';
import 'package:swap_shelf/screens/welcome/welcome_screen.dart'; // Import WelcomeScreen
import 'package:swap_shelf/screens/home/homepage_screen.dart'; // Import HomepageScreen
import 'package:swap_shelf/screens/login/login_screen.dart'; // Import LoginScreen
import 'package:swap_shelf/screens/signup/signup_page.dart'; // Import SignupPage
import 'package:swap_shelf/screens/add_book_screen.dart'; // Keep your existing imports
import 'package:swap_shelf/screens/test_firebase_screen.dart';
import 'package:provider/provider.dart';
import 'package:swap_shelf/providers/auth_provider.dart' as app_auth;
import 'package:swap_shelf/providers/book_provider.dart';
import 'package:swap_shelf/screens/profile/profile_screen.dart';

void main() async {
  print('main: Starting app initialization'); // Debug print
  WidgetsFlutterBinding.ensureInitialized();
  
  print('main: Initializing Firebase'); // Debug print
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('main: Firebase initialized successfully'); // Debug print
  } catch (e) {
    print('main: Error initializing Firebase: $e'); // Debug print
  }

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  print('main: Running app'); // Debug print
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('MyApp: Building app widget'); // Debug print
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => app_auth.AuthProvider()),
        ChangeNotifierProvider(create: (_) => BookProvider()),
      ],
      child: MaterialApp(
        title: 'Swap Shelf',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue, // Consider using a Material 3 color scheme
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: Colors.grey[50],
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            iconTheme: IconThemeData(color: Colors.black87),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
        ),

        // --- Crucial Part: Handle Initial Route Based on Auth State ---
        home: const WelcomeScreen(),
        // --- End of Crucial Part ---

        // Define your named routes for easy navigation
        routes: {
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/home': (context) => const HomepageScreen(),
          '/add_book': (context) => const AddBookScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/test-firebase': (context) => const TestFirebaseScreen(),
          // Add other routes as needed
        },
      ),
    );
  }
}