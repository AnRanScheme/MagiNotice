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
                     "notice text",
                     "notice loading and completion",
                     "notice status bar",
                     "notice top",
                     "notice clear"]
        return array
    }()

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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
        case "notice status bar":
            self.noticeStatusBar("OK!1111111-------------22222222---------3333333333======")
        case "notice top":
            self.noticeText("还没有实现以后会慢慢实现")
        case "notice clear":
            self.clearAllNotice()
        default:
            break
        }
  
    }
    
}


