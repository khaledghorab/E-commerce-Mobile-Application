import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models//http_exception.dart';
import 'package:provider/provider.dart';
import '../Providers/auth.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = "/Auth";

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

enum AuthMode { Login, SignUp }

class _AuthScreenState extends State<AuthScreen> {
  AuthMode _authMode = AuthMode.Login;
  bool passwordVisible = true;
  final _formKey = GlobalKey<FormState>();
  final _authData = {"email": "", "password": ""};
  final _passwordContoller = TextEditingController();
  bool _isLoading = false;
  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false)
            .login(_authData["email"], _authData["password"]);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signUp(_authData["email"], _authData["password"]);
      }
    } on HttpException catch (error) {
      var errorMessage = "Authentication failed";
      if (error.toString().contains("EMAIL_EXISTS"))
        errorMessage = "This email address is already in use";
      if (error.toString().contains("INVALID_EMAIL"))
        errorMessage = "This is not a valid email address";
      if (error.toString().contains("WEAK_PASSWORD"))
        errorMessage = "This password is too weak";
      if (error.toString().contains("EMAIL_NOT_FOUND"))
        errorMessage = "Could not find a user with that email";
      if (error.toString().contains("INVALID_PASSWORD"))
        errorMessage = "Invalid password";
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
    } else if (_authMode == AuthMode.SignUp) {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
    print(_authMode);
  }

  void _showErrorDialog(String erorrMessage) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("An Error Occured"),
              content: Text(erorrMessage),
              actions: [
                FlatButton(
                    child: Text("OK!"),
                    onPressed: () => Navigator.of(ctx).pop())
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final node = FocusScope.of(context);

    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        width: deviceSize.width,
        height: deviceSize.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
                colors: [Colors.deepPurple, Colors.deepOrange])),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60),
                Text("My Shop",
                    style: TextStyle(
                        color:
                            Theme.of(context).accentTextTheme.headline6.color,
                        fontSize: 50,
                        fontFamily: "Anton")),
                SizedBox(height: 40),
                _authMode == AuthMode.Login
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text("Welcome,",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            Text("Login to continue!",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 30),
                          ])
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Create an account, ",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text("Sign up to get start!",
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 30),
                        ],
                      ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Container(
                          width: double.infinity,
                          child: Text("E-MAIL ADDRESS",
                              style: TextStyle(color: Colors.white))),
                      TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        key: ValueKey("email"),
                        validator: (val) {
                          if (val.isEmpty || !val.contains("@"))
                            return "Please enter a valid email address";
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (val) => _authData["email"] = val,
                        cursorHeight: 35,
                        cursorColor: Colors.grey,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        onEditingComplete: () => node.nextFocus(),
                      ),
                      SizedBox(height: 15),
                      Container(
                          width: double.infinity,
                          child: Text("PASSWORD",
                              style: TextStyle(color: Colors.white))),
                      TextFormField(
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,color: Colors.white,),
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                            )),
                        key: ValueKey("password"),
                        controller: _passwordContoller,
                        validator: (val) {
                          if (val.isEmpty || val.length < 7)
                            return "Password must be at least 7 characters";
                          return null;
                        },
                        cursorHeight: 35,
                        onSaved: (val) => _authData["password"] = val,
                        obscureText: passwordVisible,
                        cursorColor: Colors.grey,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        onEditingComplete: () => node.nextFocus(),
                      ),
                      if (_authMode == AuthMode.SignUp)
                        Column(
                          children: [
                            SizedBox(height: 15),
                            Container(
                                width: double.infinity,
                                child: Text("CONFIRM PASSWORD",
                                    style: TextStyle(color: Colors.white))),
                            TextFormField(
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              validator: (val) {
                                if (val != _passwordContoller.text)
                                  return "Password isn't match";
                                return null;
                              },
                              enabled: _authMode == AuthMode.SignUp,
                              cursorHeight: 35,
                              obscureText: true,
                              cursorColor: Colors.grey,
                              onSaved: _authMode == AuthMode.Login
                                  ? (val) => _authData["password"] = val
                                  : null,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                              onFieldSubmitted: (_) => node.unfocus(),
                            ),
                          ],
                        ),
                      SizedBox(height: 40),
                      if (_isLoading)
                        Column(
                          children: [
                            CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            ),
                            SizedBox(height: 30)
                          ],
                        ),
                      RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        textColor: Colors.white,
                        color: Colors.black,
                        child: Container(
                            width: deviceSize.width,
                            child: Center(
                                child: Text(_authMode == AuthMode.Login
                                    ? "LOGIN"
                                    : "SIGN UP"))),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        onPressed: () {
                          _submit();
                        },
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              _authMode == AuthMode.Login
                                  ? "Don't have an account?"
                                  : "I already have an account.",
                              style: TextStyle(color: Colors.white)),
                          FlatButton(
                              onPressed: () {
                                _switchAuthMode();
                              },
                              child: Text(
                                  _authMode == AuthMode.Login
                                      ? "Sign Up"
                                      : "Login",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline)))
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
