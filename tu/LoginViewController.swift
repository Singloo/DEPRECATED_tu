//
//  LoginViewController.swift
//  tu
//
//  Created by Rorschach on 2016/10/30.
//  Copyright © 2016年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
import AVOSCloud
import Material
import SwifterSwift


class LoginViewController: UIViewController {
    
    var bkImage:UIImageView!
    var blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    var vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: UIBlurEffect(style: .dark)))
    //material
    var nickName:TextField!
    var passWord:TextField!
    var login:FlatButton!
//    var mainTitle:UILabel!
    var registerNew:Button!
    
    var forgetPassword:Button!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        self.view.backgroundColor = UIColor.white
        prepareBackground()
        prepareView()
        self.bkImage.alpha = 0
        nickName.snp.updateConstraints { (make) in
           make.centerX.equalTo(view).offset(-(SCREEN_WIDTH - 32))
        }
        
        passWord.snp.updateConstraints { (make) in

            make.centerX.equalTo(view).offset(-(SCREEN_WIDTH - 32))
        }
        
        login.snp.updateConstraints { (make) in

            make.centerX.equalTo(view).offset(-(SCREEN_WIDTH - 32))
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)


        self.tabBarController?.tabBar.isHidden = true
        if AVUser.current() != nil{
            self.navigationController?.popViewController(animated: true)
        }
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        
        self.navigationBar?.setColors(background: UIColor.white.withAlphaComponent(0), text: Color.grey.lighten4)
        self.navigationBar?.makeTransparent()
        
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: {
            self.nickName.center.x = SCREEN_WIDTH/2
        }, completion: nil)

        UIView.animate(withDuration: 1, delay: 0.1, options: .curveEaseIn, animations: {
            self.passWord.center.x = SCREEN_WIDTH/2
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0.2, options: .curveEaseIn, animations: {
            self.login.center.x = SCREEN_WIDTH/2
        }, completion: nil)
        
        UIView.animate(withDuration: 2) { 
            self.bkImage.alpha = 1
        }
        
//        UIView.animate(withDuration: 20) { 
//            self.bkImage.frame = CGRect(x: -1*( 1000 - SCREEN_WIDTH )/2, y: 0, width: SCREEN_HEIGHT+500, height: SCREEN_HEIGHT+500)
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func Login() {
        self.login.isEnabled = false
        
        AVUser.logInWithUsername(inBackground: self.nickName.text!, password: self.passWord.text!) { (user, error) in
            if error == nil {
                self.navigationController?.popViewController(animated: true)
            }else{
                let e1 = error as! NSError
                switch e1.code{
                case 210:
                    self.login.isEnabled = true
                    SVProgressHUD.show(nil, status: "用户名和密码不匹配。")
                    SVProgressHUD.dismiss(withDelay: 1)
                case 211:
                    SVProgressHUD.show(nil, status: "找不到用户。")
                    self.login.isEnabled = true
                    SVProgressHUD.dismiss(withDelay: 1)
                case 216:
                    SVProgressHUD.show(nil, status: "未验证的邮箱地址。")
                    self.login.isEnabled = true
                    SVProgressHUD.dismiss(withDelay: 1)
                case 219:
                    SVProgressHUD.show(nil, status: "登录失败次数超过限制，请稍候再试，或者通过忘记密码重设密码")
                    self.login.isEnabled = true
                    SVProgressHUD.dismiss(withDelay: 1)
                default:
                    SVProgressHUD.show(nil, status: "登录失败..请检查网络\(e1.code)")
                    self.login.isEnabled = true
                    SVProgressHUD.dismiss(withDelay: 1)
                }
            }
        }
        
    }
    
    func RegisterNew() {
        let vc = RegisterNewViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //prepare view
    
    func prepareBackground(){
        bkImage = UIImageView()
        bkImage.image = UIImage(named: "neo")
        bkImage.contentMode = .scaleToFill
        self.view.layout(bkImage).edges()
        
        blurView.frame = bkImage.bounds
        self.view.addSubview(blurView)
        vibrancyView.frame = bkImage.bounds
        self.blurView.contentView.addSubview(vibrancyView)
    }
    
    func prepareView(){
    
        nickName = TextField()
        nickName.placeholder = "用户名"
        let nickNameleftview = UIImageView()
        nickNameleftview.image = UIImage(named: "mls_username")
        nickName.leftView = nickNameleftview
     
        setTextFieldStyle(textField: nickName)
        self.vibrancyView.addSubview(nickName)
        nickName.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.width.equalTo(SCREEN_WIDTH - 64)
            make.height.equalTo(32)
            make.top.equalTo(view).offset(150)
        }
        
        passWord = TextField()
        passWord.placeholder = "密码"
        let passwordLeftview = UIImageView()
        passwordLeftview.image = UIImage(named: "mls_password")
        passWord.leftView = passwordLeftview

        passWord.isVisibilityIconButtonEnabled = true
        passWord.visibilityIconButton?.tintColor = Color.blueGrey.base.withAlphaComponent(passWord.isSecureTextEntry ? 0.38 : 0.54)
        setTextFieldStyle(textField: passWord)
        self.vibrancyView.addSubview(passWord)
        passWord.snp.makeConstraints { (make) in
            make.top.equalTo(nickName.snp.bottom).offset(32)
            make.width.equalTo(nickName)
            make.height.equalTo(32)
            make.centerX.equalTo(view)
        }
        
        login = FlatButton()
        login.setTitle("登 录", for: .normal)
        login.backgroundColor = Color.lightGreen.base.withAlphaComponent(0.8)
        login.titleColor = Color.white
        login.addTarget(self, action: #selector(LoginViewController.Login), for: .touchUpInside)
        self.vibrancyView.addSubview(login)
        login.snp.makeConstraints { (make) in
            make.width.equalTo(passWord)
            make.height.equalTo(32)
            make.centerX.equalTo(view)
            make.top.equalTo(passWord.snp.bottom).offset(21)
        }
        
        registerNew = Button()
        registerNew.isUserInteractionEnabled = true
        registerNew.setTitle("点击注册新用户", for: .normal)
        registerNew.titleLabel?.textAlignment = .right
        registerNew.titleColor = Color.grey.lighten4
        registerNew.titleLabel?.font = RobotoFont.regular(with: 13)
        registerNew.addTarget(self, action: #selector(LoginViewController.RegisterNew), for: .touchUpInside)
        self.vibrancyView.addSubview(registerNew)
        registerNew.snp.makeConstraints { (make) in
            make.bottom.equalTo(view).offset(-60)
            make.right.equalTo(view).offset(-8)
            make.height.equalTo(25)
            make.width.equalTo(100)
        }
        
        forgetPassword = Button()
        forgetPassword.isUserInteractionEnabled = true
        forgetPassword.setTitle("忘记密码?", for: .normal)
        forgetPassword.titleLabel?.textAlignment = .left
        forgetPassword.titleColor = Color.grey.lighten4
        forgetPassword.titleLabel?.font = RobotoFont.regular(with: 13)
        forgetPassword.addTarget(self, action: #selector(LoginViewController.forgetPasswordAction), for: .touchUpInside)
        self.vibrancyView.addSubview(forgetPassword)
        forgetPassword.snp.makeConstraints { (make) in
            make.bottom.equalTo(view).offset(-60)
            make.left.equalTo(view).offset(8)
            make.height.equalTo(25)
            make.width.equalTo(100)
        }

        
    }
    
    func forgetPasswordAction(){
        let vc = ForgetPassWordViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setTextFieldStyle(textField:TextField){
        
        textField.leftViewMode = .always
        textField.clearButtonMode = .always
    
        textField.textColor = Color.grey.lighten5.withAlphaComponent(0.8)
        
        textField.leftViewNormalColor = Color.grey.lighten2.withAlphaComponent(0.8)
        textField.leftViewActiveColor = Color.lightGreen.base.withAlphaComponent(0.8)
        textField.placeholderActiveColor = Color.lightGreen.base.withAlphaComponent(0.8)
        textField.placeholderNormalColor = Color.grey.lighten2.withAlphaComponent(0.8)
        textField.dividerActiveColor = Color.lightGreen.base.withAlphaComponent(0.8)
        textField.dividerNormalColor = Color.grey.lighten4.withAlphaComponent(0.8)
        
    }

    
}
