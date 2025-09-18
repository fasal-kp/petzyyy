import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petzyyy/screens/OTPscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = false;

  /// Send OTP
  Future<void> sendOTP() async {
    String phone = phoneController.text.trim();

    if (phone.isEmpty || phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("📱 Please enter a valid phone number")),
      );
      return;
    }

    setState(() => isLoading = true);

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91$phone',
      timeout: const Duration(seconds: 60),

      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          await FirebaseAuth.instance.signInWithCredential(credential);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("✅ Phone number verified")),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => const OTPScreen(verificationId: "")),
            );
          }
        } catch (e) {
          debugPrint("Auto verification error: $e");
        }
      },

      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ ${e.message}")),
        );
        setState(() => isLoading = false);
      },

      codeSent: (String verificationId, int? resendToken) {
        setState(() => isLoading = false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OTPScreen(verificationId: verificationId),
          ),
        );
      },

      codeAutoRetrievalTimeout: (String verificationId) {
        debugPrint("⚠️ Auto retrieval timeout: $verificationId");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔥 Remove default white background
      backgroundColor: Colors.transparent,

      body: Container(
        width: double.infinity,
        height: double.infinity,

        // 🔥 Full gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6D5DF6), Color(0xFF46A0AE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),

                /// Top illustration
                Center(
                  child: Image.asset(
                    'assets/pet image.png',
                    height: 180,
                  ),
                ),

                const SizedBox(height: 30),

                /// Welcome text
                const Text(
                  "Welcome Back 👋",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "With more adoptable pets than ever, we have an urgent need for pet adopters.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ),

                const SizedBox(height: 40),

                /// 🔥 Transparent input card with no white patches
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24, width: 1),
                  ),
                  child: Column(
                    children: [
                      // Phone Number Input
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          counterText: "",
                          prefixText: "+91 ",
                          prefixStyle: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          hintText: "Enter phone number",
                          hintStyle: const TextStyle(color: Colors.white70),
                          prefixIcon: const Icon(Icons.phone,
                              color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.05),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(color: Colors.white38),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Send OTP Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : sendOTP,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 6,
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.deepPurple,
                                  ),
                                )
                              : const Text(
                                  "Send OTP",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                /// Footer text
                const Text(
                  "🐾 Petzyyy makes pet adoption easy & fun!",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
