import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiprapp/models/user/user.dart';
import 'package:wiprapp/models/user/user_insert.dart';
import 'package:wiprapp/services/user_services.dart';
import 'package:wiprapp/views/event/eventRecord_list.dart';
import 'package:wiprapp/views/event/eventRegister_list.dart';
import 'package:wiprapp/views/login/register.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  UsersService get usersService => GetIt.I<UsersService>();

  String errorMessage;
  User user;
  bool isLoggedIn = false;
  String name = '';
  bool _isLoading = false;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // autoLogIn();
  }

  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString('username');

    if (userId != null) {
      setState(() {
        isLoggedIn = true;
        name = userId;
      });
      return;
    }
  }

  Future<Null> store(name, id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', name);
    prefs.setString('userID', id);
    print(name);
  }

  // Future<Null> loginUser() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('username', nameController.text);

  //   setState(() {
  //     name = nameController.text;
  //     isLoggedIn = true;
  //   });

  //   nameController.clear();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              width: double.infinity,
              height: 35,
              child: TextField(
                  decoration: InputDecoration(hintText: 'Email'),
                  controller: _emailController),
            ),
            SizedBox(height: 50.0),
            SizedBox(
              width: double.infinity,
              height: 35,
              child: TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(hintText: 'Password'),
                  controller: _passwordController),
            ),
            SizedBox(height: 50.0),
            SizedBox(
              width: double.infinity,
              height: 35,
              child: RaisedButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    final user = UserManipulation(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                    final result = await usersService.login(user);
                    setState(() {
                      _isLoading = false;
                    });
                    final title = 'Error';
                    final text = result.error
                        ? (result.errorMessage ?? "An error occured")
                        : 'Login success';
                    if (result.error == false) {
                      store(result.data.name, result.data.userID);
                      if (result.data.role == "Organiser") {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => EventRecordList()));
                      } else if (result.data.role == "Student") {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => EventRegisterList()));
                      }
                    } else {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text(title),
                                content: Text(text),
                                actions: [
                                  FlatButton(
                                    child: Text('Ok'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              )).then((data) {
                        // if (result) {
                        //   Navigator.of(context).pop();
                        // }
                      });
                    }
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Theme.of(context).primaryColor),
            ),
            SizedBox(height: 50.0),
            new GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => Register()));
              },
              child: new Text("Register here"),
            )
          ]),
        ),
      ),
    );
  }
}
