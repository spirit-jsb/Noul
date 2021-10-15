# Noul

<p align="center">
  <a href="https://cocoapods.org/pods/Noul"><img src="https://img.shields.io/cocoapods/v/Noul.svg?style=flat"/></a>
  <a href="https://swift.org/package-manager/"><img src="https://img.shields.io/badge/SPM-compatible-orange?style=flat"></a> 
  <a href="https://cocoapods.org/pods/Noul"><img src="https://img.shields.io/cocoapods/l/Noul.svg?style=flat"/></a>
  <a href="https://cocoapods.org/pods/Noul"><img src="https://img.shields.io/cocoapods/p/Noul.svg?style=flat"/></a>
</p>

`Noul` 是一个用于获取 OGP ([Open Graph protocol](https://ogp.me/)) 信息的 `Swift` 实现，你可以通过下标的形式获取具体的数据。

## 示例代码
```swift
VMOpenGrapher(url: url)
  .parser()
  .sink { (completion) in
    switch completion {
      case .failure(let error):
        print(error)
      case .finished:
        break
    }
  } receiveValue: { (og) in
    print(og[.title])
    print(og[.url])
    print(og[.image])
    print(og[.description])
  }
  .store(in: &self.cancellables)
```

部分情况需要重新定义请求的 `User-Agent`

```swift
VMOpenGrapher(url: test_url)
  .customHeader(["User-Agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 14_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.3 Mobile/15E148 Safari/604.1"])
  .parser()
  .sink { (completion) in
    switch completion {
      case .failure(let error):
        print(error)
      case .finished:
        break
    }
  } receiveValue: { (og) in
    print(og[.title])
    print(og[.url])
    print(og[.image])
    print(og[.description])
  }
  .store(in: &self.cancellables)
```

还可以直接传入 `HTML` 字符串

```swift
VMOpenGrapher(htmlString: htmlString)
  .parser()
  .sink { (completion) in
    switch completion {
      case .failure(let error):
        print(error)
      case .finished:
        break
    }
  } receiveValue: { (og) in
    print(og[.title])
    print(og[.url])
    print(og[.image])
    print(og[.description])
  }
  .store(in: &self.cancellables)
```

## 限制条件
- iOS 13.0+
- Swift 5.0+    

## 安装

### **CocoaPods**
``` ruby
pod 'Noul', '~> 1.0.0'
```

### **Swift Package Manager**
```
https://github.com/spirit-jsb/Noul.git
```

## 作者
spirit-jsb, sibo_jian_29903549@163.com

## 许可文件
`Noul` 可在 `MIT` 许可下使用，更多详情请参阅许可文件。


