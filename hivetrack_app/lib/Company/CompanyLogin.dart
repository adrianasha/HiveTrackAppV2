import 'package:flutter/material.dart';

import 'CompanyDashboard.dart';

class CompanyLogin extends StatefulWidget {
  const CompanyLogin({super.key});

  @override
  CompanyLoginState createState() => CompanyLoginState();
}

class CompanyLoginState extends State<CompanyLogin> {
  final _companyIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() {
    if (_formKey.currentState!.validate()) {
      // Handle login logic here, like authentication or API calls
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logging in...')),
      );
    }
  }

  void _forgotPassword() {
    // Handle forgot password logic here, like navigating to the reset password page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Redirecting to reset password...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Hi, Welcome!',
                style: TextStyle(fontFamily: 'Roboto', fontSize: 24, color: Colors.black),
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Company ID Input
                    TextFormField(
                      controller: _companyIdController,
                      validator: (value) =>
                      value != null && value.isNotEmpty ? null : 'Enter Company ID',
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Company ID',
                        hintStyle: const TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        errorStyle: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      ),
                      style: const TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    // Password Input
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      validator: (value) => value != null && value.length >= 6
                          ? null
                          : 'Password must be at least 6 characters',
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Password',
                        hintStyle: const TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        errorStyle: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      ),
                      style: const TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    // Login Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CompanyDashboard()), // Replace with the actual CompanyLogin page widget
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFBD46D),
                        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Log In',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Forgot Password Link
                    GestureDetector(
                      onTap: _forgotPassword,
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
