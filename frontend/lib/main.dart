import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/login_page.dart';
import 'package:shopping_app/registration.dart';
import 'package:shopping_app/items_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;
  const MyApp({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute:
          token != null && !JwtDecoder.isExpired(token!) ? '/items' : '/',
      routes: {
        '/': (context) => LoginPage(),
        '/signup': (context) => const Registration(),
        '/items': (context) => ItemsPage(token: token ?? ''),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
