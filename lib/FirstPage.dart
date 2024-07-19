import 'package:flutter/material.dart'; // 导入 Flutter UI 工具包
import 'package:shared_preferences/shared_preferences.dart'; // 导入共享首选项包
import 'Widget1.dart'; // 导入 Widget1 组件
import 'Widget2.dart'; // 导入 Widget2 组件
import 'Widget3.dart'; // 导入 Widget3 组件

class FirstPage extends StatelessWidget { // 声明 FirstPage 组件，继承 StatelessWidget
  @override
  Widget build(BuildContext context) { // 构建 FirstPage 组件
    return Scaffold(
      appBar: AppBar(title: Text('First Page')), // 顶部应用栏，标题为 'First Page'
      body: LayoutBuilder(
        builder: (context, constraints) { // 根据屏幕宽度构建不同的布局
          return constraints.maxWidth >= 600 ? DesktopFirstPage() : MobileFirstPage(); // 根据宽度选择布局
        },
      ),
    );
  }
}

class DesktopFirstPage extends StatefulWidget { // 声明 DesktopFirstPage 组件，继承 StatefulWidget
  @override
  State<DesktopFirstPage> createState() => _DesktopFirstPageState(); // 创建状态对象
}

class _DesktopFirstPageState extends State<DesktopFirstPage> { // DesktopFirstPage 的状态类
  int _selectedIndex = 0; // 当前选中的导航项索引

  void _onDestinationSelected(int index) { // 处理导航项选择事件
    setState(() {
      _selectedIndex = index; // 更新选中的索引
    });
  }

  @override
  Widget build(BuildContext context) { // 构建 DesktopFirstPage 组件
    return Row(
      children: <Widget>[
        NavigationRail(
          selectedIndex: _selectedIndex, // 当前选中的导航项索引
          labelType: NavigationRailLabelType.all, // 显示所有标签
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.home), // 导航项图标
              label: Text('Home'), // 导航项标签
            ),
            NavigationRailDestination(
              icon: Icon(Icons.settings), // 导航项图标
              label: Text('Settings'), // 导航项标签
            ),
          ],
          onDestinationSelected: _onDestinationSelected, // 导航项选择事件处理
        ),
        VerticalDivider(thickness: 1, width: 1), // 垂直分隔线
        Expanded(
          child: IndexedStack(
            index: _selectedIndex, // 当前显示的子组件索引
            children: <Widget>[
              Widget1(), // 显示 Widget1 组件
              FutureBuilder(
                future: _isLoggedIn(), // 通过 FutureBuilder 处理异步操作
                builder: (context, snapshot) { // 构建 Widget
                  if (snapshot.connectionState == ConnectionState.waiting) { // 如果数据正在加载
                    return Center(child: CircularProgressIndicator()); // 显示加载指示器
                  } else {
                    if (snapshot.data == true) { // 如果用户已登录
                      return Widget2(); // 显示 Widget2 组件
                    } else {
                      return Widget3(); // 否则显示 Widget3 组件
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<bool> _isLoggedIn() async { // 检查用户是否已登录
    final prefs = await SharedPreferences.getInstance(); // 获取共享首选项实例
    return prefs.getBool('loggedIn') ?? false; // 返回登录状态
  }
}

class MobileFirstPage extends StatefulWidget { // 声明 MobileFirstPage 组件，继承 StatefulWidget
  @override
  _MobileFirstPageState createState() => _MobileFirstPageState(); // 创建状态对象
}

class _MobileFirstPageState extends State<MobileFirstPage> { // MobileFirstPage 的状态类
  int _selectedIndex = 0; // 当前选中的导航项索引

  void _onItemTapped(int index) { // 处理导航项点击事件
    setState(() {
      _selectedIndex = index; // 更新选中的索引
    });
  }

  @override
  Widget build(BuildContext context) { // 构建 MobileFirstPage 组件
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex, // 当前显示的子组件索引
        children: <Widget>[
          Widget1(), // 显示 Widget1 组件
          FutureBuilder(
            future: _isLoggedIn(), // 通过 FutureBuilder 处理异步操作
            builder: (context, snapshot) { // 构建 Widget
              if (snapshot.connectionState == ConnectionState.waiting) { // 如果数据正在加载
                return Center(child: CircularProgressIndicator()); // 显示加载指示器
              } else {
                if (snapshot.data == true) { // 如果用户已登录
                  return Widget2(); // 显示 Widget2 组件
                } else {
                  return Widget3(); // 否则显示 Widget3 组件
                }
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex, // 当前选中的导航项索引
        onDestinationSelected: _onItemTapped, // 导航项选择事件处理
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home), // 导航项图标
            label: 'Home', // 导航项标签
          ),
          NavigationDestination(
            icon: Icon(Icons.settings), // 导航项图标
            label: 'Settings', // 导航项标签
          ),

        ],
      ),
    );
  }

  Future<bool> _isLoggedIn() async { // 检查用户是否已登录
    final prefs = await SharedPreferences.getInstance(); // 获取共享首选项实例
    return prefs.getBool('loggedIn') ?? false; // 返回登录状态
  }
}