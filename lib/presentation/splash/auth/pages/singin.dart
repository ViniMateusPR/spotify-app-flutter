import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotifyapp/common/widgets/appBar/app_bar.dart';
import 'package:spotifyapp/common/widgets/button/basic_app_button.dart';
import 'package:spotifyapp/core/configs/assets/app_vectors.dart';
import 'package:spotifyapp/data/models/auth/signin_user_req.dart';
import 'package:spotifyapp/presentation/splash/auth/pages/singup.dart';

import '../../../../domain/usecases/auth/sigin.dart';
import '../../../../service_locator.dart';
import '../../home/pages/home.dart';

class SigninPage extends StatelessWidget {
  SigninPage({super.key});

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _singupText(context),
      appBar: BasicAppBar(
        title: SvgPicture.asset(
          AppVectors.logo,
          height: 40,
          width: 40,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
            vertical: 50,
            horizontal: 30
        ),
        child: Column(
          children: [
            _singInText(),
            const SizedBox(
              height: 50,
            ),
            _usernameOrEmailField(context),
            const SizedBox(
              height: 20,
            ),
            _passwordField(context),
            const SizedBox(
              height: 20,
            ),
            BasicAppButton(onPressed: () async {
              var result = await sl<SigninUseCase>().call(
                  params: SinginUserReq(
                      email: _email.text.toString(),
                      password: _password.text.toString()
                  )
              );
              result.fold(
                    (l) {
                  var snackBar = SnackBar(
                    content: Text(l),
                    behavior: SnackBarBehavior.floating,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                    (r) {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                      builder: (BuildContext context) => const HomePage()),
                          (route) => false);
                },
              );
            }, title: 'Sing In')
          ],
        ),
      ),
    );
  }

  Widget _singInText() {
    return Text(
      'Sing In',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _usernameOrEmailField(BuildContext context) {
    return TextField(
      controller: _email,
      decoration: InputDecoration(
        hintText: 'Enter Email',
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _passwordField(BuildContext context) {
    return PasswordField(controller: _password);
  }

  Widget _singupText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 30
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Not a Member? ',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14
            ),
          ),
          TextButton(onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (BuildContext context) => SingupPage()));
          }, child: const Text('Register Now',
            style: TextStyle(
                color: Colors.blue
            ),))
        ],
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  final TextEditingController controller;

  PasswordField({required this.controller});

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        hintText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }
}
