//
//  InputWorkInfoViewController.swift
//  tu
//
//  Created by Rorschach on 2017/2/15.
//  Copyright © 2017年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import SnapKit

import AVOSCloud
import SVProgressHUD
import Material
import SwifterSwift
import YYKeyboardManager

class InputWorkInfoViewController: UIViewController {
    var workTitle:TextField!
    var workDetailDescription:TextView!
    var workPrice:TextField!

    var keyboardManager = YYKeyboardManager.default()
    
    var selectedWork:AVObject?
    var imgFile:AVFile?
    
    var rightItem = UIBarButtonItem(title: "确定", style: .plain, target: self, action: #selector(InputWorkInfoViewController.btnSure))

    var isPriceLegal:Bool = false
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.extendedLayoutIncludesOpaqueBars = true

        self.navigationItem.rightBarButtonItem = rightItem

        keyboardManager.add(self)
        
        self.initView()
        
        

        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    func initView() {
        self.workTitle = TextField()
        self.workTitle.placeholder = "      作品名称"

        setTextFieldStyle(textField: workTitle)
        self.view.addSubview(workTitle)
        self.workTitle.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(0)
            make.width.equalTo(SCREEN_WIDTH/2 - 2)
            make.height.equalTo(32)
            make.top.equalTo(view).offset(84)
        }
        self.workTitle.becomeFirstResponder()
        
        self.workPrice = TextField()
        self.workPrice.placeholder = "        作品售价"
        self.workPrice.detail = "不超过5位数"
        self.workPrice.detailColor = Color.grey.base
        self.workPrice.keyboardType = .numberPad
        setTextFieldStyle(textField: workPrice)
        workPrice.delegate = self
        self.view.addSubview(workPrice)
        self.workPrice.snp.makeConstraints { (make) in
            make.right.equalTo(view.snp.right)
            make.width.equalTo(SCREEN_WIDTH/2 - 2)
            make.height.equalTo(32)
            make.top.equalTo(workTitle.snp.top)
        }
        
        workDetailDescription = TextView()
        workDetailDescription.textColor = Color.grey.base
        workDetailDescription.font = RobotoFont.regular(with: 16)
        workDetailDescription.placeholder = "   简单介绍一下吧...."
        self.view.addSubview(workDetailDescription)
        workDetailDescription.snp.makeConstraints { (make) in
            make.top.equalTo(workTitle.snp.bottom).offset(20)
            make.centerX.equalTo(view)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(SCREEN_HEIGHT - 136)
        }
        
        
    }
    
    
    func btnSure() {
        self.rightItem.isEnabled = false
        if !(workTitle.text!.isEmpty) && !(workPrice.text!.isEmpty) && isPriceLegal {
            SVProgressHUD.show()
            let object = AVObject(className: "WorksOnSale")
            object.setObject(selectedWork, forKey: "workOnSale")
            object.setObject(imgFile, forKey: "workFile")
            object.setObject(AVUser.current(), forKey: "workOwner")
            object.setObject(AVUser.current()?.username, forKey: "workOwnerName")
            object.setObject(self.workTitle.text, forKey: "workTitle")
            object.setObject(self.workPrice.text?.int, forKey: "workPrice")
            object.setObject(self.workDetailDescription.text, forKey: "workDetailDescription")
            object.saveInBackground({ (success, error) in
                if success {
                    self.selectedWork?.setObject(false, forKey: "saleable")
                    self.selectedWork?.saveInBackground({ (success, error) in
                        if success{
                            SVProgressHUD.showSuccess(withStatus: "发布成功!")
                            SVProgressHUD.dismiss(withDelay: 1)
                            let historyObject = AVObject(className: "WorksTranscationHistory")
                            let transcationTimes = self.selectedWork?["transcationTimes"] as! Int
                            if transcationTimes == 0{
                            
                                historyObject.setObject(AVUser.current(), forKey: "originalOwner")
                                historyObject.setObject(AVUser.current(), forKey: "lastOwner")
                                historyObject.setObject(object, forKey: "workOnSale")
                                historyObject.saveInBackground()
                            }else{
                                historyObject.setObject(AVUser.current(), forKey: "lastOwner")
                                historyObject.setObject(object, forKey: "workOnSale")
                                historyObject.saveInBackground()
                            }
                            self.navigationController?.popToRootViewController(animated: true)
                        }else{
                            let e1 = error as! NSError
                            SVProgressHUD.showError(withStatus: "修改出售状态失败 \(e1.code)")
                            SVProgressHUD.dismiss(withDelay: 1)
                            self.rightItem.isEnabled = true
                        }
                    })

                }else{
                    let e1 = error as! NSError
                    SVProgressHUD.showError(withStatus: "网络不太好...\(e1.code)")
                    SVProgressHUD.dismiss(withDelay: 1)
                    self.rightItem.isEnabled = true
                }
            })
        }else{
            if !isPriceLegal{
                SVProgressHUD.showError(withStatus: "价格不得超过5位数...")
                SVProgressHUD.dismiss(withDelay: 1)
                self.rightItem.isEnabled = true
            }else{
                SVProgressHUD.showError(withStatus: "标题和价格必须填哦!~")
                SVProgressHUD.dismiss(withDelay: 1)
                self.rightItem.isEnabled = true
            }
        }
    }
    
    
    
    //set style
    func setTextFieldStyle(textField:TextField){
        
        textField.leftViewMode = .never
        textField.clearButtonMode = .always
        
        textField.textColor = Color.grey.base

        textField.placeholderActiveColor = Color.grey.base
        textField.placeholderNormalColor = Color.grey.lighten1
        textField.dividerActiveColor = Color.lightGreen.base
        textField.dividerNormalColor = Color.grey.darken2
        
    }


}

extension InputWorkInfoViewController:YYKeyboardObserver{
    func keyboardChanged(with transition: YYKeyboardTransition) {
        let keyboardView = keyboardManager.keyboardFrame
        self.workDetailDescription.snp.updateConstraints { (make) in
            make.height.equalTo(SCREEN_HEIGHT - 136 - keyboardView.size.height)
        }
    }
}

extension InputWorkInfoViewController:TextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let textF = textField as! TextField
        
        if (textF.text?.length)! > 6{
            isPriceLegal = false
            textF.detailColor = Color.red.lighten2
        }else{
            isPriceLegal = true
            textF.detailColor = Color.grey.base
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let textF = textField as! TextField
        
        if (textF.text?.length)! > 6{
            isPriceLegal = false
            textF.detailColor = Color.red.lighten2
        }else{
            isPriceLegal = true
            textF.detailColor = Color.grey.base
        }

    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        let textF = textField as! TextField
        
        if (textF.text?.length)! > 6{
            isPriceLegal = false
            textF.detailColor = Color.red.lighten2
        }else{
            isPriceLegal = true
            textF.detailColor = Color.grey.base
        }

        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textF = textField as! TextField
        
        if (textF.text?.length)! > 6{
            isPriceLegal = false
            textF.detailColor = Color.red.lighten2
        }else{
            isPriceLegal = true
            textF.detailColor = Color.grey.base
        }

        return true
    }
}
