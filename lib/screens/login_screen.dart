import 'package:dansal_app/constent_values/const_colors.dart';
import 'package:dansal_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //form key for the form validations
  final _formkey = GlobalKey<FormState>();

  //controllors for the textfelds
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: mainThemeColor),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            Text(
              "User Login",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
                color: blackFontColor,
              ),
            ),
            SizedBox(height: 30),
            Form(
              key: _formkey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailTextEditingController,

                    validator: (value) {
                      //to check user adding user name
                      if (value!.isEmpty) {
                        return "please Enter Your Name";
                      }
                      return null;
                    },

                    decoration: InputDecoration(
                      hintText: "Enter the emaill",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 17,
                        horizontal: 15,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  //text form field for the password
                  TextFormField(
                    controller: _passwordTextEditingController,
                    validator: (value) {
                      //to check user enter correct password
                      if (value!.isEmpty) {
                        return "Pleace Enter The Password";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter the Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 17,
                        horizontal: 15,
                      ),
                    ),
                    obscureText: true,
                  ),

                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      if (_formkey.currentState!.validate()) {
                        //form is valid
                      }
                    },

                    child: CustomButton(btnName: "login"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
