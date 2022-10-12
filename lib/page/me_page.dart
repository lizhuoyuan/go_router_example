import 'package:flutter/material.dart';

import '../common/constant.dart';

class MePage extends StatelessWidget {
  const MePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的页面'),
      ),
      body: Center(
        child: Text('是否已经登录:${Constant.login}'),
      ),
    );
  }
}
