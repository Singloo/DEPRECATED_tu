//
//  UserMessageNotificationsViewController.swift
//  tu
//
//  Created by Rorschach on 2017/4/5.
//  Copyright © 2017年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import Material
import AVOSCloud
import MJRefresh


class UserMessageNotificationsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var tableview:UITableView!
    
    
    var dataArr = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.extendedLayoutIncludesOpaqueBars = true
        self.title = "你的消息"
        prepareTableview()
        headRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationBar?.setColors(background: Color.grey.lighten4, text: Color.grey.darken3)
        self.tabBarController?.tabBar.isHidden = true
        UIApplication.shared.statusBarStyle = .default
    }

    func prepareTableview(){
        tableview = UITableView(frame: .zero, style: .plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .singleLine
        tableview.tableFooterView = UIView(frame: .zero)
        tableview.register(MessageCell.self, forCellReuseIdentifier: "UserMessageCell")
        tableview.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(UserMessageNotificationsViewController.headRefresh))
        tableview.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(UserMessageNotificationsViewController.footerRefresh))
        self.view.layout(tableview).edges()
        self.tableview.reloadData()
    }

    func headRefresh() {
        let query = AVQuery(className: "NotifyOwner")
        query.whereKey("owner", equalTo: AVUser.current())
        query.order(byDescending: "createdAt")
        query.limit = 10
        query.findObjectsInBackground { (result, error) in
            if error == nil{
                if result?.count == 0{
                    let label = UILabel()
                    label.text = "没有你的消息哦.."
                    label.textColor = Color.grey.base
                    label.textAlignment = .center
                    label.font = RobotoFont.light(with: 17)
                    self.view.layout(label).edges()
                    self.view.bringSubview(toFront: label)
                }else{
                    self.tableview.mj_header.endRefreshing()
                    self.dataArr.removeAllObjects()
                    self.dataArr.addObjects(from: result!)
                    self.tableview.reloadData()
                }
            }
        }
    }
    
    func footerRefresh(){
        let query = AVQuery(className: "NotifyOwner")
        query.whereKey("owner", equalTo: AVUser.current())
        query.order(byDescending: "createdAt")
        query.limit = 10
        query.skip = self.dataArr.count
        query.findObjectsInBackground { (result, error) in
            if error == nil{
                self.tableview.mj_footer.endRefreshing()
                self.dataArr.addObjects(from: result!)
                self.tableview.reloadData()
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserMessageCell", for: indexPath) as! MessageCell
        let object = self.dataArr[indexPath.row] as! AVObject
        
        let buyerName = object["buyerName"] as! String
        let price = object["price"] as! Int
        
        cell.title.text = "你的作品卖掉啦! 赚了: \(price) 涂币"
        cell.detail.text = "买家是:" + buyerName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    


}
