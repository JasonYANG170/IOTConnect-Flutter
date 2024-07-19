import 'package:flutter/material.dart'; // 导入 Flutter UI 工具包

// 声明 SecondPage 组件，继承 StatelessWidget
class SecondPage extends StatelessWidget {
  final String data; // 接收的参数

  // 构造函数，要求传递 data 参数
  SecondPage({required this.data});

  @override
  Widget build(BuildContext context) { // 构建 SecondPage 组件
    return Scaffold(
      appBar: AppBar(title: Text('Second Page')), // 顶部应用栏，标题为 'Second Page'
      body: Center(
        child: Text(data), // 显示传递过来的参数
      ),
    );
  }
}
