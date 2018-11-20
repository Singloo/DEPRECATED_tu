//
//  UserViewController.swift
//  tu
//
//  Created by Rorschach on 2016/10/30.
//  Copyright © 2016年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import AVOSCloud
import SnapKit
import RSKImageCropper
import MJRefresh
import SKPhotoBrowser
import SDWebImage
import SVProgressHUD
import Material

class UserViewController: UIViewController,PhotoPickerDelegate,RSKImageCropViewControllerDelegate,UITableViewDelegate,UITableViewDataSource{


    let cellIdentifier = "userVCCell"

    
    var bkImage:UIImageView!
    var userName:UILabel!
    var userCoin:UILabel!
    var userAvatar:UIImageView!
    var check:FlatButton!
    
    var rightSet:UIBarButtonItem!
    
    var dataArray = NSMutableArray()
    var images = [SKPhoto]()
    
    var tableView:UITableView!
    
    var blurEffect = UIVisualEffectView(effect: UIBlurEffect(style: .light))

    
    
    var currentUserObject:AVObject!
    var checkInCoinNum = [2,2,3,3,4,5]
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.prepareView()


        prepareTableview()
        rightSet = UIBarButtonItem(image: Icon.cm.settings, style: .plain, target: self, action: #selector(UserViewController.rightBtnTapped))
        self.navigationItem.rightBarButtonItem = rightSet



        


   
    }
    
    func prepareTableview() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UserNotificationCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView(frame: .zero)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(bkImage.snp.bottom).offset(0)
            make.width.equalTo(SCREEN_WIDTH)
            make.bottom.equalTo(view)
        }
        tableView.reloadData()
        
    }
    
    func rightBtnTapped(){
        let vc = MoreSettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    //
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        UIApplication.shared.statusBarStyle = .lightContent


        self.navigationBar?.setColors(background: UIColor.white.withAlphaComponent(0), text: Color.grey.lighten4)

        self.navigationBar?.makeTransparent()

        if AVUser.current() != nil {
            self.setUserInfo()

        }else{
            self.userName.text = "登录开启更多功能哦~"
            self.userCoin.text = ""
            
            self.userAvatar.image = UIImage(named: "mls_one")
            self.bkImage.image = UIImage(named: "mls_one")
            
            self.check.setTitle("签 到", for: .normal)
            self.check.titleColor = Color.lightGreen.base
            self.check.isEnabled = true
            self.check.layer.borderWidth = 1
            self.check.layer.borderColor = Color.lightGreen.lighten2.cgColor

        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //prepare base data

    
    //mark tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [2,2,1][section]

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return [0,10,50][section]
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return [10,10,0.1][section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! UserNotificationCell
        switch (indexPath.section) {
        case 0:
            switch (indexPath.row){
            case 0:
                cell.title?.text = "我的作品"
                return cell
            case 1:
                cell.title?.text = "正在出售"
                return cell
            default:
                return UITableViewCell()
            }
        case 1:
            switch (indexPath.row) {
            case 0:
                cell.title?.text = "涂币商城"
                return cell
            case 1:
                cell.title.text = "刮刮卡?"
                return cell
            default:
                return UITableViewCell()
            }
        case 2:
            switch (indexPath.row) {
            case 0:
                cell.title?.text = "应用说明"
                return cell
            default:
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section) {
        case 0:
            switch (indexPath.row){
            case 0:
                if AVUser.current() == nil{
                    let vc = LoginViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)

                }else{
                    let vc = UserWorksViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case 1:
                if AVUser.current() == nil{
                    let vc = LoginViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else{
                    let vc = OnSaleWorksViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            default:
                break
            }
        case 1:
            switch (indexPath.row) {
            case 0:
                let vc = CoinMallViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                if AVUser.current() == nil{
                    let vc = LoginViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else{
                    let vc = FortuneViewController()
                    vc.userAccount = self.currentUserObject
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            default:
                break
            }
        case 2:
            let vc = StatementViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            break
            
        }
        
    }
    
    //init
    func setUserInfo() {
        self.userName.text = AVUser.current()?.username

 
        let query = AVQuery(className: "UserAccount")
        query.whereKey("user", equalTo: AVUser.current())
        query.findObjectsInBackground { (result, error) in
            if error == nil{
                let object = result?[0] as! AVObject
                self.currentUserObject = object
                let imageFile = object["userAvatar"] as? AVFile
                let userCoin = object["userCoin"] as! Int
                
                self.userCoin.text = "\(userCoin)"
                self.userAvatar.sd_setImage(with: URL(string: (imageFile?.url)!))
                self.bkImage.sd_setImage(with: URL(string: (imageFile?.url)!))
                let checkIndate = object["checkInDate"] as? Date
                
                if checkIndate == nil{
                    self.check.isEnabled = true
                }else{
                    if (checkIndate?.isInToday)!{
                        self.check.titleColor = Color.grey.base
                        self.check.layer.borderColor = Color.grey.lighten2.cgColor
                        self.check.isEnabled = false
                        self.check.setTitle("已签到", for: .normal)
                    }

                }
                
            }else{
                let e1 = error as! NSError
                SVProgressHUD.showError(withStatus: "加载不出来信息...\(e1)")
                SVProgressHUD.dismiss(withDelay: 1)
            }
        }
    }
    

    //imageCropper
    func choiceImage() {
        if AVUser.current() != nil {
            let vc = PhotoPickerViewController()
            vc.delegate = self
            vc.modalPresentationStyle = .overCurrentContext

            
            self.present(vc, animated: true, completion: {
//                vc.view.superview?.backgroundColor = Color.clear
            })
        }else{
            let vc = LoginViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getImageFromPicker(image: UIImage) {
        let imageCropVC = RSKImageCropViewController(image: image, cropMode: .circle)
        imageCropVC.delegate = self
        self.present(imageCropVC, animated: true) { 
            
        }
    }
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        controller.dismiss(animated: true) { 
            
        }
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        SVProgressHUD.show()
        let query = AVQuery(className: "UserAccount")
        query.whereKey("user", equalTo: AVUser.current())
        query.findObjectsInBackground { (result, error) in
            if error == nil{
                let object = result?[0] as! AVObject
                let file = AVFile(data: UIImagePNGRepresentation(croppedImage)!)
                
                object.setObject(file, forKey: "userAvatar")
                object.saveInBackground({ (success, error) in
                    if success{
                        self.userAvatar.image = croppedImage
                        SVProgressHUD.showSuccess(withStatus: "头像修改成功")
                        SVProgressHUD.dismiss(withDelay: 1)
                    }else{
                        let ec = error as! NSError
                        SVProgressHUD.showError(withStatus: "网络不给力啊,头像上传失败了\(ec.code)")
                        SVProgressHUD.dismiss(withDelay: 1)
                        
                    }

                })
            }
        }
        
        controller.dismiss(animated: true) { 
            
        }
    }
    
    
    //checkup
    func checkIn(sender:FlatButton){
        let randam = self.checkInCoinNum.randomItem
        sender.isEnabled = false
        if AVUser.current() == nil{
            let vc = LoginViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            SVProgressHUD.show()
            currentUserObject.fetchInBackground({ (object, error) in
                if error == nil{
                    let checkIndate = object?["checkInDate"] as? Date
                    
                    if checkIndate == nil{
                        AVOSCloud.getServerDate({ (date, error) in
                            if error == nil{
                                object?.incrementKey("userCoin", byAmount: NSNumber(value: randam))
                                object?.setObject(date, forKey: "checkInDate")
                                object?.saveInBackground({ (success, error) in
                                    if success {
                                        sender.layer.borderColor = Color.grey.lighten2.cgColor
                                        sender.titleColor = Color.grey.base
                                        sender.setTitle("已签到", for: .normal)
                                        SVProgressHUD.show(nil, status: "签到成功!+\(randam)")
                                        SVProgressHUD.dismiss(withDelay: 1)
                                    }else{
                                        let ec = error as! NSError
                                        sender.isEnabled = true
                                        SVProgressHUD.showError(withStatus: "签到失败了..\(ec.code)")
                                        SVProgressHUD.dismiss(withDelay: 1)
                                    }
                                })

                            }else{
                                let ec = error as! NSError
                                sender.isEnabled = true
                                SVProgressHUD.showError(withStatus: "签到失败了..\(ec.code)")
                                SVProgressHUD.dismiss(withDelay: 1)
                            }
                        })
                    }else{
                        if (checkIndate?.isInPast)! && !(checkIndate?.isInToday)!{
                            AVOSCloud.getServerDate({ (date, error) in
                                if error == nil{
                                    
                                    object?.incrementKey("userCoin", byAmount: NSNumber(value: randam))
                                    object?.setObject(date, forKey: "checkInDate")
                                    object?.saveInBackground({ (success, error) in
                                        if success {
                                            sender.layer.borderColor = Color.grey.lighten2.cgColor
                                            sender.titleColor = Color.grey.base
                                            sender.setTitle("已签到", for: .normal)
                                            let coinNum = (self.userCoin.text?.int)! + randam
                                            self.userCoin.text = "\(coinNum)"
                                            
                                            SVProgressHUD.show(nil, status: "签到成功!+\(randam)")
                                            SVProgressHUD.dismiss(withDelay: 1.5)
                                        }else{
                                            let ec = error as! NSError
                                            sender.isEnabled = true
                                            SVProgressHUD.showError(withStatus: "签到失败了..\(ec.code)")
                                            SVProgressHUD.dismiss(withDelay: 1)
                                        }
                                    })
                                }
                            })
                        }else{
                            SVProgressHUD.show(withStatus: "今日已签到~")
                            SVProgressHUD.dismiss(withDelay: 1)
                        }
                    }
                }else{
                    let ec = error as! NSError
                    SVProgressHUD.show(withStatus: "签到失败了...\(ec.code)")
                    SVProgressHUD.dismiss(withDelay: 1)
                }
                
            })
        }
        
    }
    
    //prepareview
    
    
    func prepareView() {
        bkImage = UIImageView()
        self.bkImage.image = UIImage(named: "two")
        self.bkImage.contentMode = .scaleToFill
        self.view.addSubview(bkImage)
        self.bkImage.snp.makeConstraints { (make) in
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(SCREEN_HEIGHT/4)
            make.top.equalTo(view).offset(0)
        }
        
        let bkView = UIView()
        bkView.backgroundColor = Color.grey.base.withAlphaComponent(0.4)
        self.view.addSubview(bkView)
        bkView.snp.makeConstraints { (make) in
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(SCREEN_HEIGHT/4)
            make.top.equalTo(view).offset(0)
        }
        
        self.view.addSubview(blurEffect)
        self.blurEffect.snp.makeConstraints { (make) in
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(SCREEN_HEIGHT/4)
            make.top.equalTo(view).offset(0)
        }
        
        userAvatar = UIImageView()
        self.userAvatar.image = UIImage(named: "mls_one")
        self.view.addSubview(userAvatar)
        self.userAvatar.snp.makeConstraints { (make) in
            make.width.equalTo(70)
            make.height.equalTo(70)
            make.left.equalTo(view).offset(28)
            make.top.equalTo(view).offset(50)
        }
        self.userAvatar.layer.cornerRadius = 35
        self.userAvatar.clipsToBounds = true
        self.userAvatar.layer.borderWidth = 2
        self.userAvatar.layer.borderColor = Color.grey.lighten4.cgColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(UserViewController.choiceImage))
        self.userAvatar.addGestureRecognizer(tap)
        self.userAvatar.isUserInteractionEnabled = true
        
        
        userName = UILabel()
        self.userName.text = "用户名"
        self.userName.textColor = UIColor.white
        self.userName.textAlignment = .left
        self.userName.font = RobotoFont.regular(with: 17)
        self.view.addSubview(userName)
        self.userName.snp.makeConstraints { (make) in
            make.right.equalTo(view).offset(-50)
            make.height.equalTo(20)
            make.left.equalTo(userAvatar.snp.right).offset(25)
            make.top.equalTo(userAvatar)
        }
        
        userCoin = UILabel()
        self.userCoin.text = "100"
        self.userCoin.font = RobotoFont.light(with: 16)
        self.userCoin.textColor = UIColor.white
        self.userCoin.textAlignment = .left
        self.view.addSubview(userCoin)
        self.userCoin.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(20)
            make.left.equalTo(userName.snp.left)
            make.bottom.equalTo(userAvatar.snp.bottom)
        }
        
        check = FlatButton()
        self.check.isUserInteractionEnabled = true
        self.check.addTarget(self, action: #selector(UserViewController.checkIn(sender:)), for: .touchUpInside)
        self.check.isEnabled = true
        self.check.setTitle("签 到", for: .normal)
        self.check.titleColor = Color.lightGreen.base
        self.check.layer.borderWidth = 1
        self.check.layer.borderColor = Color.lightGreen.lighten2.cgColor
        self.check.backgroundColor = UIColor.clear
        self.view.addSubview(check)
        self.check.snp.makeConstraints { (make) in
            make.width.equalTo(70)
            make.height.equalTo(30)
            make.centerY.equalTo(userCoin.snp.centerY)
            make.right.equalTo(self.view).offset(-20)
        }
    }




}
