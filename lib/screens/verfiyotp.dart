import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class VerifyOTP extends StatefulWidget {
  const VerifyOTP({super.key});

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    // ignore: unused_local_variable
    Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          resendTimer--;
        });
      }
    });
  }

  final TextEditingController pinController = TextEditingController();
  bool buttonClicked = false;
  String uid = '';
  String otp = '';
  String mobileNo = LoginPage.finalNumber;
  int resendTimer = 60;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 30),
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.blue,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text(
                        "Verify OTP",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Text(
                      'OTP has been sent to $mobileNo',
                      style: const TextStyle(
                          color: Colors.white,
                          // fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Enter Your OTP",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Text(
                        "Could you please share the sceret that only the two of us have?",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Pinput(
                          defaultPinTheme: PinTheme(
                            height: 50,
                            width: 40,
                            margin: const EdgeInsets.only(right: 2),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 232, 235, 241),
                                // border: Border.all(
                                //   width: 1,
                                // ),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(blurRadius: 3, color: Colors.grey)
                                ]),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Color.fromARGB(255, 70, 70, 70),
                            ),
                          ),
                          controller: pinController,
                          length: 6,
                          onCompleted: (value) async {
                            otp = value;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        'Didn\'t Recieved OTP? ',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      resendTimer == 0
                          ? InkWell(
                              onTap: onPressed,
                              child: const Text(
                                "Resend",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green),
                              ),
                            )
                          : resendTimer >= 10
                              ? Text(
                                  '00:$resendTimer',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.redAccent,
                                  ),
                                )
                              : Text(
                                  '00:0$resendTimer',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.redAccent,
                                  ),
                                ),
                      const SizedBox(
                        height: 30,
                      ),
                      buttonClicked == true
                          ? const SizedBox(
                              height: 45,
                              width: 45,
                              child: CircularProgressIndicator(
                                color: Colors.blue,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: 200,
                              height: 45,
                              child: ElevatedButton(
                                onPressed: () async {
                                  try {
                                    setState(() {
                                      buttonClicked = true;
                                    });
                                    PhoneAuthCredential credential =
                                        PhoneAuthProvider.credential(
                                            verificationId:
                                                LoginPage.verificationId,
                                            smsCode: otp);

                                    // Sign the user in (or link) with the credential
                                    await FirebaseAuth.instance
                                        .signInWithCredential(credential);
                                    uid =
                                        FirebaseAuth.instance.currentUser!.uid;
                                    final SharedPreferences sharedPreferences =
                                        await SharedPreferences.getInstance();
                                    sharedPreferences.setString("uid", uid);
                                    //ignore: use_build_context_synchronously
                                    Navigator.pushNamed(context, '/home');
                                  } catch (e) {
                                    setState(() {
                                      buttonClicked = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      // ignore: prefer_const_constructors
                                      SnackBar(
                                        content: const Text('Invalid OTP'),
                                        action: SnackBarAction(
                                            label: 'Ok', onPressed: () {}),
                                      ),
                                    );
                                    // print(e);
                                    // print('wrong otp');
                                  }
                                },
                                child: const Text(
                                  "Verify",
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
              ),
            )
          ],
        ),
      ),
    );
  }

  onPressed() async {
    setState(() {
      resendTimer = 60;
      startTimer();
    });
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: LoginPage.finalNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          // ignore: prefer_const_constructors
          SnackBar(
            content: const Text('Try After Some Time'),
            action: SnackBarAction(label: 'Ok', onPressed: () {}),
          ),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        LoginPage.verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}
