import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hey/model/user_registration.dart';
import 'package:hey/ui/home_page.dart';
import 'package:hey/util/constants.dart';
import 'package:hey/util/validator.dart';

class RegisterPage extends StatefulWidget {
  static const path = '/register';

  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // key for accessing form validation
  final _form = GlobalKey<FormState>();
  final _user = TextEditingController();
  final _pass = TextEditingController();
  final _email = TextEditingController();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Center(
          child: Form(
              key: _form,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: _user,
                    validator: Validator.validateUsername,
                    decoration: const InputDecoration(labelText: "Username"),
                  ),
                  TextFormField(
                    controller: _pass,
                    validator: Validator.validatePassword,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Password"),
                  ),
                  TextFormField(
                    controller: _email,
                    validator: Validator.validateEmail,
                    decoration: const InputDecoration(labelText: "Email"),
                  ),
                  TextFormField(
                    controller: _firstName,
                    validator: Validator.validateName,
                    decoration: const InputDecoration(labelText: "First name"),
                  ),
                  TextFormField(
                    controller: _lastName,
                    validator: Validator.validateName,
                    decoration: const InputDecoration(labelText: "Last name"),
                  ),
                  TextFormField(
                    controller: _phone,
                    validator: Validator.validatePhoneNumber,
                    keyboardType: TextInputType.phone,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: const InputDecoration(labelText: "Phone number"),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: register,
                      child: const Text("Sign up"),
                    ),
                  )
                ],
              ))),
    );
  }

  register() async {
    if (_form.currentState!.validate()) {
      var reg = UserRegistration(
          username: _user.text,
          password: _pass.text,
          email: _email.text,
          firstName: _firstName.text,
          lastName: _lastName.text,
          phoneNum: _phone.text);

      var user = await Constants.api.createUser(reg);

      Navigator.pop(context, user);
    }
  }
}
