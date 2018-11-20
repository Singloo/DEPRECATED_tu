//
//  MoreSettingViewController.swift
//  tu
//
//  Created by Rorschach on 2017/4/8.
//  Copyright © 2017年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import Material
import SnapKit
import SDWebImage
import AVOSCloud
import SVProgressHUD
import SwifterSwift

class MoreSettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var tableview:UITableView!
    let cellIdentifier = "userVCCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .default


        prepareTableview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBar?.setColors(background: UIColor.white, text: Color.grey.base)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    func prepareTableview() {
        tableview = UITableView(frame: .zero, style: .plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UserNotificationCell.self, forCellReuseIdentifier: cellIdentifier)
        tableview.separatorStyle = .singleLine
        tableview.tableFooterView = UIView(frame: .zero)
        self.view.layout(tableview).edges()
    }
    
    
    //delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [1,2,1,1][section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UserNotificationCell
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.title.text = "修改密码"
                return cell
            default:
                return UITableViewCell()
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell.title.text = "应用说明"
                return cell
            case 1:
                cell.title.text = "给个好评  (shizhendema?)"
                return cell
            default:
                return UITableViewCell()
            }
            
        case 2:
            cell.title.text = "清理缓存 \(fileSizeOfCache()) MB"
            return cell
        case 3:
            switch indexPath.row {
            case 0:
                cell.title.textColor = UIColor.white
                cell.title.text = "退出登录"
                cell.title.textAlignment = .center
                cell.rightArrow.isHidden = true
                cell.backgroundColor = Color.red.base
                return cell
            default:
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                if AVUser.current() == nil{
                    SVProgressHUD.show(nil, status: "别点了..你又没登录")
                    SVProgressHUD.dismiss(withDelay: 1)
                }else{
                    
                    AVUser.requestPasswordResetForEmail(inBackground: (AVUser.current()?.email!)!, block: { (success, error) in
                        if success{
                            SVProgressHUD.show(nil, status: "一封重置密码的邮件已经发到你邮箱啦!等你回来~")
                            SVProgressHUD.dismiss(withDelay: 2)
                            self.navigationController?.popViewController(animated: true)
                        }else{
                            let e1 = error as! NSError
                            SVProgressHUD.show(nil, status: "出错了!!!\(e1.code)")
                            SVProgressHUD.dismiss(withDelay: 1)
                        }
                    })
                }
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                let vc = AppDescriptionViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                UIApplication.shared.open(URL(string: "itms-apps://itunes.apple.com/us/app/涂了个鸭/id1239162142?l=zh&ls=1&mt=8")!, options: [:], completionHandler: nil)
                SVProgressHUD.show(nil, status: "蟹蟹")
            default:
                break
            }
        case 2:
            SVProgressHUD.show()
            self.clearCache()
            if fileSizeOfCache() == 0{
                SVProgressHUD.dismiss()
                self.tableview.reloadData()
            }
        case 3:
            switch indexPath.row {
            case 0:
                let alert = UIAlertController(title: "是否退出当前账号?", message: nil, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "是的", style: .default, handler: { (action) in
                    if AVUser.current() != nil{
                        AVUser.logOut()
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        
                    }
                }))
                alert.addAction(UIAlertAction(title: "点错了", style: .cancel, handler: { (action) in
                    
                }))
                self.present(alert, animated: true) { 
                    
                }

            default:
                break
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return [1,10,10,30][section]
    }

    
    // clear cache
    func fileSizeOfCache()-> Int {
        // 取出cache文件夹目录 缓存文件都在这个目录下
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        //缓存目录路径
        // 取出文件夹下所有文件数组
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        //快速枚举出所有文件名 计算文件大小
        var size = 0
        for file in fileArr! {
            // 把文件名拼接到路径中
            let path = (cachePath! as NSString).appending("/\(file)")
            // 取出文件属性
            let floder = try! FileManager.default.attributesOfItem(atPath: path)
            // 用元组取出文件大小属性
            for (abc, bcd) in floder {
                // 累加文件大小
                if abc == FileAttributeKey.size {
                    size += (bcd as AnyObject).integerValue
                }
            }
        }
        let mm = size / 1024 / 1024
        return mm
    }
    func clearCache() {
        // 取出cache文件夹目录 缓存文件都在这个目录下
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        // 取出文件夹下所有文件数组
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        // 遍历删除
        for file in fileArr! {

            let path = (cachePath! as NSString).appending("/\(file)")
            if FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                    
                } catch {
                    
                }
            }
            
        }
        
    }
}
