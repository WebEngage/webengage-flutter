// import 'package:flutter/material.dart';
// import 'package:flutter_personalization_sdk_example/src/utils/Utils.dart';
// import 'package:flutter_personalization_sdk_example/src/widgets/customWidgets/Button.dart';
// import 'package:flutter_personalization_sdk_example/src/widgets/customWidgets/Edittext.dart';
// import 'package:webengage_flutter/webengage_flutter.dart';

// class LoginWidget extends StatefulWidget {
//   const LoginWidget({Key? key}) : super(key: key);

//   @override
//   State<LoginWidget> createState() => _LoginWidgetState();
// }

// class _LoginWidgetState extends State<LoginWidget> {
//   var _cuidValue = "";
//   var _isLogin = false;

//   void _onValueChange(value) {
//     _cuidValue = value;
//   }

//   void _login() {
//     if (_cuidValue.isNotEmpty) {
//       _isLogin = true;
//       WebEngagePlugin.userLogin(_cuidValue);
//       Utils.setIsLogin(_isLogin);
//       setState(() {
//         _isLogin = true;
//       });
//     }
//   }

//   void _logout() {
//     setState(() {
//       _isLogin = false;
//     });
//     WebEngagePlugin.userLogout();
//     Utils.setIsLogin(false);
//   }

//   @override
//   void initState() {
//     super.initState();
//     _init();
//   }

//   Future<void> _init() async {
//     var isLogin = await Utils.isLogin();
//     setState(() {
//       _isLogin = isLogin;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: _isLogin
//           ? CustomWidgets.button("Logout", _logout)
//           : Column(
//               children: [
//                 Edittext(
//                   title: "Enter cuid to login",
//                   onChange: _onValueChange,
//                 ),
//                 CustomWidgets.button("Login", _login)
//               ],
//             ),
//     );
//   }
// }
