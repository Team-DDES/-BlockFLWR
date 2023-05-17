import 'package:flutter/material.dart';
import 'package:flutter_web/manager/wallet_connection_manager.dart';
import 'package:flutter_web/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  WalletConnectionManager().start();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    Routes.defineRoutes();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'flower',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const MyHomePage(title: 'Metamask Login Page'),
      initialRoute: 'join',
      onGenerateRoute: Routes.router.generator,
    );
  }

}
