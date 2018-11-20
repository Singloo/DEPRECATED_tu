//
//  ForgetPassWordViewController.swift
//  tu
//
//  Created by Rorschach on 2017/6/5.
//  Copyright © 2017年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import Material
import SVProgressHUD
import SnapKit
import AVOSCloud
class ForgetPassWordViewController: UIViewController {

    var emailTF:UITextField!
    var sureBtn:FlatButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        emailTF = UITextField()
        emailTF.placeholder = "输入你的邮箱吧~"
        self.view.addSubview(emailTF)
        emailTF.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(-60)
            make.right.equalTo(view).offset(-32)
            make.left.equalTo(view).offset(32)
        }
        
        sureBtn = FlatButton()
        sureBtn.setTitle("好了", for: .normal)
        sureBtn.titleColor = Color.lightGreen.base
        sureBtn.layer.borderWidth = 1
        sureBtn.addTarget(self, action: #selector(ForgetPassWordViewController.sureBtnAction), for: .touchUpInside)
        sureBtn.layer.borderColor = Color.lightGreen.lighten2.cgColor
        self.view.addSubview(sureBtn)
        sureBtn.snp.makeConstraints { (make) in
            make.width.equalTo(emailTF)
            make.top.equalTo(emailTF.snp.bottom).offset(30)
            make.height.equalTo(40)
            make.centerX.equalTo(self.view)
        }

        
    }
    
    func sureBtnAction(){
        sureBtn.isEnabled = false
        if (emailTF.text?.isEmail)!{
            sureBtn.isEnabled = true
            AVUser.requestPasswordResetForEmail(inBackground: self.emailTF.text!, block: { (success, error) in
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

        }else{
            sureBtn.isEnabled = true
            SVProgressHUD.show(nil, status: "你输的是邮箱吗?")
            SVProgressHUD.dismiss(withDelay: 1)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
        self.tabBarController?.tabBar.isHidden = true
        navigationBar?.setColors(background: UIColor.white, text: Color.grey.base)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
