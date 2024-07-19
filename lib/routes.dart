import 'package:flutter/material.dart'; // 导入 Flutter UI 工具包
import 'FirstPage.dart'; // 导入 FirstPage 组件
import 'SecondPage.dart'; // 导入 SecondPage 组件
import 'Widget3.dart'; // 导入 Widget3 组件

class Routes { // 路由配置类
  static Route<dynamic> generateRoute(RouteSettings settings) { // 生成路由
    switch (settings.name) { // 根据路由名称选择对应的页面
      case '/':
        return MaterialPageRoute(builder: (_) => FirstPage()); // 返回 FirstPage 页面
      case '/second':
        final args = settings.arguments as String; // 获取路由参数
        return MaterialPageRoute(builder: (_) => SecondPage(data: args)); // 返回 SecondPage 页面
      case '/login':
        return MaterialPageRoute(builder: (_) => Widget3()); // 返回 Widget3 页面
      default:
        return MaterialPageRoute(builder: (_) => FirstPage()); // 默认返回 FirstPage 页面
    }
  }
}
