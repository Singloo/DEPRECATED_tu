//
//  UserCoinRankViewController.swift
//  tu
//
//  Created by Rorschach on 2017/4/4.
//  Copyright © 2017年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import AVOSCloud
import Material
import SDWebImage
import SwifterSwift
import MJRefresh
class UserCoinRankViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    var tableview:UITableView!
    var dataArr = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = true

        self.title = "涂币排行榜"
        prepareTableview()
        headRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationBar?.setColors(background: Color.grey.lighten4, text: Color.grey.darken3)
        self.tabBarController?.tabBar.isHidden = true
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    func prepareTableview(){
        tableview = UITableView(frame: .zero, style: .plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .singleLine
        tableview.tableFooterView = UIView(frame: .zero)
        tableview.register(RankCell.self, forCellReuseIdentifier: "UserCoinRank")
        tableview.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(UserCoinRankViewController.headRefresh))
        self.view.layout(tableview).edges()
        self.tableview.reloadData()
    }
    
    func headRefresh() {
        let query = AVQuery(className: "UserAccount")
        query.order(byDescending: "userCoin")
        query.limit = 10
        query.findObjectsInBackground { (result, error) in
            if error == nil{
                self.tableview.mj_header.endRefreshing()
                self.dataArr.removeAllObjects()
                self.dataArr.addObjects(from: result!)
                self.tableview.reloadData()
            }
        }
    }
    
    
    //tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCoinRank", for: indexPath) as! RankCell
        let object = self.dataArr[indexPath.row] as! AVObject
        let coin = object["userCoin"] as! Int
        let userName = object["userName"] as! String
        let file = object["userAvatar"] as! AVFile
        
        switch indexPath.row {
        case 0:
            cell.leftIcon.image = UIImage(named: "1Kaboom")
        case 1:
            cell.leftIcon.image = UIImage(named: "2Boom")
        case 2:
            cell.leftIcon.image = UIImage(named: "3Pow")
        default:
            cell.leftLabel.text = "No.\(indexPath.row + 1)"
            
        }
        cell.leftImage.sd_setImage(with: URL(string: file.url!))
        cell.title.text = userName
        cell.detail.text = "涂币:\(coin)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = StrangerUserInfoViewController()
        let object = self.dataArr[indexPath.row] as! AVObject
        let user = object["user"] as! AVObject
        vc.userAccount = object
        vc.userObject = user
    
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 80
        case 1:
            return 75
        case 2:
            return 70
        default:
            return 60
        }
    }
}
