import 'package:call/homescreen.dart';
import 'package:call/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';

  bool _isLoading = false;

  void _loginUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Sign in user with Firebase Auth
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _email.trim(),
          password: _password.trim(),
        );

        // Check if user exists in Firestore
        DocumentSnapshot userDoc = await _firestore
            .collection('User')
            .doc(userCredential.user?.uid)
            .get();

        if (userDoc.exists) {
          // Navigate to the home screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          // Sign out if Firestore document is missing
          await _auth.signOut();
          _showError('User data not found. Please sign up.');
        }
      } on FirebaseAuthException catch (error) {
        _showError('Authentication failed: ${error.message}');
      } catch (error) {
        _showError('Error: ${error.toString()}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (value) {
                  _email = value.trim();
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (value) {
                  _password = value.trim();
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _loginUser,
                      child: const Text('Login'),
                    ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignupScreen()),
                  );
                },
                child: const Text('Signup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
