import 'dart:convert';
import 'package:app_news/constant/constantsFile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// // void main () {
// //   runApp(Register());
// }

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String? username, email, password;

  bool _secureText = true;

  final _key = GlobalKey<FormState>();

  void showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  chek() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      save();
    }
  }

  save() async{
    final response =await http.post(
      Uri.parse("http://192.168.1.16/appnews/register.php"), body: {
        "username" : username,
        "email" : email,
        "password" : password,
    });

    final data = jsonDecode(response.body);
    int value =  data['value'];
    String pesan =  data['message'];
    if(value == 1) {
      setState(() {
        Navigator.pop(context);
      });
    } else{
      print(pesan);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(15),
          children: [
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please insert Username';
                }
                return null;
              },
              onSaved: (e) => username = e,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please insert Email';
                }
                return null;
              },
              onSaved: (e) => email = e!,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextFormField(
              validator: (e) {
                if (e!.isEmpty) {
                  return 'Please insert Password';
                }
                return null;
              },
              obscureText: _secureText,
              onSaved: (e) => password = e!,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  onPressed: showHide,
                  icon: Icon(
                    _secureText ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
            ),
            MaterialButton(onPressed: (){
              chek(); 
            },
            child: Text('Register'),
            )
          ],
        ),
      ),
    );
  }
}
