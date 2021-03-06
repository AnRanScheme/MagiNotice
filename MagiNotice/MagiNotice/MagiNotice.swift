//
//  MagiNotice.swift
//  MagiNotice
//
//  Created by 安然 on 2018/1/3.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import Foundation
import UIKit

private let ma_topBar: Int = 1001

enum NoticeType{
    case success
    case error
    case info
}

extension UIResponder {
    
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

    @discardableResult
    func noticeSuccess(_ text: String, autoClear: Bool = false, autoClearTime: Int = 3) -> UIWindow{
        return MagiNotice.showNoticeWithText(NoticeType.success, text: text, autoClear: autoClear, autoClearTime: autoClearTime)
    }
    
    @discardableResult
    func noticeError(_ text: String, autoClear: Bool = false, autoClearTime: Int = 3) -> UIWindow{
        return MagiNotice.showNoticeWithText(NoticeType.error, text: text, autoClear: autoClear, autoClearTime: autoClearTime)
    }
    
    @discardableResult
    func noticeInfo(_ text: String, autoClear: Bool = false, autoClearTime: Int = 3) -> UIWindow{
        return MagiNotice.showNoticeWithText(NoticeType.info, text: text, autoClear: autoClear, autoClearTime: autoClearTime)
    }
    
    @discardableResult
    func noticeProgress(_ text: String, progress: Double, autoClear: Bool = false, autoClearTime: Int = 3) -> UIWindow{
        return MagiNotice.showNoticeWithProgress(text,
                                                 progress: progress,
                                                 autoClear: autoClear,
                                                 autoClearTime: autoClearTime)
    }
    
    @discardableResult
    func pleaseWait() -> UIWindow{
        return MagiNotice.wait()
    }
    
    @discardableResult
    func noticeText(_ text: String) -> UIWindow{
        return MagiNotice.showText(text)
    }
    
    func clearAllNotice() {
        MagiNotice.clear()
    }
    
}


class MagiNotice: NSObject {
    
    static var windows = Array<UIWindow!>()
    static let rv = UIApplication.shared.keyWindow?.subviews.first as UIView!
    static var timer: DispatchSource!
    static var timerTimes = 0
    /// 全局唯一的loading 表达
    fileprivate static var progressWindow: UIWindow?
    fileprivate static var progressView: MagiProgressView?
    /* just for iOS 8
     */
    static var degree: Double {
        get {
            return [0, 0, 180, 270, 90][UIApplication.shared.statusBarOrientation.hashValue] as Double
        }
    }
    
    static func clear() {
        self.cancelPreviousPerformRequests(withTarget: self)
        if let _ = timer {
            timer.cancel()
            timer = nil
            timerTimes = 0
        }
        progressView = nil
        progressWindow = nil
        windows.removeAll(keepingCapacity: false)
    }
    
    @discardableResult
    static func noticeOnStatusBar(_ text: String, autoClear: Bool, autoClearTime: Int) -> UIWindow{
        let frame = UIApplication.shared.statusBarFrame
        let window = UIWindow()
        window.backgroundColor = UIColor.clear
        let view = UIView()
        view.backgroundColor = UIColor(red: 0x6a/0x100, green: 0xb4/0x100, blue: 0x9f/0x100, alpha: 1)
        
        let label = UILabel(frame: frame.height > 20 ? CGRect(x: frame.origin.x, y: frame.origin.y + frame.height - 17, width: frame.width, height: 20) : frame)
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.white
        label.text = text
        view.addSubview(label)
        
        window.frame = frame
        view.frame = frame
        
        if let version = Double(UIDevice.current.systemVersion),
            version < 9.0 {
            // change center
            var array = [UIScreen.main.bounds.width, UIScreen.main.bounds.height]
            array = array.sorted(by: <)
            let screenWidth = array[0]
            let screenHeight = array[1]
            let x = [0, screenWidth/2, screenWidth/2, 10, screenWidth-10][UIApplication.shared.statusBarOrientation.hashValue] as CGFloat
            let y = [0, 10, screenHeight-10, screenHeight/2, screenHeight/2][UIApplication.shared.statusBarOrientation.hashValue] as CGFloat
            window.center = CGPoint(x: x, y: y)
            
            // change direction
            window.transform = CGAffineTransform(rotationAngle: CGFloat(degree * Double.pi / 180))
        }
        
        window.windowLevel = UIWindowLevelStatusBar
        window.isHidden = false
        window.addSubview(view)
        windows.append(window)
        
        var origPoint = view.frame.origin
        origPoint.y = -(view.frame.size.height)
        let destPoint = view.frame.origin
        view.tag = ma_topBar
        
        view.frame = CGRect(origin: origPoint, size: view.frame.size)
        UIView.animate(withDuration: 0.3, animations: {
            view.frame = CGRect(origin: destPoint, size: view.frame.size)
        }, completion: { b in
            if autoClear {
                self.perform(.hideNotice, with: window, afterDelay: TimeInterval(autoClearTime))
            }
        })
        return window
    }
    
    @discardableResult
    static func wait(_ imageNames: Array<UIImage> = Array<UIImage>(), timeInterval: Int = 0) -> UIWindow {
        let frame = CGRect(x: 0, y: 0, width: 78, height: 78)
        let window = UIWindow()
        window.backgroundColor = UIColor.clear
        let mainView = UIView()
        mainView.layer.cornerRadius = 12
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.8)
        
        if imageNames.count > 0 {
            if imageNames.count > timerTimes {
                let iv = UIImageView(frame: frame)
                iv.image = imageNames.first!
                iv.contentMode = UIViewContentMode.scaleAspectFit
                mainView.addSubview(iv)
                timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: UInt(0)), queue: DispatchQueue.main) as! DispatchSource
                timer.scheduleRepeating(deadline: DispatchTime.now(),
                                        interval: DispatchTimeInterval.milliseconds(timeInterval))
                 /*
                 Swift4 的最新方法
                 timer.schedule(deadline: DispatchTime.now(),
                 repeating: DispatchTimeInterval.milliseconds(timeInterval))
                 */
                timer.setEventHandler(handler: { () -> Void in
                    let name = imageNames[timerTimes % imageNames.count]
                    iv.image = name
                    timerTimes += 1
                })
                timer.resume()
            }
        } else {
            let ai = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            ai.frame = CGRect(x: 21, y: 21, width: 36, height: 36)
            ai.startAnimating()
            mainView.addSubview(ai)
        }
        
        window.frame = frame
        mainView.frame = frame
        window.center = rv!.center
        
        if let version = Double(UIDevice.current.systemVersion),
            version < 9.0 {
            // change center
            window.center = getRealCenter()
            // change direction
            window.transform = CGAffineTransform(rotationAngle: CGFloat(degree * Double.pi / 180))
        }
        
        window.windowLevel = UIWindowLevelAlert
        window.isHidden = false
        window.addSubview(mainView)
        windows.append(window)
        
        mainView.alpha = 0.0
        UIView.animate(withDuration: 0.2, animations: {
            mainView.alpha = 1
        })
        return window
    }
    
    @discardableResult
    static func showText(_ text: String, autoClear: Bool=true, autoClearTime: Int=2) -> UIWindow {
        let window = UIWindow()
        window.backgroundColor = UIColor.clear
        let mainView = UIView()
        mainView.layer.cornerRadius = 12
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.8)
        
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.textColor = UIColor.white
        let size = label.sizeThatFits(CGSize(width: UIScreen.main.bounds.width-82, height: CGFloat.greatestFiniteMagnitude))
        label.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        mainView.addSubview(label)
        
        let superFrame = CGRect(x: 0, y: 0, width: label.frame.width + 50 , height: label.frame.height + 30)
        window.frame = superFrame
        mainView.frame = superFrame
        
        label.center = mainView.center
        window.center = rv!.center
        
        if let version = Double(UIDevice.current.systemVersion),
            version < 9.0 {
            // change center
            window.center = getRealCenter()
            // change direction
            window.transform = CGAffineTransform(rotationAngle: CGFloat(degree * Double.pi / 180))
        }
        
        window.windowLevel = UIWindowLevelAlert
        window.isHidden = false
        window.addSubview(mainView)
        windows.append(window)
        
        if autoClear {
            self.perform(.hideNotice, with: window, afterDelay: TimeInterval(autoClearTime))
        }
        return window
    }
    
    @discardableResult
    static func showNoticeWithText(_ type: NoticeType,text: String, autoClear: Bool, autoClearTime: Int) -> UIWindow {
        let frame = CGRect(x: 0, y: 0, width: 90, height: 90)
        let window = UIWindow()
        window.backgroundColor = UIColor.clear
        let mainView = UIView()
        mainView.layer.cornerRadius = 10
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.7)
        
        var image = UIImage()
        switch type {
        case .success:
            image = MagiNoticeSDK.imageOfCheckmark
        case .error:
            image = MagiNoticeSDK.imageOfCross
        case .info:
            image = MagiNoticeSDK.imageOfInfo
        }
        let checkmarkView = UIImageView(image: image)
        checkmarkView.frame = CGRect(x: 27, y: 15, width: 36, height: 36)
        mainView.addSubview(checkmarkView)
        
        let label = UILabel(frame: CGRect(x: 0, y: 60, width: 90, height: 16))
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.white
        label.text = text
        label.textAlignment = NSTextAlignment.center
        mainView.addSubview(label)
        
        window.frame = frame
        mainView.frame = frame
        window.center = rv!.center
        
        if let version = Double(UIDevice.current.systemVersion),
            version < 9.0 {
            // change center
            window.center = getRealCenter()
            // change direction
            window.transform = CGAffineTransform(rotationAngle: CGFloat(degree * Double.pi / 180))
        }
        
        window.windowLevel = UIWindowLevelAlert
        window.center = rv!.center
        window.isHidden = false
        window.addSubview(mainView)
        windows.append(window)
        
        mainView.alpha = 0.0
        UIView.animate(withDuration: 0.2, animations: {
            mainView.alpha = 1
        })
        
        if autoClear {
            self.perform(.hideNotice, with: window, afterDelay: TimeInterval(autoClearTime))
        }
        return window
    }
    
    @discardableResult
    static func showNoticeWithProgress(_ text: String, progress: Double, autoClear: Bool, autoClearTime: Int) -> UIWindow {
        
        if progressWindow == nil {
            let frame = CGRect(x: 0, y: 0, width: 90, height: 90)
            progressWindow = UIWindow()
            progressWindow?.backgroundColor = UIColor.clear
            let mainView = UIView()
            mainView.layer.cornerRadius = 10
            mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.7)
            
            progressView = MagiProgressView()
            progressView?.frame = CGRect(x: 23, y: 11, width: 44, height: 44)
            progressView?.progress = progress
            if let progressView = progressView {
                mainView.addSubview(progressView)
            }

            let label = UILabel(frame: CGRect(x: 0, y: 60, width: 90, height: 16))
            label.font = UIFont.systemFont(ofSize: 13)
            label.textColor = UIColor.white
            label.text = text
            label.textAlignment = NSTextAlignment.center
            mainView.addSubview(label)
            progressWindow?.frame = frame
            mainView.frame = frame
            progressWindow?.center = rv!.center
            
            if let version = Double(UIDevice.current.systemVersion),
                version < 9.0 {
                // change center
                progressWindow?.center = getRealCenter()
                // change direction
                progressWindow?.transform = CGAffineTransform(rotationAngle: CGFloat(degree * Double.pi / 180))
            }
            
            progressWindow?.windowLevel = UIWindowLevelAlert
            progressWindow?.center = rv!.center
            progressWindow?.isHidden = false
            progressWindow?.addSubview(mainView)
            if let window = progressWindow {
                windows.append(window)
            }
 
            mainView.alpha = 0.0
            UIView.animate(withDuration: 0.2, animations: {
                mainView.alpha = 1
            })
            
            if autoClear && (progress >= 1.0) {
                self.perform(.hideNotice, with: progressWindow, afterDelay: TimeInterval(autoClearTime))
            }
            return progressWindow!
        }
        
        else {
            progressView?.progress = progress
            if autoClear && (progress >= 1.0) {
                self.perform(.hideNotice, with: progressWindow, afterDelay: TimeInterval(autoClearTime))
            }
            return progressWindow!
        }
    }
    
    @discardableResult
    static func showNoticeWithTip(_ type: NoticeType,text: String, autoClear: Bool, autoClearTime: Int) -> UIWindow {
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let height: CGFloat = statusBarHeight > 20 ? 74 : 50
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height)
        let window = UIWindow()
        window.backgroundColor = UIColor.clear
        let mainView = UIView()
        mainView.backgroundColor = UIColor(red: 0x6a/0x100, green: 0xb4/0x100, blue: 0x9f/0x100, alpha: 1)
        mainView.tag = ma_topBar
        var image = UIImage()
        switch type {
        case .success:
            image = MagiNoticeSDK.imageOfCheckmark
        case .error:
            image = MagiNoticeSDK.imageOfCross
        case .info:
            image = MagiNoticeSDK.imageOfInfo
        }
        let checkmarkView = UIImageView(image: image)
        let checkmarkView_y = statusBarHeight > 20 ?  statusBarHeight - 20 + 12 : 12
        let checkmarkViewFrame = CGRect(x: 12, y: checkmarkView_y, width: 26, height: 26)
        checkmarkView.frame = checkmarkViewFrame
        mainView.addSubview(checkmarkView)

        let label_y = statusBarHeight > 20 ? statusBarHeight - 20 + 17 : 17
        let labelFrame = CGRect(x: 48, y: label_y, width: UIScreen.main.bounds.width - 60, height: 16)
        let label = UILabel(frame: labelFrame)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white
        label.text = text
        label.textAlignment = NSTextAlignment.left
        mainView.addSubview(label)
        
        window.frame = frame
        mainView.frame = frame
        
        window.windowLevel = UIWindowLevelAlert
        window.isHidden = false
        window.addSubview(mainView)
        windows.append(window)
        
        var origPoint = mainView.frame.origin
        origPoint.y = -(mainView.frame.size.height)
        let destPoint = mainView.frame.origin
        
        mainView.frame = CGRect(origin: origPoint, size: mainView.frame.size)
        UIView.animate(withDuration: 0.3, animations: {
            mainView.frame = CGRect(origin: destPoint, size: mainView.frame.size)
        }, completion: { b in
            if autoClear {
                self.perform(.hideNotice, with: window, afterDelay: TimeInterval(autoClearTime))
            }
        })
        
        return window
    }
    
    // just for iOS 8
    static func getRealCenter() -> CGPoint {
        if UIApplication.shared.statusBarOrientation.hashValue >= 3 {
            return CGPoint(x: rv!.center.y, y: rv!.center.x)
        } else {
            return rv!.center
        }
    }
}

class MagiProgressView: UIView {

    // MARK: - 控件
    lazy var progressLayer: CAShapeLayer = {
        let progressLayer = CAShapeLayer()
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.white.cgColor
        progressLayer.lineWidth = 2
        progressLayer.strokeEnd = 0
        progressLayer.lineCap = kCALineCapRound
        return progressLayer
    }()
    
    lazy var progressLabel: UILabel = {
        let progressLabel = UILabel()
        progressLabel.font = UIFont.systemFont(ofSize: 10)
        progressLabel.textAlignment = .center
        progressLabel.textColor = UIColor.white
        return progressLabel
    }()
    
    // MARK: - 属性
    
    open var progress: Double = 0 {
        didSet {
            progressLayer.strokeEnd = CGFloat(progress)
            progressLabel.text = String(format: "%.f%%", progress * 100)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(progressLabel)
        layer.addSublayer(progressLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        progressLabel.frame = bounds
        progressLayer.frame = layer.bounds
        
        let path = UIBezierPath(arcCenter: CGPoint(x: progressLayer.frame.width * 0.5,
                                                   y: progressLayer.frame.height * 0.5),
                                radius: progressLayer.frame.height * 0.5,
                                startAngle: CGFloat(-Double.pi * 0.5),
                                endAngle: CGFloat(Double.pi * 3 / 2),
                                clockwise: true)
        progressLayer.path = path.cgPath
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 关闭隐式动画
    override func action(for layer: CALayer, forKey event: String) -> CAAction? {
        return nil
    }
    
}

class MagiNoticeSDK {
    struct Cache {
        static var imageOfCheckmark: UIImage?
        static var imageOfCross: UIImage?
        static var imageOfInfo: UIImage?
    }
    class func draw(_ type: NoticeType) {
        let checkmarkShapePath = UIBezierPath()
        
        // draw circle
        checkmarkShapePath.move(to: CGPoint(x: 36, y: 18))
        checkmarkShapePath.addArc(withCenter: CGPoint(x: 18, y: 18), radius: 17.5, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: true)
        checkmarkShapePath.close()
        
        switch type {
        case .success: // draw checkmark
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 18))
            checkmarkShapePath.addLine(to: CGPoint(x: 16, y: 24))
            checkmarkShapePath.addLine(to: CGPoint(x: 27, y: 13))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 18))
            checkmarkShapePath.close()
        case .error: // draw X
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 10))
            checkmarkShapePath.addLine(to: CGPoint(x: 26, y: 26))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 26))
            checkmarkShapePath.addLine(to: CGPoint(x: 26, y: 10))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 10))
            checkmarkShapePath.close()
        case .info:
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 6))
            checkmarkShapePath.addLine(to: CGPoint(x: 18, y: 22))
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 6))
            checkmarkShapePath.close()
            
            UIColor.white.setStroke()
            checkmarkShapePath.stroke()
            
            let checkmarkShapePath = UIBezierPath()
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 27))
            checkmarkShapePath.addArc(withCenter: CGPoint(x: 18, y: 27), radius: 1, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: true)
            checkmarkShapePath.close()
            
            UIColor.white.setFill()
            checkmarkShapePath.fill()
        }
        
        UIColor.white.setStroke()
        checkmarkShapePath.stroke()
    }
    class var imageOfCheckmark: UIImage {
        if (Cache.imageOfCheckmark != nil) {
            return Cache.imageOfCheckmark!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        
        MagiNoticeSDK.draw(NoticeType.success)
        
        Cache.imageOfCheckmark = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCheckmark!
    }
    class var imageOfCross: UIImage {
        if (Cache.imageOfCross != nil) {
            return Cache.imageOfCross!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        
        MagiNoticeSDK.draw(NoticeType.error)
        
        Cache.imageOfCross = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCross!
    }
    class var imageOfInfo: UIImage {
        if (Cache.imageOfInfo != nil) {
            return Cache.imageOfInfo!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        
        MagiNoticeSDK.draw(NoticeType.info)
        
        Cache.imageOfInfo = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfInfo!
    }
}

extension UIWindow{
    func hide(){
        MagiNotice.hideNotice(self)
    }
}

fileprivate extension Selector {
    static let hideNotice = #selector(MagiNotice.hideNotice(_:))
}

@objc extension MagiNotice {
    
    static func hideNotice(_ sender: AnyObject) {
        if let window = sender as? UIWindow {
            
            if let v = window.subviews.first {
                UIView.animate(withDuration: 0.2, animations: {
                    
                    if v.tag == ma_topBar {
                        v.frame = CGRect(x: 0, y: -v.frame.height, width: v.frame.width, height: v.frame.height)
                    }
                    v.alpha = 0
                }, completion: { b in
                    
                    if let index = windows.index(where: { (item) -> Bool in
                        return item == window
                    }) {
                        windows.remove(at: index)
                    }
                })
            }
            
        }
    }
    
}
