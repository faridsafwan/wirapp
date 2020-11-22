import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wiprapp/models/user/user.dart';
import 'package:wiprapp/models/user/user_insert.dart';
import 'package:wiprapp/services/user_services.dart';

class Register extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Register> {
  UsersService get usersService => GetIt.I<UsersService>();

  String errorMessage;
  User user;
  String roleVal;
  List role = ["Student", "Organiser"];
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registration')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              width: double.infinity,
              height: 35,
              child: TextField(
                  decoration: InputDecoration(hintText: 'Name'),
                  controller: _nameController),
            ),
            SizedBox(height: 50.0),
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
              child: DropdownButton(
                hint: Text("Select Your role"),
                value: roleVal,
                items: role.map((value) {
                  return DropdownMenuItem(
                    child: Text(value),
                    value: value,
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    roleVal = value;
                  });
                },
              ),
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
                        name: _nameController.text,
                        role: roleVal);
                    final result = await usersService.register(user);
                    setState(() {
                      _isLoading = false;
                    });
                    final title = 'Done';
                    final text = result.error
                        ? (result.errorMessage ?? "An error occured")
                        : 'Register success';

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
                      if (result.error == false) {
                        Navigator.of(context).pop();
                      }
                    });
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Theme.of(context).primaryColor),
            ),
          ]),
        ),
      ),
    );
  }
}
