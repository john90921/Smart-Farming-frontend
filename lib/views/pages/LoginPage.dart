import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:fv2/api/ApiHelper.dart';
import 'package:fv2/dio/DioHandler.dart';
import 'package:fv2/providers/UserProvider.dart';
import 'package:fv2/token/TokenManager.dart';
import 'package:fv2/views/WidgetTree.dart';
import 'package:fv2/views/pages/HomePage.dart';
import 'package:fv2/views/pages/OtpScreen.dart';
import 'package:fv2/views/pages/components/loading/showCircularDialog.dart';
import 'package:provider/provider.dart';

//sorvictor90@gmail.com
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<String?> _authUser(BuildContext context) async {
    bool statusLogin = false;
    String message = "";

    showCircularDialog(context);
    if (_formKey.currentState!.validate()) {
      try {
        ApiResult result = await Apihelper.post(
          ApiRequest(
            path: "/login",
            data: {
              "email": _emailController.text,
              "password": _passwordController.text,
            },
          ),
        );

        if (result.status == true) {
          final token = result.data["token"];
          if (token != null) {
            await TokenManager.instance.saveAccessToken(token); // login success
          }

          final saveToken = await TokenManager.instance.loadAccessToken();
          print("login successfull, {$saveToken}");
          print("user data: ${result.data}");
          
          Map<String, dynamic> user =
              result.data["user"] as Map<String, dynamic>;
          Provider.of<UserProvider>(context, listen: false).login(user);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("login successfull")));
          statusLogin = true;
          message = "success";
        } else {
          if (result.message == "unverified") {
            message = result.message;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Account unverified, redirecting to OTP screen"),
              ),
            );
          } else {
            print("login error: ${result.message}");
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("invalid credentials")));
          }
        }
      } catch (e) {
        print("login error: $e");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Login error: $e")));
      }
      Navigator.pop(context); // close loading dialog
      if (statusLogin) {
        if (!mounted) return null;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const WidgetTree()),
          (Route<dynamic> route) => false,
        );
      } else if (!statusLogin) {
        if (message == "unverified") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Account unverified, redirecting to OTP screen"),
            ),
          );
          String gmail = _emailController.text;
          if (context.mounted) {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (_, __, ___) =>
                    OtpScreen(gmail: gmail, isForResetPassword: false),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }
        }
      }
    }
    return null;
  }

  // void _login() {
  //   if (_formKey.currentState!.validate()) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(
  //           'Email: ${_emailController.text}, Password: ${_passwordController.text}',
  //         ),
  //       ),
  //     );
  //   }
  // }
  String selectedValue = "Staff";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person, size: 100, color: Colors.blueAccent),
                  const SizedBox(height: 20),
                  const Text(
                    "Welcome",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Sign in to continue",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Email Field
                  Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.email),
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                          if (!emailRegExp.hasMatch(value)) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.lock),
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10),

                  // Forgot Password
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: TextButton(
                  //     onPressed: () {
                  //       Navigator.pushNamed(context, '/requestResetPage');
                  //     },
                  //     child: const Text(
                  //       "Forgot Password?",
                  //       style: TextStyle(color: Colors.blueAccent),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButton<String>(
                      underline: const SizedBox(),
                      isExpanded: true,
                      value: selectedValue,
                      items: ["Staff", "Manager"].map((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedValue = newValue!;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(value: false, onChanged: (value) {}),
                          const Text("Remember me"),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/requestResetPage');
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _authUser(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Login"),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
