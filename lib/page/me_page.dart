import 'package:flutter/material.dart';

import '../common/constant.dart';

class MePage extends StatelessWidget {
  const MePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登录:${Constant.login}'),
      ),
    );
  }
}
