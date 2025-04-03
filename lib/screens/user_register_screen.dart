import 'package:dansal_app/constent_values/const_colors.dart';
import 'package:dansal_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class UserRegisterScreen extends StatefulWidget {
  const UserRegisterScreen({super.key});

  @override
  State<UserRegisterScreen> createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  //controllors for the textfelds
  final TextEditingController _nameTextEditingControlor =
      TextEditingController();
  final TextEditingController _emailTextEditingControlor =
      TextEditingController();
  final TextEditingController _passwordTextEditingControlor =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: mainThemeColor),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            Text(
              "User Registration ",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
                color: blackFontColor,
              ),
            ),
            SizedBox(height: 30),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameTextEditingControlor,

                    validator: (value){
                      //to check user adding user name
                      if (value!.isEmpty) {
                        return "please Enter Your Name";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Your Name",
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
                  TextFormField(
                    controller: _emailTextEditingControlor,
                    validator: (value){
                      //to check user adding user name
                      if (value!.isEmpty) {
                        return "please Enter Your Email";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Your Email",
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
                  TextFormField(
                    validator: (value){
                      //to check user adding user name
                      if (value!.isEmpty) {
                        return "please Enter The Password";
                      }
                      return null;
                    },
                    controller: _passwordTextEditingControlor,
                    decoration: InputDecoration(
                      hintText: "Password",
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
                       if (_formKey.currentState!.validate()) {
                        
                        //form is valid
                      }
                    },
                    child: CustomButton(btnName: "Register")

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
