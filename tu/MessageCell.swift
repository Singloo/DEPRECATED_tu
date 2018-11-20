//
//  MessageCell.swift
//  tu
//
//  Created by Rorschach on 2017/4/5.
//  Copyright © 2017年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import Material

class MessageCell: TableViewCell {

    var title:UILabel!
    var detail:UILabel!
    
    var rightIcon:UIImageView!
    
    
    override func prepare() {
        super.prepare()
        
        for view in contentView.subviews{
            view.removeFromSuperview()
        }
        
        prepareView()
    }
    
    func prepareView() {
        rightIcon = UIImageView()
        rightIcon.image = UIImage(named: "mls_Forward")
        rightIcon.contentMode = .scaleAspectFill
        rightIcon.clipsToBounds = true
        contentView.addSubview(rightIcon)
        rightIcon.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-10)
            make.centerY.equalTo(contentView)
            make.width.equalTo(25)
            make.height.equalTo(25)
            
        }
        
        title = UILabel()
        title.font = RobotoFont.regular(with: 16)
        title.textColor = Color.blueGrey.base
        title.textAlignment = .left
        contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView).offset(-10)
            make.centerX.equalTo(contentView).offset(-20)
            make.height.equalTo(20)
            make.right.equalTo(rightIcon.snp.left).offset(-20)
        }
        
        detail = UILabel()
        detail.font = RobotoFont.regular(with: 13)
        detail.textColor = Color.blueGrey.lighten3
        detail.textAlignment = .left
        contentView.addSubview(detail)
        detail.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView).offset(10)
            make.left.equalTo(title.snp.left)
            make.height.equalTo(20)
            make.right.equalTo(rightIcon.snp.left).offset(-20)
        }
    }
}
