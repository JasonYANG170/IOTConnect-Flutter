import 'package:flutter/material.dart'; // 导入 Flutter UI 工具包
import 'package:http/http.dart' as http; // 导入 HTTP 请求包
import 'dart:convert'; // 导入 JSON 编解码包
import 'package:shared_preferences/shared_preferences.dart'; // 导入共享首选项包

class Widget3 extends StatefulWidget { // 声明 Widget3 组件，继承 StatefulWidget
  @override
  _Widget3State createState() => _Widget3State(); // 创建状态对象
}

class _Widget3State extends State<Widget3> { // Widget3 的状态类
  bool _isLogin = true; // 是否为登录模式

  void _showLoginDialog() { // 显示登录对话框
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController _usernameController = TextEditingController(); // 用户名输入控制器
        final TextEditingController _passwordController = TextEditingController(); // 密码输入控制器

        return AlertDialog(
          title: Text(_isLogin ? '登录' : '注册'), // 对话框标题
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _usernameController, // 用户名输入框
                decoration: InputDecoration(labelText: '用户名'), // 输入框提示文字
              ),
              TextField(
                controller: _passwordController, // 密码输入框
                decoration: InputDecoration(labelText: '密码'), // 输入框提示文字
                obscureText: true, // 密码输入框显示为密码
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(_isLogin ? '登录' : '注册'), // 提交按钮文本
              onPressed: () async {
                Navigator.of(context).pop(); // 关闭对话框
                if (_isLogin) {
                  await _login(_usernameController.text, _passwordController.text); // 执行登录操作
                } else {
                  await _register(_usernameController.text, _passwordController.text); // 执行注册操作
                }
              },
            ),
            TextButton(
              child: Text('取消'), // 取消按钮文本
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
              },
            ),
            TextButton(
              child: Text(_isLogin ? '没有账户？注册' : '已有账户？登录'), // 切换模式按钮文本
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin; // 切换模式
                });
                Navigator.of(context).pop(); // 关闭对话框
                _showLoginDialog(); // 重新显示对话框以更新内容
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _login(String username, String password) async { // 登录操作
    final response = await http.post(
      Uri.parse(''), // 登录请求地址
      headers: {'Content-Type': 'application/json'}, // 请求头
      body: jsonEncode({
        'username': username, // 用户名
        'password': password, // 密码
      }),
    );

    final responseData = jsonDecode(response.body); // 解析响应数据
    if (responseData['success']) { // 如果登录成功
      final prefs = await SharedPreferences.getInstance(); // 获取共享首选项实例
      await prefs.setBool('loggedIn', true); // 保存登录状态
      await prefs.setInt('userId', responseData['userId']); // 保存用户ID
      _showSuccessDialog('登录成功'); // 显示成功对话框
    } else {
      _showErrorDialog('登录失败'); // 显示错误对话框
    }
  }

  Future<void> _register(String username, String password) async { // 注册操作
    final response = await http.post(
      Uri.parse(''), // 注册请求地址
      headers: {'Content-Type': 'application/json'}, // 请求头
      body: jsonEncode({
        'username': username, // 用户名
        'password': password, // 密码
      }),
    );

    final responseData = jsonDecode(response.body); // 解析响应数据
    if (responseData['success']) { // 如果注册成功
      _showSuccessDialog('注册成功，请登录'); // 显示成功对话框
      setState(() {
        _isLogin = true; // 切换到登录模式
      });
    } else {
      _showErrorDialog('注册失败'); // 显示错误对话框
    }
  }

  void _showErrorDialog(String message) { // 显示错误对话框
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('错误'), // 对话框标题
        content: Text(message), // 对话框内容
        actions: <Widget>[
          TextButton(
            child: Text('确定'), // 确认按钮
            onPressed: () {
              Navigator.of(ctx).pop(); // 关闭对话框
            },
          )
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) { // 显示成功对话框
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('成功'), // 对话框标题
        content: Text(message), // 对话框内容
        actions: <Widget>[
          TextButton(
            child: Text('确定'), // 确认按钮
            onPressed: () {
              Navigator.of(ctx).pop(); // 关闭对话框
              if (message == '登录成功') { // 如果消息为登录成功
                Navigator.pushReplacementNamed(context, '/'); // 导航到首页

              }
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) { // 构建 Widget3 组件
    return Scaffold(
      appBar: AppBar(
        title: Text('登录/注册'), // 顶部应用栏标题
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _showLoginDialog, // 按钮点击事件
          child: Text('登录/注册'), // 按钮文本
        ),
      ),
    );
  }
}
