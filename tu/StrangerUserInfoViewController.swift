//
//  StrangerUserInfoViewController.swift
//  tu
//
//  Created by Rorschach on 2017/4/24.
//  Copyright © 2017年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import Material
import AVOSCloud
import SDWebImage
import SnapKit
import SVProgressHUD
import MJRefresh
import SKPhotoBrowser

class StrangerUserInfoViewController: UIViewController {

    //传user point
    var headerview:UserView!
    var userAccount:AVObject!
    var userObject:AVObject!
    
    var dataArr = NSMutableArray()
    
    var tableView:UITableView!
    let cellIdentifier = "cellIdenfirer"
    override func viewDidLoad() {
        super.viewDidLoad()

        self.extendedLayoutIncludesOpaqueBars = true
        self.view.backgroundColor = Color.grey.lighten3
        prepareTableview()
        
        prepareData()
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func prepareData(){
        let query = AVQuery(className: "UserWorks")
        query.whereKey("user", equalTo: userObject)
        query.whereKey("saleable", equalTo: true)
        query.order(byAscending: "createdAt")
        query.limit = 10
        query.skip = 0
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground { (result, error) in
            if result!.count == 0{
             
                self.tableView.mj_header.endRefreshing()
                let label = UILabel()
                label.text = "这里空空如也..."
                label.textColor = Color.grey.base
                label.textAlignment = .center
                label.font = RobotoFont.light(with: 17)
                self.view.addSubview(label)
                label.snp.makeConstraints({ (make) in
                    make.centerX.equalTo(self.view)
                    make.centerY.equalTo(self.view)
                    make.width.equalTo(250)
                    make.height.equalTo(25)
                })
                self.view.bringSubview(toFront: label)

            }else{
                if error == nil{
                    self.tableView.mj_header.endRefreshing()
                    self.dataArr.removeAllObjects()
                    self.dataArr.addObjects(from: result!)
                    self.tableView.reloadData()
                }else{
                    self.tableView.mj_header.endRefreshing()
                    let e1 = error as! NSError
                    SVProgressHUD.showError(withStatus: "网络不太好...\(e1)")
                    SVProgressHUD.dismiss(withDelay: 1)
                }
            }
        }
    }
    
    func footerRefresh(){
        let query = AVQuery(className: "UserWorks")
        query.whereKey("user", equalTo: userObject)
        query.whereKey("saleable", equalTo: true)
        query.order(byAscending: "createdAt")
        query.limit = 10
        query.skip = self.dataArr.count
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground { (result, error) in
            if error == nil{
                self.tableView.mj_footer.endRefreshing()
                self.dataArr.addObjects(from: result!)
                self.tableView.reloadData()
            }
        }
    }
    
    func prepareTableview(){
        tableView = UITableView(frame: CGRect(x: 0, y: -64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT + 64), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(StrangerUserPageHeadCell.self, forCellReuseIdentifier: cellIdentifier)
        headerview = UserView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 200))
        if userAccount == nil{
            let query = AVQuery(className: "UserAccount")
            query.whereKey("user", equalTo: userObject)
            query.findObjectsInBackground { (result, error) in
                if error == nil{
                    let object = result?[0] as! AVObject
                    let file = object["userAvatar"] as! AVFile
                    self.headerview.userAvatar.sd_setImage(with: URL(string: file.url!))
                    self.headerview.bkImage.sd_setImage(with: URL(string: file.url!))
                    
                    let coin = object["userCoin"] as! Int
                    self.headerview.usercoin.text = "\(coin) 涂币"
                    
                    let name = object["userName"] as! String
                    self.headerview.username.text = name

                    
                }
            }
        }else{
            let userAvatar = self.userAccount["userAvatar"] as! AVFile
            headerview.bkImage.sd_setImage(with: URL(string: userAvatar.url!))
            headerview.userAvatar.sd_setImage(with: URL(string: userAvatar.url!))
            
            let coin = self.userAccount["userCoin"] as! Int
            headerview.usercoin.text = "\(coin) 涂币"
            
            let name = self.userAccount["userName"] as! String
            headerview.username.text = name
        }
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(StrangerUserInfoViewController.prepareData))
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(StrangerUserInfoViewController.footerRefresh))
        
        tableView.tableHeaderView = headerview
        self.view.addSubview(tableView)
        self.tableView.reloadData()
        

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true

        self.navigationBar?.setColors(background: UIColor.clear, text: Color.grey.lighten4)
        self.navigationBar?.makeTransparent()
        self.navigationBar?.tintColor = Color.grey.lighten4
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    
}

extension StrangerUserInfoViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! StrangerUserPageHeadCell
        cell.delegate = self
        cell.dataArr = self.dataArr
        cell.collectionView.reloadData()
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SCREEN_HEIGHT - 200
    }
    
}

extension StrangerUserInfoViewController:strangerUserWorkTappedDelegate{
    func cellTapped(index:Int,images:[SKPhoto]){
        let brower = SKPhotoBrowser(photos: images)
        brower.initializePageIndex(index)
        self.present(brower, animated: true) { 
            
        }
        
    }
}

