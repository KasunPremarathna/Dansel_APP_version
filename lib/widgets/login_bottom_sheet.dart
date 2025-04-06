import 'package:dansal_app/constent_values/const_colors.dart';
import 'package:dansal_app/providers/auth_provider.dart';
import 'package:dansal_app/widgets/custom_button.dart';
import 'package:dansal_app/widgets/register_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginBottomSheet extends ConsumerStatefulWidget {
  final Function? onSuccess;

  const LoginBottomSheet({Key? key, this.onSuccess}) : super(key: key);

  static Future<void> show(BuildContext context, {Function? onSuccess}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LoginBottomSheet(onSuccess: onSuccess),
    );
  }

  @override
  ConsumerState<LoginBottomSheet> createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends ConsumerState<LoginBottomSheet> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        final email = _emailTextEditingController.text.trim();
        final password = _passwordTextEditingController.text.trim();

        print('Attempting login with email: $email');

        final success = await ref
            .read(authNotifierProvider.notifier)
            .login(email, password);

        if (success) {
          if (mounted) {
            // Close the bottom sheet
            Navigator.pop(context);

            // Show success message
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Login successful!')));

            // Call the success callback if provided
            if (widget.onSuccess != null) {
              widget.onSuccess!();
            }
          }
        } else {
          setState(() {
            _errorMessage = 'Login failed. Please check your credentials.';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Error: ${e.toString()}';
        });
        print('Login error in sheet: $e');
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _showRegisterSheet() {
    // Close login sheet
    Navigator.pop(context);

    // Show register sheet
    RegisterBottomSheet.show(context, onSuccess: widget.onSuccess);
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
                "Login",
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
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Enter your email",
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
                        hintText: "Enter your password",
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
                          return "Please enter your password";
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
                            onTap: _login,
                            child: CustomButton(btnName: "Login"),
                          ),
                        ),

                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: blackFontColor,
                          ),
                        ),
                        SizedBox(width: 10),

                        GestureDetector(
                          onTap: _showRegisterSheet,
                          child: Text(
                            "Register",
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
