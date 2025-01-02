import 'package:flutter/material.dart';
import 'package:todo_app/components/my_button.dart';
import 'package:todo_app/components/my_text_field.dart';
import 'package:todo_app/models/app_user.dart';
import 'package:todo_app/pages/auth_page.dart';
import 'package:todo_app/pages/register_page.dart';
import 'package:todo_app/services/user_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    // Membersihkan semua controller saat widget dihapus
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: Column(
                children: [
                  SizedBox(height: height * 0.09),
                  Icon(
                    Icons.camera,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MyTextField(
                    textEditingController: emailController,
                    hint: 'email',
                    obscureText: false,
                  ),
                  SizedBox(height: 15),
                  MyTextField(
                    textEditingController: passwordController,
                    hint: 'password',
                    obscureText: true,
                  ),
                  SizedBox(height: 15),
                  MyButton(
                    onTap: () =>
                        login(context, emailController, passwordController),
                    text: 'login',
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'belum mendaftar?',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        ),
                        child: Text(
                          'Daftar Disini',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void login(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
  ) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // Validasi input fields dan tampilkan Snackbar jika ada yang kosong
    if (email.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter your email")),
        );
      }
      return;
    }

    if (password.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter your password")),
        );
      }
      return;
    }

    // Buat instance dari UserService
    UserService userService = UserService();

    try {
      // Login user menggunakan fungsi loginWithEmailPassword
      AppUser? loggedInUser =
          await userService.loginWithEmailPassword(email, password);

      if (loggedInUser != null && context.mounted) {
        // Navigasi ke halaman AuthPage atau tampilkan pesan sukses
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthPage()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Welcome back, ${loggedInUser.username}!"),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login error: $e")),
        );
      }
    }
  }
}
