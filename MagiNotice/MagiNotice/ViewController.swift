//
//  ViewController.swift
//  MagiNotice
//
//  Created by 安然 on 2018/1/3.
//  Copyright © 2018年 MacBook. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate static let identifier = "CellID"
    
    lazy var titleArray: [String] = {
        let array = ["loading with image",
                     "notice success",
                     "notice error",
                     "notice info",
                     "notice progress",
                     "notice text",
                     "notice loading and completion",
                     "notice status bar",
                     "notice tip",
                     "notice clear"]
        return array
    }()
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func setupUI() {
        tableView.rowHeight = 44
        tableView.separatorColor = UIColor.red
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: ViewController.identifier)
        tableView.tableFooterView = UIView()
    }
    
    fileprivate func request() {
        let hud = self.pleaseWait()
        DispatchQueue.global().async {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                hud.hide()
                self.noticeSuccess("Success!", autoClear: true)
            })
        }
    }
    
    func progress() {
        var progress: Double = 0

        if #available(iOS 10.0, *) {
            let timer = Timer(timeInterval: 0.5, repeats: true, block: {[unowned self] timer in
                progress += 0.05
                self.noticeProgress("正在上传", progress: progress, autoClear: true, autoClearTime: 0)
                if progress >= 1 {
                    timer.invalidate()
                    self.noticeSuccess("上传成功")
                }
                
            })
            RunLoop.current.add(timer, forMode: .commonModes)
        }
    }

}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.identifier,
                                                 for: indexPath)
        cell.textLabel?.text = titleArray[indexPath.row]
        cell.textLabel?.textColor = UIColor.darkText
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        textField.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch titleArray[indexPath.row] {
        case "loading with image":
            var imagesArray = Array<UIImage>()
            for i in 1...7 {
                imagesArray.append(UIImage(named: "loading\(i)")!)
            }
            self.pleaseWaitWithImages(imagesArray, timeInterval: 1)
        case "notice success":
            self.noticeSuccess("Success!")
        case "notice error":
            self.noticeError("error!")
        case "notice info":
            self.noticeInfo("info")
        case "notice progress":
            progress()
        case "notice text":
             self.noticeText("只有文字没有图片的情况阿斯顿法还没有实现以后会慢慢实现还没有实现以后会慢慢实现还没有实现以后会慢慢实现国和加快了QWERTYUIop主线程VB你们,是董浩手机的")
        case "notice loading and completion":
            request()
        case "notice status bar":
            self.noticeStatusBar("OK!1111111-------------22222222---------3333333333======")
        case "notice tip":
            self.noticeInfoTip("只有文字没有图片的情况阿斯顿法还没有实现以后会慢慢实现还没有实现以后会慢慢实现还没有实现以")
        case "notice clear":
            self.clearAllNotice()
        default:
            break
        }
  
    }
    
}


