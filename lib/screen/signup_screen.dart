import 'package:flutter/material.dart';
import 'package:fluttterapp/screen/product_list_screen.dart';
import 'package:provider/provider.dart';

import '../const/colors_const.dart';
import '../data/authentication_data.dart';
import '../services/auth_provider.dart';
import 'login_screen.dart';


class SignUp_Screen extends StatefulWidget {

  SignUp_Screen( {super.key});

  @override
  State<SignUp_Screen> createState() => _SignUp_ScreenState();
}

class _SignUp_ScreenState extends State<SignUp_Screen> {
  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  FocusNode _focusNode3 = FocusNode();

  final email = TextEditingController();
  final password = TextEditingController();
  final PasswordConfirm = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focusNode1.addListener(() {
      setState(() {});
    });
    _focusNode2.addListener(() {
      setState(() {});
    });
    _focusNode3.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {

    var myHeight = MediaQuery.of(context).size.height;
    var myWidth =  MediaQuery.of(context).size.width;
    var myEmojiStyle = TextStyle(fontSize:100 );
    var mySizeBox = SizedBox(height: 20);


    return Scaffold(
      backgroundColor: backgroundColors,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              mySizeBox,
              mySizeBox,
              mySizeBox,
              Text("🙋", style: myEmojiStyle,),
              SizedBox(height: 50),
              textfield(email, _focusNode1, 'Enter Email', Icons.email),
              mySizeBox,
              textfield(password, _focusNode2, 'Enter Password', Icons.remove_red_eye),
              mySizeBox,
              textfield(PasswordConfirm, _focusNode3, 'Enter PasswordConfirm',
                  Icons.remove_red_eye),
              SizedBox(height: 10),
              account(),
              mySizeBox,
              SignUP_bottom(),
            ],
          ),
        ),
      ),
    );
  }

  Widget account() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Don you have an account?",
            style: TextStyle(color: Colors.grey[700], fontSize: 14),
          ),
          SizedBox(width: 5),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LogIN_Screen(),
                ),
              );
            },
            child: Text(
              'Login',
              style: TextStyle(
                  color: app_primary_color,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Widget SignUP_bottom() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: GestureDetector(


        onTap: () async {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          await authProvider.signUp(email.text, password.text);
          if (authProvider.isAuthenticated) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductListScreen(),
              ),
            );

          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to log in.')),
            );
          }
        },
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: app_primary_color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'Sign Up',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget textfield(TextEditingController _controller, FocusNode _focusNode,
      String typeName, IconData iconss) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          style: TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
              prefixIcon: Icon(
                iconss,
                color: _focusNode.hasFocus ? app_primary_color : Color(0xffc5c5c5),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              hintText: typeName,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Color(0xffc5c5c5),
                  width: 2.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: app_primary_color,
                  width: 2.0,
                ),
              )),
        ),
      ),
    );
  }

  Widget image() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        width: double.infinity,
        height: 300,
        decoration: BoxDecoration(
          color: backgroundColors,
          image: DecorationImage(
            image: AssetImage('images/7.png'),
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
