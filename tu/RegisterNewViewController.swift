//
//  RegisterNewViewController.swift
//  tu
//
//  Created by Rorschach on 2016/10/30.
//  Copyright © 2016年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import AVOSCloud
import SVProgressHUD
import SnapKit
import Material
import SwifterSwift
import YYKeyboardManager

class RegisterNewViewController: UIViewController,TextFieldDelegate {

    var bkImage:UIImageView!
    var blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    var vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: UIBlurEffect(style: .dark)))

    
    var passwordReady:Bool = false
    var emailReady:Bool = false
    var nicknameReady:Bool = false
    
    var userNickname:ErrorTextField!
    var password:TextField!
    var passwordTwice:ErrorTextField!
    var emailField:ErrorTextField!
    
    var userAgreement:UIButton!
    var regisetBtn:FlatButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.extendedLayoutIncludesOpaqueBars = true
        
        self.view.backgroundColor = UIColor.white

        prepareBackground()
        prepareView()
        self.bkImage.alpha = 0
        
    }
    
    
    func registerNew() {
        SVProgressHUD.show()
        regisetBtn.isEnabled = false
        if nicknameReady && passwordReady && emailReady{
            let user = AVUser()
            user.username = self.userNickname.text
            user.password = self.passwordTwice.text
            user.email = self.emailField.text
            user.signUpInBackground { (success, error) in
                if success {
                    let object = AVObject(className: "UserAccount")
                    object.setObject(user, forKey: "user")
                    object.setObject(user.username, forKey: "userName")
                    object.saveEventually({ (success, error) in
                        if success{
                            SVProgressHUD.showSuccess(withStatus: "注册成功!~验证邮箱后就可以登录了!")
                            SVProgressHUD.dismiss(withDelay: 1)
                            self.navigationController?.popViewController(animated: true)
                        }else{
                            let e1 = error as! NSError
                            SVProgressHUD.showError(withStatus: "网络不太好...注册失败\(e1.code)")
                            self.regisetBtn.isEnabled = true
                        }
                    })


                }else{
                    self.regisetBtn.isEnabled = true
                    let e1 = error as! NSError
                    switch e1.code{
                    case 125:
                        SVProgressHUD.show(nil, status: "电子邮箱地址无效")
                        SVProgressHUD.dismiss(withDelay: 1)
                    case 126:
                        SVProgressHUD.show(nil, status: "无效的用户 Id，可能用户不存在无效")
                        SVProgressHUD.dismiss(withDelay: 1)
                    case 139:
                        SVProgressHUD.show(nil, status: "角色名称非法，角色名称只能以英文字母、数字或下划线组成。")
                        SVProgressHUD.dismiss(withDelay: 1)
                    case 200:
                        SVProgressHUD.show(nil, status: "没有提供用户名，或者用户名为空。")
                        SVProgressHUD.dismiss(withDelay: 1)
                    case 201:
                        SVProgressHUD.show(nil, status: "没有提供密码，或者密码为空。")
                        SVProgressHUD.dismiss(withDelay: 1)
                    case 202:
                        SVProgressHUD.show(nil, status: "用户名已经被占用。")
                        SVProgressHUD.dismiss(withDelay: 1)
                    case 203:
                        SVProgressHUD.show(nil, status: "电子邮箱地址已经被占用。")
                        SVProgressHUD.dismiss(withDelay: 1)
                    case 204:
                        SVProgressHUD.show(nil, status: "没有提供电子邮箱地址。")
                        SVProgressHUD.dismiss(withDelay: 1)
                    case 205:
                        SVProgressHUD.show(nil, status: "找不到电子邮箱地址对应的用户。")
                        SVProgressHUD.dismiss(withDelay: 1)
                        
                    default:
                        SVProgressHUD.show(nil, status: "注册是失败 \(e1.code)")

                    }
                }
            }

        }else{
            if !nicknameReady{
                SVProgressHUD.showError(withStatus: "昵称不符合要求")
                SVProgressHUD.dismiss(withDelay: 1)
            }else if !passwordReady{
                SVProgressHUD.showError(withStatus: "密码不符合要求")
                SVProgressHUD.dismiss(withDelay: 1)
            }else if !emailReady{
                SVProgressHUD.showError(withStatus: "邮箱不符合要求")
                SVProgressHUD.dismiss(withDelay: 1)
            }
            self.regisetBtn.isEnabled = true
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if AVUser.current() != nil{
            self.navigationController?.popToRootViewController(animated: true)
        }

        UIApplication.shared.statusBarStyle = .lightContent
        
        self.navigationBar?.setColors(background: UIColor.white.withAlphaComponent(0), text: Color.grey.lighten4)
        self.navigationBar?.makeTransparent()

        self.tabBarController?.tabBar.isHidden = true
        
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
    
    
    //prepare view
    func prepareBackground(){
        bkImage = UIImageView()
        bkImage.image = UIImage(named: "two")
        bkImage.contentMode = .scaleToFill
        self.view.layout(bkImage).edges()
        
        blurView.frame = bkImage.bounds
        self.view.addSubview(blurView)
        vibrancyView.frame = bkImage.bounds
        self.blurView.contentView.addSubview(vibrancyView)
    }

    
    
    func prepareView(){
        userNickname = ErrorTextField()
        userNickname.delegate = self
        userNickname.placeholder = "输入用户名用户名"
        userNickname.detail = "长度不可以超过16个字符,至少2个字符"
        let nickNameleftview = UIImageView()
        nickNameleftview.image = UIImage(named: "mls_username")
        userNickname.leftView = nickNameleftview
        userNickname.tag = 20
        setErrorTextFieldStyle(errorTextField: userNickname)
        self.vibrancyView.addSubview(userNickname)
        userNickname.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.width.equalTo(SCREEN_WIDTH - 64)
            make.height.equalTo(32)
            make.top.equalTo(view).offset(100)
        }
        
        
        password = TextField()
        password.placeholder = "输入你的密码"
        password.detail = "密码长度至少6位"
        let passwordLeftview = UIImageView()
        passwordLeftview.image = UIImage(named: "mls_password")
        password.leftView = passwordLeftview
        password.isVisibilityIconButtonEnabled = true
        password.visibilityIconButton?.tintColor = Color.blueGrey.base.withAlphaComponent(password.isSecureTextEntry ? 0.38 : 0.54)
        setTextFieldStyle(textField: password)
        self.vibrancyView.addSubview(password)
        password.snp.makeConstraints { (make) in
            make.top.equalTo(userNickname.snp.bottom).offset(38)
            make.width.equalTo(userNickname)
            make.height.equalTo(32)
            make.centerX.equalTo(view)
        }
        
        passwordTwice = ErrorTextField()
        passwordTwice.delegate = self
        passwordTwice.placeholder = "再次输入你的密码"
        passwordTwice.detail = "密码与之前输入的不符合!"
        passwordTwice.tag = 21
        let ps2 = UIImageView()
        ps2.image = UIImage(named: "mls_password")
        passwordTwice.leftView = ps2
        passwordTwice.isVisibilityIconButtonEnabled = true
        passwordTwice.visibilityIconButton?.tintColor = Color.blueGrey.base.withAlphaComponent(passwordTwice.isSecureTextEntry ? 0.38 : 0.54)
        setErrorTextFieldStyle(errorTextField: passwordTwice)
        self.vibrancyView.addSubview(passwordTwice)
        passwordTwice.snp.makeConstraints { (make) in
            make.top.equalTo(password.snp.bottom).offset(38)
            make.width.equalTo(userNickname)
            make.height.equalTo(32)
            make.centerX.equalTo(view)
        }
        
        emailField = ErrorTextField()
        emailField.delegate = self
        emailField.placeholder = "输入你的邮箱"
        emailField.detail = "这不是邮箱吧..."
        emailField.tag = 22
        let emailLeftview = UIImageView()
        emailLeftview.image = UIImage(named: "mls_email")
        emailField.leftView = emailLeftview
        setErrorTextFieldStyle(errorTextField: emailField)
        self.vibrancyView.addSubview(emailField)
        emailField.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTwice.snp.bottom).offset(38)
            make.width.equalTo(userNickname)
            make.height.equalTo(32)
            make.centerX.equalTo(view)
        }
        
        
        regisetBtn = FlatButton()
        regisetBtn.setTitle("注 册", for: .normal)
        regisetBtn.backgroundColor = Color.lightGreen.base.withAlphaComponent(0.8)
        regisetBtn.titleColor = Color.grey.lighten5
        
        regisetBtn.isUserInteractionEnabled = true
        regisetBtn.addTarget(self, action: #selector(RegisterNewViewController.registerNew), for: .touchUpInside)
        self.vibrancyView.addSubview(regisetBtn)
        regisetBtn.snp.makeConstraints { (make) in
            make.width.equalTo(userNickname)
            make.height.equalTo(32)
            make.centerX.equalTo(view)
            make.top.equalTo(emailField.snp.bottom).offset(32)
        }
    
        userAgreement = UIButton()
        userAgreement.setTitle("用户协议", for: .normal)
        userAgreement.titleLabel?.textColor = Color.grey.lighten5
        userAgreement.titleLabel?.font = RobotoFont.regular(with: 13)
        userAgreement.isUserInteractionEnabled = true
        userAgreement.addTarget(self, action: #selector(RegisterNewViewController.userAgreementAction), for: .touchUpInside)
        self.vibrancyView.addSubview(userAgreement)
        userAgreement.snp.makeConstraints { (make) in
            make.bottom.equalTo(view).offset(-60)
            make.left.equalTo(view).offset(8)
            make.height.equalTo(25)
            make.width.equalTo(100)

        }
    }

    
    func userAgreementAction(){
        let vc = AppDescriptionViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //set color
    
    func setErrorTextFieldStyle(errorTextField:ErrorTextField){
        errorTextField.leftViewMode = .always
        errorTextField.clearButtonMode = .always
        
        errorTextField.textColor = Color.grey.lighten5.withAlphaComponent(0.8)
    
        errorTextField.detailColor = Color.red.lighten2.withAlphaComponent(0.8)
        
        errorTextField.leftViewNormalColor = Color.grey.lighten2.withAlphaComponent(0.8)
        errorTextField.leftViewActiveColor = Color.lightGreen.base.withAlphaComponent(0.8)
        errorTextField.placeholderActiveColor = Color.lightGreen.base.withAlphaComponent(0.8)
        errorTextField.placeholderNormalColor = Color.grey.lighten2.withAlphaComponent(0.8)
        errorTextField.dividerActiveColor = Color.lightGreen.base.withAlphaComponent(0.8)
        errorTextField.dividerNormalColor = Color.grey.lighten4.withAlphaComponent(0.8)
        
 


    }
    
    func setTextFieldStyle(textField:TextField){
        
        textField.leftViewMode = .always
        textField.clearButtonMode = .always
        
        textField.detailColor = Color.grey.lighten5.withAlphaComponent(0.8)
        textField.textColor = Color.grey.lighten5.withAlphaComponent(0.8)
        
        textField.leftViewNormalColor = Color.grey.lighten2.withAlphaComponent(0.8)
        textField.leftViewActiveColor = Color.lightGreen.base.withAlphaComponent(0.8)
        textField.placeholderActiveColor = Color.lightGreen.base.withAlphaComponent(0.8)
        textField.placeholderNormalColor = Color.grey.lighten2.withAlphaComponent(0.8)
        textField.dividerActiveColor = Color.lightGreen.base.withAlphaComponent(0.8)
        textField.dividerNormalColor = Color.grey.lighten4.withAlphaComponent(0.8)

    }
    
    //textfield delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let errorTF = textField as! ErrorTextField
        switch errorTF.tag {
        case 20:
            if (userNickname.text?.length)! > 16 || (userNickname.text?.length)! < 2{
                userNickname.isErrorRevealed = true
                nicknameReady = false
            }else{
                nicknameReady = true
                userNickname.isErrorRevealed = false
            }
        case 21:
            if password.text == passwordTwice.text{
                passwordReady = true
                passwordTwice.isErrorRevealed = false
            }else{
                passwordTwice.isErrorRevealed = true
                passwordReady = false
            }
        case 22:
            if (emailField.text?.isEmail)!{
                emailField.isErrorRevealed = false
                emailReady = true
            }else{
                emailField.isErrorRevealed = true
                emailReady = false
            }
        default:
            break
        }
        
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let errorTF = textField as! ErrorTextField
        switch errorTF.tag {
        case 20:
            if (userNickname.text?.length)! > 16 || (userNickname.text?.length)! < 2{
                errorTF.isErrorRevealed = true
                nicknameReady = false
            }else{
                userNickname.isErrorRevealed = false
                nicknameReady = true
            }

        case 21:
            if password.text == passwordTwice.text{
                passwordReady = true
                passwordTwice.isErrorRevealed = false
            }else{
                passwordTwice.isErrorRevealed = true
                passwordReady = false
            }
        case 22:
            if (emailField.text?.isEmail)!{
                emailReady = true
                emailField.isErrorRevealed = false
            }else{
                emailField.isErrorRevealed = true
                emailReady = false
            }
        default:
            break
        }

    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        let errorTF = textField as! ErrorTextField
        switch errorTF.tag {
        case 20:
            if (userNickname.text?.length)! > 16 || (userNickname.text?.length)! < 2{
                errorTF.isErrorRevealed = true
                nicknameReady = false
                
            }else{
                userNickname.isErrorRevealed = false
                nicknameReady = true
            }

        case 21:
            if password.text == passwordTwice.text{
                passwordReady = true
                passwordTwice.isErrorRevealed = false
            }else{
                passwordTwice.isErrorRevealed = true
                passwordReady = false
            }
        case 22:
            if (emailField.text?.isEmail)!{
                emailReady = true
                emailField.isErrorRevealed = false
            }else{
                emailField.isErrorRevealed = true
                emailReady = false
            }
        default:
            break
        }

        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let errorTF = textField as! ErrorTextField
        switch errorTF.tag {
        case 20:
            if (userNickname.text?.length)! > 16 || (userNickname.text?.length)! < 2{
                userNickname.isErrorRevealed = true
                nicknameReady = false
            }else{
                userNickname.isErrorRevealed = false
                nicknameReady = true
            }

        case 21:
            if password.text == passwordTwice.text{
                passwordReady = true
                passwordTwice.isErrorRevealed = false
            }else{
                passwordTwice.isErrorRevealed = true
                passwordReady = false
            }
        case 22:
            if (emailField.text?.isEmail)!{
                emailReady = true
                emailField.isErrorRevealed = false
            }else{
                emailField.isErrorRevealed = true
                emailReady = false
            }
        default:
            break
        }

        return true
    }
 
 
    
}


