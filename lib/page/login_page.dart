import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_example/common/constant.dart';

class LoginPage extends StatelessWidget {
  final String? location;

  const LoginPage({Key? key, required this.location}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('login'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              child: const Text('login'),
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
