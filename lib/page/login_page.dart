import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_example/common/constant.dart';

class LoginPage extends StatelessWidget {
  final String? location;
  final String? text;

  const LoginPage({Key? key, required this.location, this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('登录页面'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              '$text',
              style: const TextStyle(fontSize: 30),
            ),
            const TextField(decoration: InputDecoration(hintText: '账号')),
            const TextField(decoration: InputDecoration(hintText: '密码')),
            ElevatedButton(
              child: const Text('login', style: TextStyle(fontSize: 30)),
              onPressed: () {
                debugPrint('login:$location');
                Constant.login = true;
                if (location != null) context.go('$location');
              },
            ),
          ],
        ),
      ),
    );
  }
}
