//
//  UserView.swift
//  tu
//
//  Created by Rorschach on 2017/4/5.
//  Copyright © 2017年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import Material

class UserView: UIView {

    var bkImage:UIImageView!
    var blurView:UIVisualEffectView!
    var userAvatar:UIImageView!

    var username:UILabel!
    var usercoin:UILabel!
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareView() {
        bkImage = UIImageView()
        bkImage.contentMode = .scaleAspectFill
        bkImage.clipsToBounds = true
        self.addSubview(bkImage)
        bkImage.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(0)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(200)
        }
        
        let bkView = UIView()
        bkView.backgroundColor = Color.grey.base.withAlphaComponent(0.4)
        self.addSubview(bkView)
        bkView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(0)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(200)
        }

        
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        self.addSubview(blurView)
        blurView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(0)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(200)
        }

        
        userAvatar = UIImageView()
        userAvatar.contentMode = .scaleAspectFill
        userAvatar.layer.cornerRadius = 30
        userAvatar.layer.borderWidth = 1
        userAvatar.layer.borderColor = UIColor.white.cgColor
        userAvatar.layer.masksToBounds = true
        self.addSubview(userAvatar)
        userAvatar.snp.makeConstraints { (make) in
            make.centerY.equalTo(bkImage).offset(-20)
            make.centerX.equalTo(bkImage)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        
        username = UILabel()
        username.font = RobotoFont.regular(with: 17)
        username.textColor = Color.grey.lighten4
        username.textAlignment = .right
        self.addSubview(username)
        username.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.left).offset(SCREEN_WIDTH/4)
            make.top.equalTo(userAvatar.snp.bottom).offset(10)
            make.width.equalTo(SCREEN_WIDTH/3)
            make.height.equalTo(20)
        }
        
        usercoin = UILabel()
        usercoin.font = RobotoFont.regular(with: 17)
        usercoin.textColor = Color.grey.lighten4
        usercoin.textAlignment = .left
        self.addSubview(usercoin)
        usercoin.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.right).offset(-SCREEN_WIDTH/4)
            make.centerY.equalTo(username)
            make.height.equalTo(20)
            make.width.equalTo(SCREEN_WIDTH/3)
        }

    }

}
