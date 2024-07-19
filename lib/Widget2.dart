import 'package:flutter/material.dart'; // 导入 Flutter UI 工具包
import 'package:shared_preferences/shared_preferences.dart'; // 导入共享首选项包
import 'package:http/http.dart' as http; // 导入 HTTP 请求包
import 'dart:convert'; // 导入 JSON 编解码包

class Widget2 extends StatefulWidget { // 声明 Widget2 组件，继承 StatefulWidget
  @override
  _Widget2State createState() => _Widget2State(); // 创建状态对象
}

class _Widget2State extends State<Widget2> { // Widget2 的状态类
  bool _autoUpdate = false; // 是否自动更新的设置
  int _userId = 0; // 用户ID
  Map<String, dynamic> _userInfo = {}; // 用户信息
  bool _isLoading = true; // 是否正在加载

  @override
  void initState() { // 初始化状态
    super.initState();
    _loadSettings(); // 加载设置
    _loadUserInfo(); // 加载用户信息
  }

  Future<void> _loadSettings() async { // 加载设置
    final prefs = await SharedPreferences.getInstance(); // 获取共享首选项实例
    setState(() {
      _autoUpdate = prefs.getBool('autoUpdate') ?? false; // 更新自动更新设置
    });
  }

  Future<void> _saveSettings() async { // 保存设置
    final prefs = await SharedPreferences.getInstance(); // 获取共享首选项实例
    prefs.setBool('autoUpdate', _autoUpdate); // 保存自动更新设置
  }

  Future<void> _loadUserInfo() async { // 加载用户信息
    final prefs = await SharedPreferences.getInstance(); // 获取共享首选项实例
    _userId = prefs.getInt('userId') ?? 0; // 获取用户ID

    if (_userId != 0) { // 如果用户ID不为0
      final response = await http.get(
        Uri.parse('$_userId'), // 发送请求获取用户信息
      );

      final responseData = jsonDecode(response.body); // 解析响应数据
      if (responseData['success']) { // 如果请求成功
        setState(() {
          _userInfo = responseData['user']; // 更新用户信息
          _isLoading = false; // 设置为加载完成
        });
      } else {
        _showErrorDialog('获取用户信息失败'); // 显示错误对话框
      }
    } else {
      setState(() {
        _isLoading = false; // 设置为加载完成
      });
    }
  }

  void _showErrorDialog(String message) { // 显示错误对话框
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'), // 对话框标题
        content: Text(message), // 对话框内容
        actions: <Widget>[
          TextButton(
            child: Text('OK'), // 确认按钮
            onPressed: () {
              Navigator.of(ctx).pop(); // 关闭对话框
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) { // 构建 Widget2 组件
    return _isLoading
        ? Center(child: CircularProgressIndicator()) // 如果正在加载，显示加载指示器
        : Padding(
      padding: const EdgeInsets.all(16.0), // 添加内边距
      child: ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: _userInfo['avatarUrl'] != null
                    ? NetworkImage(_userInfo['avatarUrl']) // 如果用户头像存在，显示网络图片
                    : null,
                radius: 30,
                child: _userInfo['avatarUrl'] == null
                    ? Icon(Icons.person, size: 30) // 如果用户头像不存在，显示默认图标
                    : null,
              ),
              title: Text('用户名: ${_userInfo['username'] ?? '未提供'}'), // 显示用户名
              subtitle: Text('积分: ${_userInfo['points'] ?? 0}'), // 显示积分
            ),
          ),
          SizedBox(height: 20), // 添加间距
          Card(
            child: ListTile(
              leading: Icon(Icons.update), // 图标
              title: Text('自动检查更新'), // 标题
              subtitle: Text('当前：v1.0.992，点击检查更新'), // 子标题
              trailing: Switch(
                value: _autoUpdate, // 开关的当前值
                onChanged: (value) { // 开关值变化事件处理
                  setState(() {
                    _autoUpdate = value; // 更新自动更新设置
                  });
                  _saveSettings(); // 保存设置
                },
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.phone_android), // 图标
              title: Text('Android 设置'), // 标题
              trailing: Icon(Icons.chevron_right), // 右侧箭头图标
              onTap: () {
                // 添加导航或功能
              },
            ),
          ),
          Card(
            child: ExpansionTile(
              leading: Icon(Icons.more_horiz), // 图标
              title: Text('更多'), // 标题
              children: <Widget>[
                ListTile(
                  title: Text('子选项 1'), // 子选项1
                  onTap: () {
                    // 添加功能
                  },
                ),
                ListTile(
                  title: Text('子选项 2'), // 子选项2
                  onTap: () {
                    // 添加功能
                  },
                ),
              ],
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.exit_to_app), // 图标
              title: Text('退出登录'), // 标题
              trailing: Icon(Icons.chevron_right), // 右侧箭头图标
              onTap: () async {
                final prefs = await SharedPreferences.getInstance(); // 获取共享首选项实例
                await prefs.remove('loggedIn'); // 移除登录状态
                await prefs.remove('userId'); // 移除用户ID
                Navigator.pushReplacementNamed(context, '/'); // 导航到首页
              },
            ),
          ),
        ],
      ),
    );
  }
}
