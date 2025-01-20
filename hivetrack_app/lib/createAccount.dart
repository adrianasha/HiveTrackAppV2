import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'loginPage.dart';
import 'EssentialFunctions.dart';

class CreateAccount extends StatefulWidget {
  final String role; // Specify the role: Company, Agent, or Dropship Agent

  const CreateAccount({Key? key, required this.role}) : super(key: key);

  @override
  CreateAccountState createState() => CreateAccountState();
}

class CreateAccountState extends State<CreateAccount> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _companyIdController = TextEditingController(); // New controller for Company ID
  final _formKey = GlobalKey<FormState>();

  void _createAccount() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Passwords do not match!',
              style: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.grey),
            ),
          ),
        );
        return;
      }

      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (widget.role == 'Agent' || widget.role == 'Dropship_Agent') {
          String Tagged = "";
          String Value = "";
          if (widget.role == 'Agent') {
            Tagged = "id";
            Value = "AG${generateCustomId(4, false, true)}";
          } else if (widget.role == 'Dropship_Agent') {
            Tagged = "id";
            Value = "DSAG${generateCustomId(4, false, true)}";
          }
          await FirebaseFirestore.instance.collection(widget.role).doc(userCredential.user!.uid).set({
            'company_id': _companyIdController.text.trim(),
            Tagged: Value,
            'verified': false,
            'email': _emailController.text.trim(),
            'name': _fullNameController.text.trim(),
            'telephone': _telephoneController.text.trim(),
            'address': _addressController.text.trim(),
            'created_at': FieldValue.serverTimestamp(),
          });
          await FirebaseAuth.instance.signOut();

          _showPopup();
        } else {
          await FirebaseFirestore.instance.collection(widget.role).doc(
              userCredential.user!.uid).set({
            'company_id': generateCustomId(6, false, false),
            'email': _emailController.text.trim(),
            'name': _fullNameController.text.trim(),
            'telephone': _telephoneController.text.trim(),
            'address': _addressController.text.trim(),
            'created_at': FieldValue.serverTimestamp(),
          });
          await FirebaseAuth.instance.signOut();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${widget.role} account created successfully!',
                style: const TextStyle(
                    fontFamily: 'Roboto', fontSize: 14, color: Colors.grey),
              ),
            ),
          );

          Timer(const Duration(seconds: 3), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage(role: widget.role)),
            );
          });
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'email-already-in-use') {
          errorMessage = 'This email is already in use.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'The email address is not valid.';
        } else if (e.code == 'weak-password') {
          errorMessage = 'The password is too weak.';
        } else {
          errorMessage = 'An error occurred. Please try again.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage,
              style: const TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.grey),
            ),
          ),
        );
      } catch (e) {
        // Handle Firestore-specific errors or unexpected issues
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to add user data. Error: $e',
              style: const TextStyle(
                  fontFamily: 'Roboto', fontSize: 14, color: Colors.grey),
            ),
          ),
        );
      }
    }
  }

  void _showPopup() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing the popup by tapping outside
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: const Text(
            'We will review your registration shortly...',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Roboto', fontSize: 15, color: Colors.black),
          ),
        );
      },
    );

    // Close the popup after 3 seconds and navigate to the login page
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pop(); // Close the popup
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage(role: widget.role)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Create ${widget.role} Account',
                    style: const TextStyle(fontFamily: 'Roboto', fontSize: 20, color: Colors.black),
                  ),
                  // Add Company ID field at the top for Agent and Dropship Agent
                  if (widget.role == 'Agent' || widget.role == 'Dropship_Agent')
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: TextFormField(
                        controller: _companyIdController,
                        validator: (value) => value != null && value.isNotEmpty
                            ? null
                            : 'Enter Company ID',
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Company ID',
                          hintStyle: const TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        style: const TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.black),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: TextFormField(
                      controller: _fullNameController,
                      validator: (value) => value != null && value.isNotEmpty
                          ? null
                          : 'Enter ${widget.role} Name',
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: '${widget.role} Name',
                        hintStyle: const TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      style: const TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: TextFormField(
                      controller: _emailController,
                      validator: (value) => value != null && value.contains('@') ? null : 'Enter a valid email',
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: '${widget.role} Email',
                        hintStyle: const TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      style: const TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: TextFormField(
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
                      ),
                      style: const TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      validator: (value) => value != null && value == _passwordController.text
                          ? null
                          : 'Passwords do not match',
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Confirm Password',
                        hintStyle: const TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      style: const TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: TextFormField(
                      controller: _telephoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Telephone Number',
                        hintStyle: const TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      style: const TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                    child: TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Address',
                        hintStyle: const TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      style: const TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _createAccount,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                      backgroundColor: const Color.fromARGB(255, 44, 150, 109),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.white),
                    ),
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
