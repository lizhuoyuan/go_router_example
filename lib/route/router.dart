import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_example/page/me_page.dart';

import '../common/constant.dart';
import '../page/detail_page.dart';
import '../page/error_page.dart';
import '../page/home_page.dart';
import '../page/list_page.dart';
import '../page/login_page.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
        path: '/',
        name: home,
        builder: (_, state) => const MyHomePage(title: 'title'),
        routes: [
          GoRoute(
              path: 'list',
              name: list,
              pageBuilder: (_, GoRouterState state) => CustomTransitionPage(
                  child: const ListPage(),
                  transitionsBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation,
                          Widget child) =>
                      FadeTransition(opacity: animation, child: child))),
          GoRoute(
              path: 'detail',
              name: detail,
              builder: (_, GoRouterState state) {
                String? id = state.queryParams['id'];
                return DetailPage(
                  id: id,
                );
              },
              redirect: loginRedirect),
          GoRoute(
              path: 'me',
              name: me,
              builder: (_, GoRouterState state) => const MePage(),
              redirect: loginRedirect),
          GoRoute(
              path: 'login',
              name: login,
              builder: (context, state) =>
                  LoginPage(location: state.queryParams['location'])),
        ]),
  ],
  errorBuilder: (context, GoRouterState state) {
    return const ErrorPage();
  },
  debugLogDiagnostics: true,
);

String? loginRedirect(GoRouterState state) {
  debugPrint('loginRedirect :${state.name}');

  final loggingIn = state.subloc == 'login';
  //如果没登录,并且当前不在登录页面,去登录 (并将本来想要跳转的页面传递到登录页)

  if (!Constant.login && !loggingIn) {
    return state.namedLocation(login, queryParams: {
      'location': state.location,
    });
    //return '/login?location=${state.location}';
  }
  return null;
}

const String login = 'login';
const String home = 'home';
const String list = 'list';
const String detail = 'detail';
const String me = 'me';
