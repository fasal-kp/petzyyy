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

  void sendOTP() async {
    String phone = phoneController.text.trim();
    if (phone.isEmpty || phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("📱 Enter a valid phone number")),
      );
      return;
    }

    setState(() => isLoading = true);

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91$phone',
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Optional: Automatic login
        try {
          await FirebaseAuth.instance.signInWithCredential(credential);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("✅ Auto verification complete")),
          );
          // TODO: Navigate to home
        } catch (e) {
          print("Auto verification error: $e");
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
            builder: (context) => OTPScreen(verificationId: verificationId),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("⚠️ Auto-retrieval timeout");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top illustration
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 60, bottom: 30),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF1C1),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(100),
                    bottomRight: Radius.circular(100)
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/pet image.png',
                    height: 150,
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                "Welcome",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Text(
                  "with more adoptable pets than ever, we have an urgent need for pet adopters.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),

              // Phone number input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    prefixText: "+91 ",
                    hintText: "Enter phone number",
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    side: const BorderSide(color: Colors.red),
                  ),
                  onPressed: isLoading ? null : sendOTP,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Send OTP", style: TextStyle(color: Colors.black)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 