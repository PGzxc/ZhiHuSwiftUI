## ZhiHuSwiftUI—仿知乎SwiftUI版本

## 一 开发环境

* 操作系统：macOS sequoia: 15.3.2
* Xcode版本：16.2(16C5032a)
* swift版本：swift-driver: 1.115.1, swift 6.0.3
* 编译版本：18.0

## 二 项目创建、开发及运行

### 2.1 项目创建

```
使用Xcode创建默认项目，项目名称：ZhiHuSwiftUI，Interface界面：SwiftUI，Language(语言):swift
```

### 2.2 项目开发(基于Cursor)

#### 2.2.1 Cursor提示词

```
我已使用Xcode创建了一个IOS默认项目，开发语言使用Swift+SwiftUI，请帮我改造成仿知乎项目，要求：开发语言使用Swift+SwiftUI，界面信息完全仿照知乎，内容完整并填充数据，项目结构完整，并将内容放到ZhiHuSwiftUI文件夹下
```

#### 2.2.2 功能开发

```
发送提示词后，Cursor给出的代码及解析：这是项目的基础架构和主要组件。接下来，我可以继续帮您实现：

1-页面
首页(HomeView)
市场页面（MarketView）
发布页面（PublishView）
消息通知页面（NotificationView）
个人主页（ProfileView）

2-首页(HomeView)
帖子列表展示 
帖子详情页

3. 市场(MarketView) 
顶部分分段控制
热门话题/专栏模块
话题/专栏详情

4-发布页面（PublishView）
发布内容编辑
草稿箱
发布设置

5-消息通知页面（NotificationView）
消息分类展示
通知列表
通知详情


6-我的页面/个人主页（ProfileView）
个人信息展示
内容管理
账号设置
```

### 2.3 开发过程

```
见创建过程文件夹
```

### 2.4 项目运行

使用Xcode打开并运行到设备上，登陆页面输入以下用户信息

```
用户名：test
密码：test
```

### 2.5 项目预览

V1版本

| ![][v1-1] | ![][v1-2] | ![][v1-3] |
| :-------: | :-------: | :-------: |
| ![][v1-4] | ![][v1-5] |           |

V2版本

| ![][v2-1] | ![][v2-2]  | ![][v2-3]  | ![][v2-4]  |
| --------- | ---------- | ---------- | ---------- |
| ![][v2-5] | ![][v2-6]  | ![][v2-7]  | ![][v2-8]  |
| ![][v2-9] | ![][v2-10] | ![][v2-11] | ![][v2-12] |

## 三 声明

本项目基于Cursor开发，可能会用到开源项目，如有侵权，请告知！



[v1-1]:images/V1/zh-v1-1-home.png
[v1-2]:images/V1/zh-v1-2-market.png
[v1-3]:images/V1/zh-v1-3-pub.png
[v1-4]:images/V1/zh-v1-4-msg.png
[v1-5]:images/V1/zh-v1-5-me.png

[v2-1]:images/V2/zh-v2-1-login.png
[v2-2]:images/V2/zh-v2-2-register.png
[v2-3]:images/V2/zh-v2-3-home.png
[v2-4]:images/V2/zh-v2-4-home-detail.png
[v2-5]:images/V2/zh-v2-5-market.png
[v2-6]:images/V2/zh-v2-6-market-detail.png
[v2-7]:images/V2/zh-v2-7-pub.png
[v2-8]:images/V2/zh-v2-8-msg.png
[v2-9]:images/V2/zh-v2-9-msg-detail.png
[v2-10]:images/V2/zh-v2-10-me.png
[v2-11]:images/V2/zh-v2-11-me-edit.png
[v2-12]:images/V2/zh-v2-12-set.png