# XMLKit

XMLKit 是一个可以用于 xml 数据 和 Codable 模型之间相互转化的工具

[![Swift](https://github.com/miejoy/xml-kit/actions/workflows/test.yml/badge.svg)](https://github.com/miejoy/xml-kit/actions/workflows/test.yml)
[![codecov](https://codecov.io/gh/miejoy/xml-kit/branch/main/graph/badge.svg)](https://codecov.io/gh/miejoy/xml-kit)
[![License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](LICENSE)
[![Swift](https://img.shields.io/badge/swift-5.2-brightgreen.svg)](https://swift.org)

## 依赖

- iOS 13.0+ / macOS 10.15+
- Xcode 12.0+
- Swift 5.2+

## 简介

为了方便表示 xml 中独有的特性，XMLKit 中包含如下定义：
- Attr: 属性包装器，用户包装 xml 独有的属性
- Brothers: 兄弟列表包装器，能将一个列表平铺到当前父节点，可查看 UserBrothers 定义
- Plaintext: 文本包装器，xml 中有些节点既有子节点或子属性又又当前节点的内容，就可以用这个包装器

这里提供一个 XMLDecoder 用于解码 xml，一个 XMLEncoder 用户编码 xml，另外在编码 xml 的时候，可以用 XMLHeader 表示头部信息。

## 安装

### [Swift Package Manager](https://github.com/apple/swift-package-manager)

在项目中的 Package.swift 文件添加如下依赖:

```swift
dependencies: [
    .package(url: "https://github.com/miejoy/xml-kit.git", from: "0.1.0"),
]
```

## 使用

### Codable 定义

```swift
import XMLKit

struct UserMix : Codable {
    
    @Attr var id : Int
    
    @Attr var alias : String?
    
    var name : String
    
    var age : Int?
}
```

### XMLDecoder 解码使用

```swift
let xmlStr = "..."
let user = try XMLDecoder().decode(UserMix.self, from: xmlStr.data(using: .utf8)!)
```

### XMLEncoder 编码使用

```swift
let header = XMLHeader(version: 1.0, encoding: "utf-8")
let xmlData = try XMLEncoder().encode(user, withRootKey: "user", header: header)
```

## 作者

Raymond.huang: raymond0huang@gmail.com

## License

XMLKit is available under the MIT license. See the LICENSE file for more info.

