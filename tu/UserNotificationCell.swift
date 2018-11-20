//
//  UserNotificationCell.swift
//  tu
//
//  Created by Rorschach on 2017/3/30.
//  Copyright © 2017年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import Material
import SnapKit
class UserNotificationCell: TableViewCell {

    var rightArrow:IconButton!
    var leftIcon:IconButton!
    var title:UILabel!
    
    override func prepare() {
        super.prepare()
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        prepareView()
    }

    func prepareView(){
        
        leftIcon = IconButton()
        leftIcon.tintColor = Color.lightGreen.base
        leftIcon.isUserInteractionEnabled = false
        contentView.addSubview(leftIcon)
        leftIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(5)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        
        
        rightArrow = IconButton()
        rightArrow.image = UIImage(named: "mls_Forward")
        rightArrow.tintColor = Color.grey.base
        rightArrow.isUserInteractionEnabled = false
        contentView.addSubview(rightArrow)
        rightArrow.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-5)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }

        title = UILabel()
        title.font = RobotoFont.regular(with: 17)
        title.textColor = Color.grey.base
        title.textAlignment = .left
        contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.centerY.equalTo(leftIcon)
            make.left.equalTo(leftIcon.snp.right).offset(5)
            make.right.equalTo(rightArrow.snp.left).offset(5)
            make.height.equalTo(30)
        }
        
        
    }
    
    
}
