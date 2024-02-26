import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskify/service/LocalNotificationSevice.dart';
import 'package:taskify/viewmodel/AuthViewModel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AuthViewModel _authViewModel;

  void checkLogin() async{
    String? token = await FirebaseMessaging.instance.getToken();

    await Future.delayed(const Duration(milliseconds: 1600));
    // check for user detail first
    try{
      await _authViewModel.checkLogin(token);
      if(_authViewModel.user==null){
        Navigator.of(context).pushReplacementNamed("/login");
      }else{
        NotificationService.display(
          title: "Welcome back",
          body: "Hello ${_authViewModel.loggedInUser?.username},\n We have been waiting for you.",
        );
        Navigator.of(context).pushReplacementNamed("/home");
      }
    }catch(e){
      Navigator.of(context).pushReplacementNamed("/login");
    }

  }
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    });
    checkLogin();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/images/Taskify.gif"),
              SizedBox(height: 100,),
            ],
          ),
        ),
      ),
    );
  }
}
