import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//the link tells how the google api works
//https://firebase.google.com/docs/reference/rest/auth

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> _authenticate(String email, String password, String urlSegment) async{
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDmxw7KEiTGhjQiMo6WDNTCwHVWOcyzyp0';
    final response = await http.post(
      url,
      body: json.encode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );
    print(json.decode(response.body));
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, "signupNewUser");
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "verifyPassword");
  }


}
