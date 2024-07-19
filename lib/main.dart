import 'package:flutter/material.dart'; // 导入 Flutter UI 工具包
import 'routes.dart'; // 导入路由配置

void main() { // 应用程序入口
  runApp(const MaterialApp(
    initialRoute: '/', // 设置初始路由
    onGenerateRoute: Routes.generateRoute, // 生成路由
  ));
}
