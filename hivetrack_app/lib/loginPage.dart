import 'package:flutter/material.dart';

import 'Agents/AgentDashboard.dart';
import 'Company/CompanyDashboard.dart';
import 'Dropships/DropshipDashboard.dart';

class LoginPage extends StatefulWidget {
  final String role; // Specify the role: Company, Agent, Dropship Agent
  final void Function()? onForgotPassword;
  final void Function()? onLogin;

  const LoginPage({
    Key? key,
    required this.role,
    this.onForgotPassword,
    this.onLogin,
  }) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
              const SizedBox(height: 10),
              // Show this message only for Agent and Dropship Agent
              if (widget.role == 'Agent' || widget.role == 'Dropship Agent')
                Text(
                  'Our honey ${widget.role.toLowerCase()}.',
                  style: const TextStyle(fontFamily: 'Roboto', fontSize: 18, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email Input
                    TextFormField(
                      controller: _emailController,
                      validator: (value) => value != null && value.contains('@') ? null : 'Enter a valid email',
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      style: const TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.grey),
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      style: const TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    // Forgot Password Link
                    GestureDetector(
                      onTap: widget.onForgotPassword,
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
                    const SizedBox(height: 30),
                    // Login Button
                    ElevatedButton(
                      onPressed: () {
                        //if (_formKey.currentState!.validate()) {
                          // Navigate to the respective dashboard based on role
                          if (widget.role == 'Company') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CompanyDashboard()),
                            );
                          } else if (widget.role == 'Agent') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AgentDashboard()),
                            );
                          } else if (widget.role == 'Dropship Agent') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DropshipDashboard()),
                            );
                          }
                        //}
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
