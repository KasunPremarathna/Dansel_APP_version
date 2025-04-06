import 'package:dansal_app/constent_values/const_colors.dart';
import 'package:dansal_app/providers/auth_provider.dart';
import 'package:dansal_app/widgets/custom_button.dart';
import 'package:dansal_app/widgets/login_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterBottomSheet extends ConsumerStatefulWidget {
  final Function? onSuccess;

  const RegisterBottomSheet({Key? key, this.onSuccess}) : super(key: key);

  static Future<void> show(BuildContext context, {Function? onSuccess}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RegisterBottomSheet(onSuccess: onSuccess),
    );
  }

  @override
  ConsumerState<RegisterBottomSheet> createState() =>
      _RegisterBottomSheetState();
}

class _RegisterBottomSheetState extends ConsumerState<RegisterBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameTextEditingController.dispose();
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        final username = _nameTextEditingController.text.trim();
        final email = _emailTextEditingController.text.trim();
        final password = _passwordTextEditingController.text.trim();

        print(
          'Attempting registration with username: $username, email: $email',
        );

        final success = await ref
            .read(authNotifierProvider.notifier)
            .register(username, email, password);

        if (success) {
          if (mounted) {
            // Close the bottom sheet
            Navigator.pop(context);

            // Show success message
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Registration successful!')));

            // Call the success callback if provided
            if (widget.onSuccess != null) {
              widget.onSuccess!();
            }
          }
        } else {
          setState(() {
            _errorMessage = 'Registration failed. Please try again.';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Error: ${e.toString()}';
        });
        print('Registration error in sheet: $e');
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _showLoginSheet() {
    // Close register sheet
    Navigator.pop(context);

    // Show login sheet
    LoginBottomSheet.show(context, onSuccess: widget.onSuccess);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(bottom: keyboardSpace),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 20),

              Text(
                "Register",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: blackFontColor,
                ),
              ),
              SizedBox(height: 20),

              if (_errorMessage.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red.shade900),
                  ),
                ),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameTextEditingController,
                      decoration: InputDecoration(
                        hintText: "Your Name",
                        prefixIcon: Icon(Icons.person, color: mainThemeColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: mainThemeColor,
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 17,
                          horizontal: 15,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your name";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Your Email",
                        prefixIcon: Icon(Icons.email, color: mainThemeColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: mainThemeColor,
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 17,
                          horizontal: 15,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return "Please enter a valid email";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordTextEditingController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: Icon(Icons.lock, color: mainThemeColor),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: mainThemeColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: mainThemeColor,
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 17,
                          horizontal: 15,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a password";
                        }
                        if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),

                    _isLoading
                        ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            mainThemeColor,
                          ),
                        )
                        : SizedBox(
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: _register,
                            child: CustomButton(btnName: "Register"),
                          ),
                        ),

                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: blackFontColor,
                          ),
                        ),
                        SizedBox(width: 10),

                        GestureDetector(
                          onTap: _showLoginSheet,
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: mainThemeColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
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
