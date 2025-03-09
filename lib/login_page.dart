import 'package:democalls/services/login_service.dart';
import 'package:democalls/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:democalls/constants/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _userIDTextCtrl = TextEditingController(
    text: 'user_id',
  );
  final ValueNotifier<bool> _passwordVisible = ValueNotifier<bool>(false);
  bool _isLoading = false;

  final TextStyle textStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ); // ✅ Fixed `textStyle`

  @override
  void initState() {
    super.initState();
    getUniqueUserId().then((userID) {
      if (mounted) {
        setState(() {
          _userIDTextCtrl.text = userID;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            logo(),
            const SizedBox(height: 50),
            userIDEditor(),
            passwordEditor(),
            const SizedBox(height: 30),
            signInButton(),
            if (_isLoading)
              const CircularProgressIndicator(), // ✅ Loading indicator
          ],
        ),
      ),
    );
  }

  Widget logo() {
    return Center(
      child: Image.asset(
        'assets/image.png',
        width: 200,
        height: 200,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.image_not_supported,
            size: 100,
            color: Colors.grey,
          );
        },
      ),
    );
  }

  Widget userIDEditor() {
    return TextFormField(
      controller: _userIDTextCtrl,
      decoration: const InputDecoration(
        labelText: 'Phone Num. (Used as user ID)',
      ),
      onChanged: (value) {
        setState(() {}); // ✅ Ensure UI updates when user types
      },
    );
  }

  Widget passwordEditor() {
    return ValueListenableBuilder<bool>(
      valueListenable: _passwordVisible,
      builder: (context, isPasswordVisible, _) {
        return TextFormField(
          obscureText: !isPasswordVisible,
          decoration: InputDecoration(
            labelText: 'Password (Any character for test)',
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                _passwordVisible.value = !_passwordVisible.value;
              },
            ),
          ),
        );
      },
    );
  }

  Widget signInButton() {
    return ElevatedButton(
      onPressed:
          (_isLoading || _userIDTextCtrl.text.isEmpty)
              ? null
              : _handleLogin, // ✅ Disable if empty
      child: Text('Sign In', style: textStyle),
    );
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true); // ✅ Show loading before login

    try {
      await login(
        userId: _userIDTextCtrl.text,
        userName: 'user_${_userIDTextCtrl.text}',
      );

      if (mounted) {
        Navigator.pushNamed(
          context,
          PageRouteName.home,
        ); // ✅ Navigate only if mounted
      }
    } catch (e) {
      debugPrint('Login Error: $e'); // ✅ Handle login failure
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed. Please try again.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false); // ✅ Hide loading after login
      }
    }
  }
}
