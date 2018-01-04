# MagiNotice
一款Swift提示框架轻量级  类似于 ProgressHub

## 1.使用方法

它使用起来非常方便 ,他的文件只有一个,你只需将文件突入项目即可

![这是列子](https://github.com/AnRanScheme/MagiNotice/raw/master/Untitled.gif)



### 提供
       
  一系列的简单接口它们是 ```UIResponder``` 的扩展
  
```
    @discardableResult
    func pleaseWaitWithImages(_ imageNames: Array<UIImage>, timeInterval: Int) -> UIWindow{
        return MagiNotice.wait(imageNames, timeInterval: timeInterval)
    }
    
    @discardableResult
    func noticeStatusBar(_ text: String, autoClear: Bool = true, autoClearTime: Int = 1) -> UIWindow{
        return MagiNotice.noticeOnStatusBar(text, autoClear: autoClear, autoClearTime: autoClearTime)
    }
    
    @discardableResult
    func noticeSuccessTip(_ text: String, autoClear: Bool = true, autoClearTime: Int = 2) -> UIWindow{
        return MagiNotice.showNoticeWithTip(NoticeType.success, text: text, autoClear: autoClear, autoClearTime: autoClearTime)
    }
    
    @discardableResult
    func noticeErrorTip(_ text: String, autoClear: Bool = true, autoClearTime: Int = 2) -> UIWindow{
        return MagiNotice.showNoticeWithTip(NoticeType.error, text: text, autoClear: autoClear, autoClearTime: autoClearTime)
    }
    
    @discardableResult
    func noticeInfoTip(_ text: String, autoClear: Bool = true, autoClearTime: Int = 2) -> UIWindow{
        return MagiNotice.showNoticeWithTip(NoticeType.info, text: text, autoClear: autoClear, autoClearTime: autoClearTime)
    }
```
   
   
### 你会看到
这里只是一部分

当然还有更多的接口可以调用 添加提示的方法并不是单例所以你要小心提示会重复的展示,当然只要你处理好是不会有这个问题的;我觉得这样会更灵活:

你可以这样使用 ```self.noticeInfoTip("展示的文字", autoClear: true, autoClearTime: 5)```
autoClear 是否自动移除
autoClearTime 展示的时间

当然内部的更多细节你可以研究一下,为什么不呢? 反正又不难!

你可以在例子中看到他的大部分使用方法

写着这篇的封装的时候参考了 John Lui 的思路与理念



