
import 'package:flutter/material.dart';

showSnackBarSuccess(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
    ),
  );
}

 showSnackBarError(BuildContext context, String message) {
   ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
       content: Text(message),
       backgroundColor: Colors.red,
       duration: Duration(seconds: 2),
     ),
   );
}
