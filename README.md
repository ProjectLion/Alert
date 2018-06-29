HTAlert
===========
这是一个可以完全自定义的Alert,其中代码和思路借鉴(copy🤦‍♀️)了 “lixiang1994”大佬的LEEAlert,说白了就是LEEAlert的Swift版啦。这是xixiang1994的LEEAlert👉

[![](https://img.shields.io/badge/Xcode-10.0-blue.svg)](https://developer.apple.com/xcode/)&nbsp;
[![](https://img.shields.io/badge/language-Swift-f48041.svg?style=flat)](https://www.apple.com/)&nbsp;

用法
===========

### Alert
``` 
    // 完整的alert结构
    HTAlert.alert().config.XXXX.XXXX.show()
```

### Sheet
```
    // 完整的sheet结构
    HTAlert.sheet().config.XXXX.XXXX.show()
```

### 默认基础功能添加
```
    HTAlert.alert().config
    .title("这是标题")      /// 添加一个默认的标题label
    .content("这是内容")    /// 添加默认的内容label
    .addCustomView(config: { (view) in
    /// 自定义view的设置回调 具体使用请查看HTCustomView.Swift文件
    //                    view.view = 你自定义的view对象
    })
    .addTitle(config: { (label) in
    /// 自定义一个label的设置回调，也可以使用addContent()
    })
    .action("一个默认的action") {
    /// 点击action按钮的回调
    }
    .destructiveAction("这是销毁类型的action", block: {
    /// 点击回调
    })
    .cancelAction("这是取消类型的action", block: {
    /// 点击回调
    })
    .addAction(config: { (action) in
    /// 自定义action的设置回调，具体使用请查看HTAction.Swift文件
    action.title = "取消"
    action.color = .red
    action.highLightTitle = "高亮了"
    action.highLightColor = .cyan
    })
    .show() /// 显示出来
```

### 自定义基础功能的添加
```
    HTAlert.alert().config
    .addTitle(config: { (label) in
    /// 自定义一个label的设置回调，也可以使用addContent()
    label.text = "XXXX"
    label.textAlignment = .center
    })
    .addContent(config: { (label) in
    /// 设置同上，其实就是设置一些UILabel的属性
    })
    .addTextField(config: { (textField) in
    /// 输入框设置回调。这是设置UITextField的一些属性
    })
    .addCustomView(config: { (custom) in
    /// 自定义view设置回调

    /// 设置自定义视图对象，将自定义的view实例化传入
    custom.view = UIView()
    /// 自定义view的位置。 枚举值 .top、.bottom、.left、.right 默认居中
    custom.position = .left
    })
    .addAction(config: { (action) in
    /// 自定义action的设置回调，具体使用请查看HTAction.Swift文件
    action.title = "取消"
    action.color = .red
    action.highLightTitle = "高亮了"
    action.highLightColor = .cyan
    })
    .show() /// 显示出来
```
### 自定义动画时长

```
    HTAlert.alert().config
    .animationDuration(open: 0.5, close: 0.6)  /// 设置动画时长
    .show()
```

### 自定义动画样式

```
    HTAlert.alert().config
    .openAnimationStyle([.top, .fade, .magnify])    /// 开启动画 从上出来、淡入、放大效果(方向只可设置一种，other随你高兴)
    .closeAnimationStyle([.bottom, .fade, .shrink]) /// 关闭动画 从下面消失、淡出、缩小效果(方向只可设置一种，other随你高兴)
    .show() /// 显示出来
```
         
### 自定义动画方法设置
```
    HTAlert.alert().config
    .title("自定义动画设置")
    .openAnimationConfig(animation: { (animating, animated) in
    /// openAnimationConfig自定义动画的方法及参数
    /// 使用UIView的动画API
    UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction], animations: {
    animating() /// 调用动画中的闭包
    }, completion: { (finish) in
    animated() /// 调用动画结束的闭包
    })
    })
    .closeAnimationConfig(animation: { (animating, animated) in
    /// closeAnimationConfig自定义动画的方法及参数
    /// 使用UIView的动画API
    UIView.animateKeyframes(withDuration: 1, delay: 0, options: [UIView.KeyframeAnimationOptions.beginFromCurrentState], animations: {
    animating()  /// 调用动画中的闭包
    }, completion: { (finish) in
    animated()  /// 调用动画结束的闭包
    })
    })
    .show() /// 显示出来
```

系统要求
==============
该库最低支持 `iOS 8.0` 和 `Xcode 9.0`。

 致谢
 ==============
[感谢lixiang1994](http://www.jianshu.com/users/a6da0db100c8)
