# **flutter go_router**

go_router是Flutter官方开发的一个Flutter的声明式路由包。

go_router 包的目的是使用声明式路由来降低复杂性，无论您的目标平台是什么（移动、Web、桌面），处理来自 Android、iOS 和网络的深度和动态链接，以及其他一些导航相关的场景，同时希望提供易于使用的开发人员体验。

## 入门

直接运行命令：

```shell
 flutter pub add go_router
```

或者直接在` pubspec.yaml`中添加依赖

```yaml
dependencies:
  go_router: ^5.0.0
```

然后导入就可以了

```dart
import 'package:go_router/go_router.dart';
```

使用:

```dart
class App extends StatelessWidget {
  ...
  final _router = GoRouter(
    routes: [],
  );
  
 ...
  Widget build(BuildContext context) {
    return MaterialApp.router(
      ...
      routerConfig: router,		//add this
    );
  }
}
```

此时我们返回的就是`MaterialApp.router` ， 只需要添加一行`routerConfig`即可。

## 声明式路由

```dart
final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Page1Screen(),
      ),
      GoRoute(
        path: '/page2',
        builder: (context, state) => const Page2Screen(),
      ),
    ],
  );
```

go_router 以 GoRouter 构造函数的一部分创建路由管理：

这种情况下，定义了两个路由，每个路由 `path` 都会匹配用户导航的位置。只有单个路由会被匹配，具体来说，就是某个路由的 `path` 会匹配整个位置（所以路由的列出顺序无关紧要）。

**path 匹配时忽略大小写，即使参数会保留大小写 **

除了 `path` 之外，每个路由会代表性地带有一个 `builder` 函数，该函数负责构建用来占据应用整个屏幕的组件。页面间会使用默认转换动画，取决于添加到组件树顶部的应用类型。例如，使用 `MaterialApp` 会让 go_router 使用 `MaterialPage` 的转换。

GoRoute的构造函数：

```dart
 GoRoute({
    required this.path,          //路径
    this.name,                  
    this.builder,                //负责构建屏幕的组件
    this.pageBuilder,
    this.parentNavigatorKey,
    this.redirect,
    List<RouteBase> routes = const <RouteBase>[],
  })
```

### 路由状态

虽然上面的代码片段中没有使用“路由状态”，但`builder`被传递了一个`state`对象，它是包含一些有用信息的 `GoRouterState` 类的实例：

| property    | description                  | example 1                | example 2                |
| ----------- | ---------------------------- | ------------------------ | ------------------------ |
| location    | 完整路由的位置，包括查询参数 | `/login?from=/family/f2` | `/family/f2/person/p1`   |
| subloc      | 子路由的位置，不包含查询参数 | /login                   | /family/2                |
| name        | 路由名称                     | login                    | /family                  |
| path`       | 路由路径                     | login                    | /family/:fid             |
| fullpath    | 该子路由的完整路径           | /login                   | /family/:fid             |
| params      | 从位置中提取的参数           | {}                       | {'fid': 'f2'}            |
| queryParams | 位置末尾的可选参数           | {'from': '/family/f1'}   | {}                       |
| extra       | 与导航一起传递的对象         | null                     | null                     |
| error       | 与此子路由相关的错误         |                          |                          |
| pageKey     | 该子路由的唯一Key            | ValueKey('/login')       | ValueKey('/family/:fid') |

其中最常用的一般是`location`,`name`,`queryParams`.

经常用`location`,`name`来跳转,通过`queryParams`来获取传递的参数.

### PageBuilder

路由的页面构建器

与`builder`类似,在实例化`GoRoute`对象时,必须提供`builder`与`pageBuilder`其中之一,返回要跳转的页面.

哎 , 那这时候有人就要问了,如果我都提供了会怎么样?

答案是会使用`pageBuilder`,`builder`无效.

`PageBuilder`允许开发人员设置路由的跳转动画:

```dart
pageBuilder: (_, GoRouterState state) => CustomTransitionPage(
                  child: const ListPage(),
                  transitionsBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation,
                          Widget child) =>
                      FadeTransition(opacity: animation, child: child))
```

### redirect

此路由的可选重定向功能

如果你想为特定路由（或子路由）做出重定向决定，可以通过将重定向函数传递给 `GoRoute`的构造函数来实现。

```dart
redirect: loginRedirect
...
  
FutureOr<String?> loginRedirect(BuildContext context, GoRouterState state) {
  debugPrint('loginRedirect :${state.name}');

  final loggingIn = state.subloc == 'login';
  //如果没登录,并且当前不在登录页面,去登录 (并将本来想要跳转的页面传递到登录页)

  if (!Constant.login && !loggingIn) {
    return state.namedLocation(login, queryParams: {
      'location': state.location,
      'text': '未登录无法跳转到对应页面',
    });
    //return '/login?location=${state.location}';
  }
  return null;
}
```

我这里写了一个登录页面的重定向功能,因为我们经常有这样一个需求:有一个页面是需要登录之后才能访问的,如果没登录就跳转到登录页面.

最简单直观的实现方式就是在跳转之前,进行判断:

- 已登录:正常跳转到对应页面
- 未登录:跳转到登录页面

此时如果添加一个重定向功能,就不需要在跳转这个路由的时候进行是否已登录的判断,并且支持更多的条件判断.

我们就可以实现更复杂的逻辑了,在用户想跳转到这个路由的时候,可以根据不同的条件,跳转到不同的页面,也让代码去到了它该去的地方.

### 错误处理

默认情况下，go_router 带有 MaterialApp 和 CupertinoApp 的默认错误页面，以及一个默认错误页面，那如果这两个你都不喜欢,可以通过设置 GoRouter 的 `errorBuilder` 参数来替换默认的错误屏幕：

```
class App extends StatelessWidget {
  ...
  final _router = GoRouter(
    ...
    errorBuilder: (context, state) => ErrorScreen(state.error),
  );
}
```

同样的,`errorBuilder`也有一个对应的`errorPageBuilder`.

在出现以下情况时,会跳转到错误页面:

- location与route不匹配
- 为给定位置找到多个路线
- 任何builder函数抛出异常

## 导航

`go_router`提供了以下几种路由跳转方式:

### go方法

通过`location`跳转:

```dart
context.go(String location, {Object? extra})
```

`go`方法需要提供"完整路由的位置，包括查询参数",

例如

```dart
context.go('/detail?id=b');
```

比如通过深度链接传来的URI格式的路由,以及推送之类的跳转,都推荐用到`location`来进行跳转.

然而当`location`比较复杂的时候,使用`location`来进行跳转 , 这不仅容易出错，而且应用程序的实际 URI 格式可能会随着时间而改变。当然，重定向有助于保持旧的 URI 格式正常工作，但你真的希望在代码中随意放置各种版本的位置 URI 吗？

通过`name`跳转:

```dart
context.goNamed(
    String name, {
    Map<String, String> params = const <String, String>{},
    Map<String, dynamic> queryParams = const <String, dynamic>{},
    Object? extra,
  })
```

例如:

```dart
context.goNamed('detail',queryParams:{'id':'b'})
```

这种方式就比较符合我们的实际开发场景 , 我们不需要命名所有的路由,但是命名过的路由可以使用`goNamed`来直接进行导航.

另外,我们也可以通过`context.namedLocation('name')`来通过名字获取`location`.

#### 参数传递

`queryParams`参数是可选的,如果传递了这些参数，会在路由栈匹配的页面中的 `state.queryParams` 中,

```dart
GoRoute(
              path: 'detail',
              name: detail,
              builder: (_, GoRouterState state) {
                String? id = state.queryParams['id'];
                return DetailPage(
                  id: id,
                );
              },
)
```

因为查询参数是可选的，未传递参数时，它们的值为 `null` 。

##### 附加参数

除了传递路径参数和查询参数之外，也可以传递附加的对象作为导航的一部分。例如：

```dart
context.go('detail',extra:object)
```

这个对象可以通过`state.extra`来获取.

如果想要简单的传递一个对象,使用`extra`还是很方便的.

但是, `extra` 对象会在用户使用浏览器的回退导航时丢失。 

所以， `extra` 对象不建议用于 Flutter Web 应用。

### push方法

go_router还提供了参数完全相同,但方法名不同的跳转方法 `push`.

二者区别:

- go: 如果新路由不是旧路由的子路由,则移除当前路由栈(就像replace)
- push: 将新路由推送到当前栈顶

for example:
路由: A:[B,C], 从B跳转到C  
跳转前的路由栈: A-B   
跳转后:

- go: A-C ,
- push: A-B-C

所以,定义路由线路的时候,一定要确定好路由的层级;跳转路由的时候,想好是使用go还是push.

### 获取当前路由的信息 : RouteMatch

`RouteMatch`是`GoRoute`的一个实例,并且包含当前位置的信息。

```dart
RouteMatch({
    required this.route,
    required this.subloc,
    required this.fullpath,
    required this.encodedParams,
    required this.queryParams,
    required this.queryParametersAll,
    required this.extra,
    required this.error,
    this.pageKey,
  }) 
```



可以看到, `RouteMatc` 的种的属性与 `GoRouterState`大同小异,可以通过`RouteMatch`来获取当前路由信息,那如何获取`RouteMatch`呢?

```dart
GoRouter.of(context).routerDelegate.currentConfiguration
```

该方法返回一个`RouteMatchList`,是当前的路由栈 , 

如果此时调用

```dart
    debugPrint(
        GoRouter.of(context).routerDelegate.currentConfiguration.last.subloc)
```

将会打印出最后一个,也就`当前子路由的位置.

也可以通过`GoRouter.of(context).location`来获取当前路由的完整路径.

## 需要登录的页面,登录后直接跳转到目标页

我们经常有这么一个需求 , 在首页A页面,要跳到目标页B页面,但是B页面是登录后才可以进入的,未登录的情况下跳转到登录页.

所以我们的期望路由栈就是: 首页A --> 登录页 -->页面B

比方说 , 我们现在有一个app,帖子列表页不需要登录,帖子详情需要登录,未登录情况下,点击帖子跳转到登录页,已经登录的跳转到详情页.

你在帖子列表看到了一个美女,一点进去需要登录,等你登录完回到首页了, 列表还变了,这显然不符合你的需求,对吧.

你是希望登录之后,直接就进到帖子详情去看美女了.

![image](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/5fbd05f5d9224b5c9f7983fececeb849~tplv-k3u1fbpfcp-zoom-in-crop-mark:3024:0:0:0.awebp?)


那如果用`go_router`要怎么实现想要的效果呢?

因为B页面需要登录,所以对B页面设置一个重定向:

```dart
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
              
FutureOr<String?> loginRedirect(BuildContext context, GoRouterState state) {
  debugPrint('loginRedirect :${state.name}');

  final loggingIn = state.subloc == 'login';
  //如果没登录,并且当前不在登录页面,去登录 (并将本来想要跳转的页面传递到登录页)
  if (!Constant.login && !loggingIn) {
    return state.namedLocation(login, queryParams: {
      'location': state.location,
      'text': '未登录无法跳转到对应页面',
    });
    //return '/login?location=${state.location}';
  }
  return null;
}
```

在这个重定向方法中,如果未登录,会跳转到登录页面,并把本来要跳转的`location`传递到登录页,这样登录页在登录成功之后就可以用这个`location`进行跳转.

这个是我们登录页的路由设置,接收一个`location`参数:

```dart
GoRoute(
              path: 'login',
              name: login,
              builder: (context, state) => LoginPage(
                    location: state.queryParams['location'],
                    text: state.queryParams['text'],
                  )),
```

在登录成功的时候,判断是否有`location`,如果有则进行跳转.

```dart
                if (location != null) context.go('$location');
```

可以看到,我这里是使用的`go`方法跳转的, 前面提到过, 如果新路由不是旧路由的子路由,使用`go`跳转则会移除当前路由栈,也就是说

路由栈在登录之后就从 A--> 登录页 --> B 变成了 A --> B.

毕竟登录页是不需要在登录之后存在于路由栈中的.

## 路由监听

有些时候,我们需要知道当前路由,跳转前的路由,或者是监听这个路由栈的变化,这时候,我们就需要有一个路由的监听.

`GoRouter`的构造方法中,有一个`observers`的参数, 它接收的是`List<NavigatorObserver>?`

所以我们可以自己实现一个`NavigatorObserver`,并重写相关生命周期的方法:

```dart
import 'package:flutter/material.dart';

class MyNavObserver extends NavigatorObserver {
  void log(value) => debugPrint('MyNavObserver:$value');

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) => log(
      'didPush: ${route.toString()}, previousRoute= ${previousRoute?.toString()}');

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) => log(
      'didPop: ${route.toString()}, previousRoute= ${previousRoute?.toString()}');

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) => log(
      'didRemove: ${route.toString()}, previousRoute= ${previousRoute?.toString()}');

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) => log(
      'didReplace: new= ${newRoute?.toString()}, old= ${oldRoute?.toString()}');

  @override
  void didStartUserGesture(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) =>
      log('didStartUserGesture: ${route.toString()}, '
          'previousRoute= ${previousRoute?.toString()}');

  @override
  void didStopUserGesture() => log('didStopUserGesture');
}

```







