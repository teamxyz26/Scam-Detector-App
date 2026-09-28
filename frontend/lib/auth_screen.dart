import 'package:flutter/material.dart';

import 'app_colors.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.destinationBuilder});

  final Widget Function() destinationBuilder;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isSignIn = true;
  bool obscurePassword = true;

  void continueToApp() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => widget.destinationBuilder()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(28, 34, 28, 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                children: [
                  Container(
                    width: 86,
                    height: 86,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10292B),
                      border: Border.all(color: const Color(0xFF23696A)),
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: const [
                        BoxShadow(color: Color(0x3324BFC0), blurRadius: 30),
                      ],
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      color: aqua,
                      size: 43,
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'S C A M G U A R D  A I',
                    style: TextStyle(
                      color: aqua,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.4,
                    ),
                  ),
                  const SizedBox(height: 17),
                  Text(
                    isSignIn ? 'Welcome back' : 'Create account',
                    style: const TextStyle(
                      fontSize: 29,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isSignIn
                        ? 'Sign in to your account'
                        : 'Start protecting yourself today',
                    style: const TextStyle(color: muted, fontSize: 16),
                  ),
                  const SizedBox(height: 34),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: panel,
                      border: Border.all(color: line),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        _authTab(
                          'SIGN IN',
                          isSignIn,
                          () => setState(() => isSignIn = true),
                        ),
                        _authTab(
                          'SIGN UP',
                          !isSignIn,
                          () => setState(() => isSignIn = false),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: OutlinedButton.icon(
                      onPressed: continueToApp,
                      icon: const Text(
                        'G',
                        style: TextStyle(
                          color: Color(0xFF4285F4),
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      label: const Text(
                        'Continue with Google',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: line),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      const Expanded(child: Divider(color: line)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          'O R',
                          style: TextStyle(color: muted, letterSpacing: 2),
                        ),
                      ),
                      const Expanded(child: Divider(color: line)),
                    ],
                  ),
                  const SizedBox(height: 23),
                  _authField('EMAIL', 'you@example.com', Icons.mail_outline),
                  const SizedBox(height: 17),
                  _authField(
                    'PASSWORD',
                    '••••••••',
                    Icons.lock_outline,
                    trailing: IconButton(
                      onPressed: () =>
                          setState(() => obscurePassword = !obscurePassword),
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: muted,
                        size: 20,
                      ),
                    ),
                  ),
                  if (isSignIn)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'FORGOT PASSWORD?',
                          style: TextStyle(color: aqua, fontSize: 11),
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 17),
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: continueToApp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cyan,
                        foregroundColor: const Color(0xFF071114),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        isSignIn ? 'Sign In' : 'Create Account',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: continueToApp,
                    child: const Text(
                      'Continue as guest',
                      style: TextStyle(color: muted, fontSize: 15),
                    ),
                  ),
                  const SizedBox(height: 26),
                  const Text(
                    'By continuing you agree to our Terms and Privacy Policy',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: muted, fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _authTab(String label, bool selected, VoidCallback onTap) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF0D1214) : Colors.transparent,
          border: selected ? Border.all(color: line) : null,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : muted,
            fontSize: 11,
            letterSpacing: 2,
          ),
        ),
      ),
    ),
  );

  Widget _authField(
    String label,
    String hint,
    IconData icon, {
    Widget? trailing,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(color: muted, fontSize: 10, letterSpacing: 2),
      ),
      const SizedBox(height: 8),
      TextField(
        obscureText: label == 'PASSWORD' && obscurePassword,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: muted, fontSize: 15),
          prefixIcon: Icon(icon, color: muted, size: 20),
          suffixIcon: trailing,
          filled: true,
          fillColor: const Color(0xFF101216),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: line),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: line),
          ),
        ),
      ),
    ],
  );
}
