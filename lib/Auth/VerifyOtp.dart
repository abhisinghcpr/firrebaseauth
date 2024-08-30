import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';

import '../HomePage.dart';



class VerifyOtp extends StatefulWidget {
  final String verificationId;

  const VerifyOtp({super.key, required this.verificationId});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}
class _VerifyOtpState extends State<VerifyOtp> {
  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
    );
  }
  TextEditingController otpController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child:   TextFormField(
                controller: otpController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Enter Otp',
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
            ),
            ElevatedButton(onPressed: () async {
              try {
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId:widget.verificationId,
                  smsCode : otpController.text.toString(),
                );

                await FirebaseAuth.instance.signInWithCredential(credential);
                showToast("Success");
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage() ,));
              }
              catch (ex) {
                log(ex.toString());

              }
            }, child: const Text("Submit"))

          ],
        ),
      ),
    );
  }
}