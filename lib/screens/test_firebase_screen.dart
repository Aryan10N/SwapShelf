import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TestFirebaseScreen extends StatefulWidget {
  const TestFirebaseScreen({Key? key}) : super(key: key);

  @override
  State<TestFirebaseScreen> createState() => _TestFirebaseScreenState();
}

class _TestFirebaseScreenState extends State<TestFirebaseScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _status = 'Testing Firebase connection...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _testFirebaseConnection();
  }

  Future<void> _testFirebaseConnection() async {
    try {
      // Test Firestore
      await _firestore.collection('test').doc('test').set({
        'timestamp': FieldValue.serverTimestamp(),
      });
      await _firestore.collection('test').doc('test').delete();

      // Test Auth
      final currentUser = _auth.currentUser;
      
      setState(() {
        _status = 'Firebase connection successful!\n'
            'Firestore: Connected\n'
            'Auth: ${currentUser != null ? 'User logged in' : 'No user logged in'}';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _status = 'Error connecting to Firebase: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Test'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading)
                const CircularProgressIndicator()
              else
                Text(
                  _status,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _testFirebaseConnection,
                child: const Text('Test Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 