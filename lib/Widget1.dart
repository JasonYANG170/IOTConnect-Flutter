import 'package:flutter/material.dart'; // 导入 Flutter UI 工具包

// 声明 Widget1 组件，继承 StatelessWidget
class Widget1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) { // 构建 Widget1 组件
    return Center(
      child: ElevatedButton(
        onPressed: () { // 按钮点击事件
          Navigator.pushNamed(context, '/second', arguments: 'Hello from First Page!'); // 导航到第二页并传递参数
        },
        child: Text('Go to Second Page'), // 按钮文本
      ),
    );
  }
}
