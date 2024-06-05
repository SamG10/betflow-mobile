import 'package:auto_route/auto_route.dart';
import 'package:betflow_mobile_app/modals/auth.dart';
import 'package:betflow_mobile_app/routes/appRouter.gr.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final _usernameController = TextEditingController();
    final _passwordController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: new InputDecoration(
                labelText: "Username",
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
              ),
              controller: _usernameController,
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _passwordController,
              decoration: new InputDecoration(
                labelText: "Password",
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await Provider.of<AuthProvider>(context, listen: false).login(
                    _usernameController.text,
                    _passwordController.text,
                  );
                  context.router.navigate(HomeRoute());
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to login')),
                  );
                }
              },
              child: Text('Login'),
            ),
            SizedBox(height: 5),
            Text(
              "Don't have an account?",
              style: TextStyle(color: Colors.white),
            ),
            GestureDetector(
              onTap: () {
                context.router.navigate(RegisterRoute());
              },
              child: Text(
                "Register here",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
