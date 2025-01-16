import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  final String role; // Specify the role: Company, Agent, or Dropship Agent

  const CreateAccount({Key? key, required this.role}) : super(key: key);

  @override
  CreateAccountState createState() => CreateAccountState();
}

class CreateAccountState extends State<CreateAccount> {
  final _emailController = TextEditingController();
  final _idController = TextEditingController(); // Controller for ID (only for Company)
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _createAccount() {
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${widget.role} account created successfully!',
            style: const TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.grey),
          ),
        ),
      );
      Navigator.pop(context); // Navigate back to the previous page
    }
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
                  // Use padding instead of SizedBox for consistent spacing
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
                  // Conditionally render the ID field for Company only
                  if (widget.role == 'Company')
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: TextFormField(
                        controller: _idController,
                        validator: (value) => value != null && value.isNotEmpty
                            ? null
                            : 'Enter ${widget.role} ID',
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: '${widget.role} ID',
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
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: TextFormField(
                      controller: _addressController,
                      maxLines: 2,
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
                  const SizedBox(height: 10),
                  const Text(
                    'By clicking register, you are agreeing with Terms & Conditions',
                    style: TextStyle(fontFamily: 'Roboto', fontSize: 12, color: Colors.black),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _createAccount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFBD46D),
                      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.black),
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
