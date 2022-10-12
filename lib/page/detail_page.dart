import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DetailPage extends StatelessWidget {
  final String? id;

  const DetailPage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint(GoRouter.of(context).location);
    debugPrint(
        GoRouter.of(context).routerDelegate.currentConfiguration.last.subloc);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Page'),
      ),
      body: Center(
        child: Text('id:$id'),
      ),
    );
  }
}
