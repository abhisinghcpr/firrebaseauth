import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'VerifyOtp.dart';

class PhoneVerification extends StatefulWidget {
  const PhoneVerification({Key? key}) : super(key: key);

  @override
  State<PhoneVerification> createState() => _PhoneVerificationState();
}
class _PhoneVerificationState extends State<PhoneVerification> {
  TextEditingController phoneVerification = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Phone Auth",style: TextStyle(color: Colors.blue,letterSpacing: 5,fontSize: 20)),
              SizedBox(height: 30,),

              TextFormField(
                controller: phoneVerification,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Enter phone number',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: "+91${phoneVerification.text.trim()}",
                        verificationCompleted: (PhoneAuthCredential credential)  {

                        },
                        verificationFailed: (FirebaseAuthException e) {
                          showToast("Verification Failed: ${e.message}");
                          print("Verification Failed: ${e.message}");
                        },
                        codeSent: (String verificationId, int? resendToken) {
                          showToast(" Send OTP Successfully: ");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VerifyOtp(verificationId: verificationId),
                            ),
                          );
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {
                          showToast("Code Auto-Retrieval Timeout: $verificationId");
                          print("Code Auto-Retrieval Timeout: $verificationId");
                        },
                      );
                    } catch (e) {
                      showToast("Exception: $e");
                      print("Exception: $e");
                    }
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
