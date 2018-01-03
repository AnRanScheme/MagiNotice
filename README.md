# MagiNotice
一款Swift提示框架轻量级  类似于 ProgressHub

## 1.使用方法
它使用起来非常方便 ,他的文件只有一个,你只需将文件突入项目即可

![这是列子](https://github.com/AnRanScheme/MagiNotice/Untitled.gif)

```
switch titleArray[indexPath.row] {
        case "loading with image":
            var imagesArray = Array<UIImage>()
            for i in 1...7 {
                imagesArray.append(UIImage(named: "loading\(i)")!)
            }
            self.pleaseWaitWithImages(imagesArray, timeInterval: 20)
        case "notice success":
            self.noticeSuccess("Success!")
        case "notice error":
            self.noticeError("error!")
        case "notice info":
            self.noticeInfo("info")
        case "notice text":
             self.noticeText("只有文字没有图片的情况阿斯顿法国和加快了QWERTYUIop主线程VB你们,是董浩手机的")
        case "notice loading and completion":
            request()
        case "notice static bar":
            self.noticeStatusBar("OK!1111111-------------22222222---------3333333333======")
        case "notice top":
            self.noticeText("还没有实现以后会慢慢实现")
        case "notice clear":
            self.clearAllNotice()
        default:
            break
        }
```

上面就是最简单的使用方法

