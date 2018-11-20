//
//  UserNotificationViewController.swift
//  tu
//
//  Created by Rorschach on 2017/3/29.
//  Copyright © 2017年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import Material
import SwifterSwift
import AVOSCloud
import SVProgressHUD
class UserNotificationViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    
    var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        
        prepareTableview()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        self.tabBarController?.tabBar.isHidden = false
        self.navigationBar?.setBackgroundImage(UIImage(named: "navigationBK"), for: .default)
        self.navigationBar?.tintColor = Color.white

    }
    
    override func viewWillDisappear(_ animated: Bool) {
   
        super.viewWillDisappear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    func prepareTableview(){
        tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.register(UserNotificationCell.self, forCellReuseIdentifier: "UserNotifyCell")
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.view.layout(tableView).edges()
        self.tableView.reloadData()
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [1,2][section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserNotifyCell", for: indexPath) as! UserNotificationCell
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.title.text = "我的消息"
                cell.leftIcon.image = UIImage(named: "mls_notification1")
                return cell
            default:
                return UITableViewCell()
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell.title.text = "最近成交排行榜"
                cell.leftIcon.image = UIImage(named: "mls_notification2")
                return cell
            case 1:
                cell.title.text = "身价排行榜"
                cell.leftIcon.image = UIImage(named: "mls_notification3")
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
            if indexPath.row == 0{
                if AVUser.current() == nil{
                    SVProgressHUD.showError(withStatus: "请先登录~~")
                    SVProgressHUD.dismiss(withDelay: 1)
                }else{
                    let vc = UserMessageNotificationsViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        case 1:
            switch indexPath.row {
            case 0:
                let vc = SoldWorkRankViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = UserCoinRankViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return [0,10][section]
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return [0,0][section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    
}
