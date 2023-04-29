import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:metamask/metamask.dart';

class Join extends StatefulWidget {
  const Join({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Join> createState() => _JoinPageState();
}

class _JoinPageState extends State<Join> {
  UserController userController = Get.put(UserController());
  var metamask = MetaMask();

  void _loginWithMetaMask() {
    bool isWindows = Theme.of(context).platform == TargetPlatform.windows;
     bool isMacOS = Theme.of(context).platform == TargetPlatform.macOS;
    if(isWindows || isMacOS){
        metamask.login().then((success) {
        setState(() {
          if (success) {
            debugPrint('MetaMask address: ${metamask.address}');
            debugPrint('MetaMask signature: ${metamask.signature}');

            userController.address.value = metamask.address.toString();
            userController.signature.value = metamask.signature.toString();
          } else {
            debugPrint('MetaMask login failed');
          }
        });
      });
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (metamask.address != null) Text('address: ${userController.address.value}'),
            if (metamask.signature != null) Text('signed: ${userController.signature.value}'),
            Text(
              metamask.address == null ? 'You are not logged in' : 'You are logged in',
            ),
            Text('Metamask support ${metamask.isSupported}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loginWithMetaMask,
        tooltip: 'Login',
        child: const Icon(Icons.login),
      ),
    );
  }
}