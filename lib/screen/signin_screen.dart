import 'package:booking/screen/home_screen.dart';
import 'package:booking/screen/signup_screen.dart';
import 'package:booking/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  late bool isLoading = false;
  late bool obsecure = true;
  late String error;
  late bool isVerify = false;
  final emailCon = TextEditingController();
  final passwordCon = TextEditingController();
  @override
  void initState() {
    super.initState();
    authService.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          _entryField(),
          customCircularProgress(),
          // _title(),
        ],
      ),
    );
  }

  Widget _title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 200,
        ),
        SingleChildScrollView(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: 'ANT ',
                style: GoogleFonts.portLligatSans(
                  textStyle: Theme.of(context).textTheme.headline4,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                children: [
                  TextSpan(
                    text: 'Training ',
                    style: TextStyle(color: Colors.black, fontSize: 30),
                  ),
                  TextSpan(
                    text: 'Center ',
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  TextSpan(
                    text: 'Technology',
                    style: TextStyle(color: Colors.black, fontSize: 30),
                  ),
                ]),
          ),
        ),
      ],
    );
  }

  Widget _entryField() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(30),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Email',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: emailCon,
                    style: TextStyle(fontSize: 15),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email is empty!';
                      }
                    },
                    decoration: InputDecoration(
                        hintText: 'Enter Email Address',
                        errorStyle:
                            TextStyle(color: Color(0xff630008), fontSize: 15),
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(50.0),
                          ),
                        ),
                        fillColor: Color(0xfff3f3f4),
                        filled: true),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Password',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    style: TextStyle(fontSize: 15),
                    controller: passwordCon,
                    obscureText: obsecure,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password is empty!';
                      }
                    },
                    decoration: InputDecoration(
                        hintText: 'Enter Password',
                        suffixIcon: new GestureDetector(
                          onTap: () {
                            setState(() {
                              obsecure = !obsecure;
                            });
                          },
                          child: new Icon(obsecure
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        errorStyle:
                            TextStyle(color: Color(0xff630008), fontSize: 15),
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(50.0),
                          ),
                        ),
                        fillColor: Color(0xfff3f3f4),
                        filled: true),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: onSubmitSignIn,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 13),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Login',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          'does not have accout yet?',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign up here',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showInformation(String smg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(smg),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 10),
        action: SnackBarAction(
          label: "OK",
          onPressed: () {
            Navigator.of(context);
          },
        ),
      ),
    );
  }

  void onSubmitSignIn() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      String? result =
          await authService.signIn(emailCon.text, passwordCon.text);
      if (result != null && result.contains('@')) {
        await authService.getCurrentUser().then((user) {
          isVerify = user!.emailVerified;
        });
        if (isVerify) {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return Home();
          }));
        } else {
          setState(() {
            error = "Please verify your email";
            showInformation(error);
          });
        }
      } else {
        setState(() {
          error = result!;
          showInformation(error);
          passwordCon.clear();
        });
      }
      setState(() {
        isLoading = false;
      });
    } else {
      return;
    }
  }

  Widget customCircularProgress() {
    if (isLoading) {
      return Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                backgroundColor: Colors.teal,
                strokeWidth: 10,
              ),
              SizedBox(
                height: 20,
              ),
              Text('Loading...'),
            ],
          ),
        ),
      );
    }
    return Container();
  }
}
