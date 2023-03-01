import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static String verificationId = "";
  static String finalNumber = "";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'IN';
  PhoneNumber number = PhoneNumber(isoCode: 'IN');
  // ignore: non_constant_identifier_names
  bool valid_num = false;
  bool buttonClicked = false;
  // ignore: non_constant_identifier_names
  String e_msg = '';
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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Welcome, Thank You for being with us",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
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
                        "Enter Your Mobile No.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Text(
                        "Hey Beautiful, can you give your mobile no so i can verify you...!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: Colors.black.withOpacity(0.13)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xffeeeeee),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            InternationalPhoneNumberInput(
                              onInputChanged: (PhoneNumber number) {
                                LoginPage.finalNumber = number.phoneNumber!;
                              },
                              onInputValidated: (bool value) {
                                if (value) {
                                  // print(final_number);
                                  valid_num = true;
                                } else {
                                  e_msg = 'Please enter a valid phone number';
                                }
                              },
                              selectorConfig: const SelectorConfig(
                                selectorType:
                                    PhoneInputSelectorType.BOTTOM_SHEET,
                              ),
                              countrySelectorScrollControlled: true,
                              initialValue: PhoneNumber(isoCode: 'IN'),
                              ignoreBlank: false,
                              autoValidateMode: AutovalidateMode.disabled,
                              selectorTextStyle:
                                  const TextStyle(color: Colors.black),
                              textFieldController: controller,
                              formatInput: false,
                              maxLength: 10,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: true, decimal: true),
                              cursorColor: Colors.black,
                              inputDecoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.only(bottom: 15, left: 0),
                                border: InputBorder.none,
                                hintText: 'Phone Number',
                                hintStyle: TextStyle(
                                    color: Colors.grey.shade500, fontSize: 16),
                              ),
                            ),
                            Positioned(
                              left: 90,
                              top: 8,
                              bottom: 8,
                              child: Container(
                                height: 40,
                                width: 1,
                                color: Colors.black.withOpacity(0.13),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 50,
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
                                onPressed: onPressed,
                                child: const Text(
                                  "Next",
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
      buttonClicked = true;
    });
    if (valid_num) {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: LoginPage.finalNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            // ignore: prefer_const_constructors
            SnackBar(
              content: const Text('Try After Some Time'),
              action: SnackBarAction(
                  label: 'Ok',
                  onPressed: () {
                    setState(() {
                      buttonClicked = false;
                    });
                  }),
            ),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          LoginPage.verificationId = verificationId;
          Navigator.pushNamed(context, '/verifyotp');
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } else {
      setState(() {
        buttonClicked = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        // ignore: prefer_const_constructors
        SnackBar(
          content: const Text('Invalid Mobile No.'),
          action: SnackBarAction(label: 'Ok', onPressed: () {}),
        ),
      );
    }
  }
}
