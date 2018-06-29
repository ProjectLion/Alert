//
//  AlertTableVC.swift
//  HTAlertDemo
//
//  Created by Ht on 2018/6/28.
//  Copyright © 2018年 Ht. All rights reserved.
//

import UIKit

class AlertTableVC: UITableViewController {
    
    struct Model {
        var title: String
        var conten: String
    }
    
    let baseArr = [Model(title: "0、显示一个默认的alert弹框", conten: ""),
                   Model(title: "1、显示一个带输入框的alert弹框", conten: "可以添加多个输入框"),
                   Model(title: "2、显示一个不同控件顺序的 alert 弹框", conten: "设置的顺序决定了控件显示的顺序"),
                   Model(title: "3、显示一个带自定义视图的 alert 弹框", conten: "自定义视图的size发生改变时 会自动适应其改变."),
                   Model(title: "4、显示一个横竖屏不同宽度的 alert 弹框", conten: "可以对横竖屏的最大宽度进行设置"),
                   Model(title: "5、显示一个自定义标题和内容的 alert 弹框", conten: "除了标题和内容 其他控件均支持自定义."),
                   Model(title: "6、显示一个多种action的 alert 弹框", conten: "action分为三种类型 可添加多个 设置的顺序决定了显示的顺序."),
                   Model(title: "7、显示一个自定义action的 alert 弹框", conten: "action的自定义属性可查看\"HTAction\"类."),
                   Model(title: "8、显示一个可动态改变action的 alert 弹框", conten: "已经显示后 可再次对action进行调整"),
                   Model(title: "9、显示一个可动态改变标题和内容的 alert 弹框", conten: "已经显示后 可再次对其进行调整"),
                   Model(title: "10、显示一个模糊背景样式的 alert 弹框", conten: "传入UIBlurEffectStyle枚举类型 默认为Dark"),
                   Model(title: "11、显示多个加入队列和优先级的 alert 弹框", conten: "当多个同时需要显示时, 队列和优先级决定了如何去显示"),
                   Model(title: "12、显示一个自定义动画配置的 alert 弹框", conten: "可自定义打开与关闭的动画配置(UIView 动画)"),
                   Model(title: "13、显示一个自定义动画样式的 alert 弹框", conten: "动画样式可设置动画方向, 淡入淡出, 缩放等")]
    
    let demoArr = [Model(title: "0、显示一个蓝色自定义风格的 alert 弹框", conten: "弹框背景等颜色均可以自定义"),
                   Model(title: "1、显示一个分享登录的 alert 弹框", conten: "类似某些复杂内容的弹框 可以通过封装成自定义视图来显示"),
                   Model(title: "2、显示一个提示打开推送的 alert 弹框", conten: "类似某些复杂内容的弹框 可以通过封装成自定义视图来显示"),
                   Model(title: "3、显示一个提示签到成功的 alert 弹框", conten: "类似某些复杂内容的弹框 可以通过封装成自定义视图来显示"),
                   Model(title: "4、显示一个单选选择列表的 alert 弹框", conten: "类似某些复杂内容的弹框 可以通过封装成自定义视图来显示"),
                   Model(title: "5、显示一个省市区选择列表的 alert 弹框", conten: "自定义的Action 通过设置其间距范围和边框等属性实现"),
                   Model(title: "6、显示一个评分的 alert 弹框", conten: "自定义的Action 通过设置其间距范围和边框等属性实现"),
                   Model(title: "7、显示一个新手红包的 alert 弹框", conten: "包含自定义视图 自定义title 自定义Action")]
    
    var dataSource: Array<Array<Model>> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "HTAlert(控件的显示顺序与添加顺序有关)"
        
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .automatic
        }
        
        dataSource = [baseArr, demoArr]
        
        tableView.estimatedRowHeight = 0
        
        tableView.estimatedSectionHeaderHeight = 0
        
        tableView.estimatedSectionFooterHeight = 0
        
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        }

        let model = dataSource[indexPath.section][indexPath.row]
        
        cell?.textLabel?.text = model.title
        
        cell?.detailTextLabel?.text = model.conten
        
        cell?.textLabel?.textColor = .darkGray
        
        cell?.detailTextLabel?.textColor = .gray

        return cell!
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "基础使用" : "Demo"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            clickBase(index: indexPath.row)
        case 1:
            clickDemo(index: indexPath.row)
        default:
            break
        }
    }
    
}

extension AlertTableVC {
    
    /// base演示
    func clickBase(index: Int) {
        switch index {
        case 0:
            HTAlert.alert().config
                .title("这是标题")
                .content("这是内容")
                .cancelAction("取消") {
                    // 点击取消按钮的回调
            }
                .action("确定") {
                    // 点击确定按钮的回调
            }
            .show()
        case 1:
            var tf = UITextField()
            HTAlert.alert().config
                .title("这是标题")
                .content("这是内容")
                .addAction(config: { (action) in
                    action.title = "取消"
                    action.color = .red
                    action.highLightTitle = "高亮了"
                    action.highLightColor = .cyan
                })
                .addTextField(config: { (textField) in
                    textField.placeholder = "这里是输入框"
                    tf = textField
                })
                .addTextField(config: { (textField) in
                    textField.placeholder = "这里是第二个输入框"
                })
                .action("确定") {
                    // 点击确定按钮的回调
                    ht_print(message: tf.text)
                }
                .show()
        case 2:
            HTAlert.alert().config
                .addTextField(config: { (textField) in
                    textField.placeholder = "这里是输入框"
                })
                .content("这是内容")
                .addTextField(config: { (textField) in
                    textField.placeholder = "这里是第二个输入框"
                })
                .title("这是标题")
                .action("确定") {
                    // 点击确定按钮的回调
                }
                .addAction(config: { (action) in
                    action.title = "取消"
                    action.color = .red
                    action.highLightTitle = "高亮了"
                    action.highLightColor = .cyan
                })
                .show()
        case 3:
            HTAlert.alert().config
                .title("这是标题")
                .content("这是内容")
                .addCustomView(config: { (view) in
                    view.view = UIView(x: 0, y: 0, width: 200, height: 50, backGroundColor: .blue)
                })
                .action("确定") {
                    // 点击确定按钮的回调
                }
                .addAction(config: { (action) in
                    action.title = "取消"
                    action.color = .red
                    action.highLightTitle = "高亮了"
                    action.highLightColor = .cyan
                })
                .show()
        case 4:
            HTAlert.alert().config
                .configMaxWidth(block: { (type) -> CGFloat in
                    switch type {
                    case .horizontal:
                        return Scrren_W * 0.8
                    case .vertical:
                        return Scrren_H
                    }
                })
                .title("这是标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题")
                .content("这是内容:铁血书生郭沫若铁血书生郭沫若铁血书生郭沫若铁血书生郭沫若铁血书生郭沫若铁血书生郭沫若铁血书生郭沫若铁血书生郭沫若")
                .action("确定") {
                    // 点击确定按钮的回调
                }
                .addAction(config: { (action) in
                    action.title = "取消"
                    action.color = .red
                    action.highLightTitle = "高亮了"
                    action.highLightColor = .cyan
                })
                .show()
        case 5:
            HTAlert.alert().config
                .addTitle(config: { (label) in
                    label.text = "这是自定义的label实现的"
                    label.font = UIFont.boldSystemFont(ofSize: 20)
                    label.textColor = .purple
                })
                .addTitle(config: { (label) in
                    label.text = "这个也是自定义的"
                    label.font = UIFont.systemFont(ofSize: 13)
                    label.textColor = .brown
                })
                .action("确定") {
                    // 点击确定按钮的回调
                }
                .addAction(config: { (action) in
                    action.title = "取消"
                    action.color = .red
                    action.highLightTitle = "高亮了"
                    action.highLightColor = .cyan
                })
                .show()
        case 6:
            HTAlert.alert().config
                .title("可以添加多个action")
                .action("确定") {
                    // 点击确定按钮的回调
                }
                .cancelAction("取消", block: {
                    // 点击取消的回调
                })
                .addAction(config: { (action) in
                    action.title = "这是一个action"
                    action.color = .green
                    action.clickBlock = {
                        ht_print(message: "点击回调")
                    }
                    action.borderPosition = [.top, .bottom]
                })
                .show()
        case 7:
            HTAlert.alert().config
                .title("可以添加多个action")
                .addAction(config: { (action) in
                    action.title = "自定义"
                    action.image = UIImage(named: "smile")
                    action.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
                    action.height = 60
                })
                .addAction(config: { (action) in
                    action.title = "自定义action"
                    action.color = .green
                    action.clickBlock = {
                        ht_print(message: "点击回调")
                    }
                    action.borderPosition = [.top, .bottom]
                })
                .show()
        case 8:
            var tempAction = HTAction()
            HTAlert.alert().config
            .title("点击改变 第一个action会长高")
                .addAction { (action) in
                    action.title = "我是action"
                    tempAction = action
            }
                .addAction(config: { (action) in
                    action.title = "改变"
                    action.isClickClose = false
                    action.clickBlock = {
                        tempAction.height += 20
                        tempAction.title = "我长高了"
                        tempAction.color = .red
                        tempAction.update()
                    }
                })
                .cancelAction("取消", block: {
                    // 点击取消的回调
                })
            .show()
        case 9:
            var titleLabel = UILabel()
            var contenLabel = UILabel()
            
            HTAlert.alert().config
                .addTitle { (label) in
                    label.text = "动态改变标题和内容的alert"
                    titleLabel = label
            }
                .addContent { (label) in
                    label.text = "点击调整Action即可改变"
                    contenLabel = label
            }
                .addAction { (action) in
                    action.title = "调整"
                    action.isClickClose = false
                    action.clickBlock = {
                        titleLabel.text = "改变后的标题============================================================"
                        titleLabel.textColor = .cyan
                        titleLabel.textAlignment = .left
                        contenLabel.text = "改变后的内容"
                        contenLabel.textColor = .red
                        contenLabel.textAlignment = .right
                    }
            }
                .cancelAction("不调整了") {
                    // 点击不调整按钮的回调
            }
            .show()
        case 10:
            HTAlert.alert().config
                .title("这是一个毛玻璃背景样式的alert")
                .content("通过backgroundStyleBlur设置效果")
                .action("确定") {
                    // 点击确定按钮的回调
                }
                .cancelAction("取消", block: {
                    // 点击取消的回调
                })
                .backgroundStyleBlur(.light)
                .show()
        case 11:
            HTAlert.alert().config
                .title("第一个alert")
                .action("确定") {
                    // 点击确定按钮的回调
                }
                .cancelAction("取消", block: {
                    // 点击取消的回调
                })
                .queuePriority(1)
                .queue(true)
                .show()
            HTAlert.alert().config
                .title("第二个alert")
                .action("确定") {
                    // 点击确定按钮的回调
                }
                .cancelAction("取消", block: {
                    // 点击取消的回调
                })
                .queuePriority(2)
                .queue(true)
                .show()
            HTAlert.alert().config
                .title("第三个alert")
                .action("确定") {
                    // 点击确定按钮的回调
                }
                .cancelAction("取消", block: {
                    // 点击取消的回调
                })
                .queuePriority(3)
                .queue(true)
                .show()
        case 12:
            HTAlert.alert().config
                .title("自定义动画配置的 alert ")
                .content("支持 自定义打开动画和关闭动画 基于 UIView的动画API")
                .action("OK") {
                    
            }
                .openAnimationConfig { (animating, animated) in
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [UIView.AnimationOptions.allowUserInteraction], animations: {
                        animating()
                    }, completion: { (finish) in
                        animated()
                    })
            }
                .closeAnimationConfig { (animating, animated) in
                    UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseInOut], animations: {
                        animating()
                    }, completion: { (finish) in
                        animated()
                    })
            }
            .show()
        case 13:
            
            /*
             动画样式的方向只可以设置一个 其他样式枚举可随意增加.
             动画样式和动画配置可同时设置 这里不多做演示 欢迎自行探索
             */
            
            HTAlert.alert().config
            .title("自定义动画样式的alert")
            .content("动画样式可设置方向、淡出淡入、缩放eg")
                .action("OK") {
                    
            }
            .openAnimationStyle([.left, .magnify])
            .closeAnimationStyle([.right, .shrink])
            .show()
        default:
            break
        }
    }
    
    
    /// demo演示
    func clickDemo(index: Int) {
        switch index {
        case 0:
            HTAlert.alert().config
                .addTitle { (label) in
                    label.text = "确认删除？"
                    label.textColor = .white
            }
                .addContent { (label) in
                    label.text = "删除后将无法恢复，请考虑再三"
                    label.textColor = UIColor.white.withAlphaComponent(0.7)
            }
                .addAction { (action) in
                    action.type = .cancel
                    action.title = "取消"
                    action.color = .blue
                    action.backgroundColor = .white
                    action.clickBlock = {
                        
                    }
            }
                .addAction { (action) in
                    action.type = .destructive
                    action.title = "删除"
                    action.color = .blue
                    action.backgroundColor = .white
                    action.clickBlock = {
                        
                    }
            }
            .headerColor(.blue)
            .show()
        default:
            break
        }
    }
}
