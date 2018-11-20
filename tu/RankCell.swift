//
//  RankCell.swift
//  tu
//
//  Created by Rorschach on 2017/4/4.
//  Copyright © 2017年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import Material
import SnapKit

class RankCell: TableViewCell {
    var leftIcon:IconButton!
    var leftImage:UIImageView!
    var leftLabel:UILabel!
    var title:UILabel!
    var detail:UILabel!

    override func prepare() {
        super.prepare()
        for view in contentView.subviews{
            view.removeFromSuperview()
        }
        prepareView()

    }

    func prepareView(){
        leftIcon = IconButton()
        contentView.addSubview(leftIcon)
        leftIcon.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(10)
            make.centerY.equalTo(contentView)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        
        leftImage = UIImageView()
        leftImage.contentMode = .scaleAspectFill
        leftImage.layer.borderWidth = 0.5
        leftImage.layer.borderColor = Color.grey.lighten2.cgColor
        leftImage.clipsToBounds = true
        contentView.addSubview(leftImage)
        leftImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(leftIcon.snp.right).offset(20)
            make.height.equalTo(56)
            make.width.equalTo(56)
        }
        
        leftLabel = UILabel()
        leftLabel.textColor = Color.grey.darken3
        leftLabel.textAlignment = .left
        leftLabel.font = RobotoFont.bold(with: 12)
        contentView.addSubview(leftLabel)
        leftLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(30)
        }
        

        
        title = UILabel()
        title.textColor = Color.grey.darken3
        title.font = RobotoFont.regular(with: 17)
        title.textAlignment = .left
        contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.top.equalTo(leftImage.snp.top)
            make.left.equalTo(leftImage.snp.right).offset(10)
            make.right.equalTo(contentView).offset(-10)
            make.height.equalTo(20)
        }
        
        detail = UILabel()
        detail.textColor = Color.grey.base
        detail.font = RobotoFont.regular(with: 14)
        detail.textAlignment = .left
        contentView.addSubview(detail)
        detail.snp.makeConstraints { (make) in
            make.bottom.equalTo(leftImage.snp.bottom)
            make.left.equalTo(title.snp.left)
            make.height.equalTo(20)
            make.right.equalTo(contentView).offset(-10)
        }
    }
}
