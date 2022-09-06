import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_example/route/router.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final List<String> idList = ['a', 'b', 'c'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('list page'),
      ),
      body: ListView.separated(
        itemBuilder: _itemBuilder,
        itemCount: idList.length,
        separatorBuilder: _separatorBuilder,
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        context.goNamed(detail,queryParams: {'id':idList[index]});
      },
      child: ListTile(
        title: Text('id:${idList[index]}'),
      ),
    );
  }

  Widget _separatorBuilder(BuildContext context, int index) {
    return const Divider();
  }
}
