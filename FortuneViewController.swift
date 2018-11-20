//
//  FortuneViewController.swift
//  tu
//
//  Created by Rorschach on 2017/6/3.
//  Copyright © 2017年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import AVOSCloud
import Material
import SnapKit
import SVProgressHUD



class FortuneViewController: UIViewController {

    var textField:TextField!
    var reward = [4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,6,6,6,6,6,6,7,7,7,7,8,8,8,9,9,10,20]
    var sureBtn:FlatButton!
    
    
    var rewardLabel:UILabel!
    var rewardText:Int!
    var hideView:UIView!
    var hideViewLabel:UILabel!
    var imageScratchView:PGScratchView!
    
    var userAccount:AVObject!
    
    var rightItem:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "刮刮卡"
        self.extendedLayoutIncludesOpaqueBars = true
        self.view.backgroundColor = UIColor.white
        rightItem = UIBarButtonItem()
        rightItem.image = Icon.search
        rightItem.style = .plain
        rightItem.addTargetForAction(target: self, action: #selector(FortuneViewController.rightItemtapped(sender:)))
        self.navigationItem.rightBarButtonItem = rightItem

        prepareView()
        self.setHidden(isHidden: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationBar?.setColors(background: Color.grey.lighten4, text: Color.grey.darken3)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func rightItemtapped(sender:UIBarButtonItem){
        let vc = TipsViewController()
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = CGSize(width: 230, height: 70)
        let popover:UIPopoverPresentationController = vc.popoverPresentationController!
        popover.delegate = self
        popover.sourceView = self.view
        popover.barButtonItem = sender
        popover.permittedArrowDirections = .up
        self.present(vc, animated: true) {
            
        }

    }
    
    func prepareView(){
        textField = TextField()
        textField.placeholder = "输入口令"
        textField.clearButtonMode = .always
        textField.placeholderActiveColor = Color.grey.darken2
        textField.placeholderNormalColor = Color.grey.base
        textField.dividerActiveColor = Color.grey.base
        textField.dividerNormalColor = Color.grey.lighten2
        self.view.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-150)
            make.height.equalTo(40)
            make.left.equalTo(self.view).offset(30)
            make.right.equalTo(self.view).offset(-30)
        }
        
        sureBtn = FlatButton()
        sureBtn.setTitle("我准备好了", for: .normal)
        sureBtn.titleColor = Color.lightGreen.base
        sureBtn.layer.borderWidth = 1
        sureBtn.addTarget(self, action: #selector(FortuneViewController.sureBtnTapped(sender:)), for: .touchUpInside)
        sureBtn.layer.borderColor = Color.lightGreen.lighten2.cgColor
        self.view.addSubview(sureBtn)
        sureBtn.snp.makeConstraints { (make) in
            make.width.equalTo(textField)
            make.top.equalTo(textField.snp.bottom).offset(30)
            make.height.equalTo(40)
            make.centerX.equalTo(self.view)
        }
        
        rewardLabel = UILabel()
        rewardLabel.isHidden = true
        rewardLabel.font = RobotoFont.regular(with: 20)
        rewardLabel.textAlignment = .center
        rewardLabel.textColor = Color.grey.darken3
        self.view.addSubview(rewardLabel)
        rewardLabel.snp.makeConstraints { (make) in
            make.top.equalTo(sureBtn.snp.bottom).offset(50)
            make.height.equalTo(50)
            make.width.equalTo(150)
            make.centerX.equalTo(self.view)
        }
        
        hideView = UIView(frame: CGRect(x: 0, y: 0, width: 225, height: 100))
        hideView.backgroundColor = Color.grey.lighten1
        hideViewLabel = UILabel(frame: CGRect(x: 0, y: 35, width: 225, height: 30))
        hideViewLabel.textAlignment = .center
        hideViewLabel.textColor = UIColor.white
        hideViewLabel.text = "快刮开看看吧~"
        self.hideView.addSubview(hideViewLabel)
        
        imageScratchView = PGScratchView()
        imageScratchView.isHidden = true
        imageScratchView.scratchViewDelegate = self
        imageScratchView.sizeBrush = 20
        imageScratchView.passCount = 12
        imageScratchView.hideView = hideView
        self.view.addSubview(imageScratchView)
        imageScratchView.snp.makeConstraints { (make) in
            make.centerX.equalTo(rewardLabel)
            make.centerY.equalTo(rewardLabel)
            make.height.equalTo(100)
            make.width.equalTo(225)
        }
        
    }
    
    func sureBtnTapped(sender:FlatButton){
        SVProgressHUD.show()
        self.textField.resignFirstResponder()
        sender.isEnabled = false
        let query = AVQuery(className: "Reward")
        query.findObjectsInBackground { (result, error) in
            if error == nil{
                if result?.count == 0{
                    sender.isEnabled = true
                    SVProgressHUD.show(nil, status: "哎呀,暂时没有口令..")
                    SVProgressHUD.dismiss(withDelay: 1)
                }else{
                    let object = result?[0] as! AVObject
                    let query = AVQuery(className: "HasGetReward")
                    query.whereKey("user", equalTo: AVUser.current())
                    query.whereKey("message", equalTo: self.textField.text!)
                    query.findObjectsInBackground({ (result, error) in
                        if result?.count == 0{
                            let message = object["message"] as! String
                            print(":::\(object)")
                            print("::::\(self.textField.text)")
                            if message == self.textField.text!{
                                self.rewardText = self.reward.randomItem
                                self.rewardLabel.text = "获得 \(self.rewardText!) 涂币!"
                                self.setHidden(isHidden: false)
                                self.userAccount.incrementKey("userCoin", byAmount: self.rewardText as! NSNumber)
                                self.userAccount.saveInBackground({ (success, error) in
                                    if success{
                                        let saveObject = AVObject(className: "HasGetReward")
                                        saveObject.setObject(AVUser.current(), forKey: "user")
                                        saveObject.setObject(self.textField.text!, forKey: "message")
                                        saveObject.saveInBackground()
                                        self.setHasGetReward()
                                        SVProgressHUD.show(nil, status: "转扭蛋吗?希望得到你想要的机体.")
                                        SVProgressHUD.dismiss(withDelay: 1)
                                    }else{
                                        sender.isEnabled = true
                                        let e1 = error as! NSError
                                        SVProgressHUD.show(nil, status: "网络发生了一点问题..\(e1.code)")
                                        SVProgressHUD.dismiss(withDelay: 1)
                                    }

                                })
                            }else{
                                sender.isEnabled = true
                                SVProgressHUD.show(nil, status: "这条口令不正确...")
                                SVProgressHUD.dismiss(withDelay: 1)
                            }
                        }else{
                            self.setHasGetReward()
                            SVProgressHUD.show(nil, status: "你已经获得过奖励了...")
                            SVProgressHUD.dismiss(withDelay: 1)

                        }
                    })
                }
            }else{
                sender.isEnabled = true
                let e1 = error as! NSError
                SVProgressHUD.showError(withStatus: "网络出现了一些问题...\(e1.code)")
                SVProgressHUD.dismiss(withDelay: 1)
            }
        }
    }
    
    func setHidden(isHidden:Bool){
        self.rewardLabel.isHidden = isHidden
        self.imageScratchView.isHidden = isHidden
    }
    
    func setHasGetReward(){
        self.sureBtn.isEnabled = false
        self.sureBtn.setTitle("明天再来吧~", for: .normal)
        self.sureBtn.layer.borderColor = Color.grey.lighten2.cgColor
        self.sureBtn.titleColor = Color.grey.base

    }
}

extension FortuneViewController:PGScratchViewDelegate{


    func openAllCover(_ scratchView: PGScratchView!) {
 
        if rewardText == 20{
            setHasGetReward()
            SVProgressHUD.show(nil, status: "哇,传说~ + 20 涂币")
        }else{
            setHasGetReward()
            SVProgressHUD.show(nil, status: "运气不错嘛, + \(rewardText) 涂币")
        }
        
    }
}

extension FortuneViewController:UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}
