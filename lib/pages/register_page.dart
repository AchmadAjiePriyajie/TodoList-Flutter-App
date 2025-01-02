import 'package:flutter/material.dart';
import 'package:todo_app/components/my_button.dart';
import 'package:todo_app/components/my_text_field.dart';
import 'package:todo_app/models/app_user.dart';
import 'package:todo_app/pages/auth_page.dart';
import 'package:todo_app/pages/login_page.dart';
import 'package:todo_app/services/user_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    // Membersihkan semua controller saat widget dihapus
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: Column(
                children: [
                  Icon(
                    Icons.camera,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Register',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MyTextField(
                    textEditingController: usernameController,
                    hint: 'username',
                    obscureText: false,
                  ),
                  SizedBox(height: 15),
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
                  MyTextField(
                    textEditingController: confirmPasswordController,
                    hint: 'konfirmasi password',
                    obscureText: true,
                  ),
                  SizedBox(height: 15),
                  MyButton(
                      onTap: () => register(emailController, usernameController,
                          passwordController, confirmPasswordController),
                      text: 'register'),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'sudah mendaftar?',
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
                            builder: (context) => LoginPage(),
                          ),
                        ),
                        child: Text(
                          'Login Disini',
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

  void register(
    TextEditingController emailController,
    TextEditingController usernameController,
    TextEditingController passwordController,
    TextEditingController confirmPasswordController,
  ) async {
    String email = emailController.text.trim();
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    // Validasi input fields dan tampilkan Snackbar jika ada yang kosong
    if (email.isEmpty ||
        username.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill in all fields")),
        );
      }
      return;
    }

    // Validasi password dan confirmPassword
    if (confirmPassword != password) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords don't match")),
        );
      }
      return;
    }

    // Buat instance dari UserService
    UserService userService = UserService();

    try {
      // Mendaftarkan user menggunakan fungsi registerWithEmailPassword
      AppUser? registeredUser = await userService.registerWithEmailPassword(
        email,
        password,
        username,
      );

      if (registeredUser != null && context.mounted) {
        // Navigasi ke halaman AuthPage atau tampilkan pesan sukses
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthPage()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "User registered successfully: ${registeredUser.username}")),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration error: $e")),
        );
      }
    }
  }
}
