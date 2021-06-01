import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'home.dart';
import 'api.dart';

class AuthSigninScreen extends StatelessWidget {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Sign in')),
        body: Builder(builder: (BuildContext context) {
          return Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Phone number',
                    filled: true,
                    isDense: true,
                  ),
                  controller: _phoneController,
                  autocorrect: false,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) return 'Phone number is required';
                    return null;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    isDense: true,
                  ),
                  controller: _passwordController,
                  autocorrect: false,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) return 'Password is required';
                    return null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_key.currentState!.validate()) {
                      if (await Api.login(_phoneController.text, _passwordController.text)) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomeScreen())
                        );
                      } else {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Invalid Phone number/Password'),
                            content: const Text('Please try again'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    } else {
                      print('Login form not validated');
                    }
                  },
                  child: Text('Login'),
                ),
              ],
            ),
          );
        },),
        floatingActionButton: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AuthSignupScreen()),
            );
          },
          child: Text("Don't have an account? Sign up"),
        )
    )
    );
  }
}

class AuthSignupScreen extends StatelessWidget {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Sign up')),
        body: Builder(builder: (BuildContext context) {
          return Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Phone number',
                    filled: true,
                    isDense: true,
                  ),
                  controller: _phoneController,
                  autocorrect: false,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) return 'Phone number is required';
                    return null;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    isDense: true,
                  ),
                  controller: _passwordController,
                  autocorrect: false,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) return 'Password is required';
                    return null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_key.currentState!.validate()) {
                      if (await Api.signup(_phoneController.text, _passwordController.text)) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomeScreen())
                        );
                      } else {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Invalid Phone number/Password'),
                            content: const Text('Please try again'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    } else {
                      print('Signup form not validated');
                    }
                  },
                  child: Text('Sign up'),
                ),
              ],
            ),
          );
        },)
    );
  }
}

