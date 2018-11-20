//
//  WDCommentTableViewCell.swift
//  tu
//
//  Created by Rorschach on 2017/3/17.
//  Copyright © 2017年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import Material
import SnapKit

class WDCommentTableViewCell: TableViewCell {


    var userAvatar:UIImageView!
    var userNickname:UILabel!
    var commentLabel:UILabel!
    var floorNum:UILabel!
    var dateLabel:UILabel!
    var delegate:CommentCellUserAvatarDelegate!
    override func prepare() {
        super.prepare()
        
        for view in contentView.subviews{
            view.removeFromSuperview()
        }
        
        userAvatar = UIImageView()
        userAvatar.isUserInteractionEnabled = true
        userAvatar.layer.cornerRadius = 25
        userAvatar.contentMode = .scaleAspectFill
        userAvatar.clipsToBounds = true
        contentView.addSubview(userAvatar)
        userAvatar.snp.makeConstraints { (make) in
            make.top.left.equalTo(contentView).offset(8)
            make.width.height.equalTo(50)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(WDCommentTableViewCell.userAvatarTapped))
        userAvatar.addGestureRecognizer(tap)
        
        
        userNickname = UILabel()
        userNickname.font = RobotoFont.regular(with: 14)
        userNickname.textAlignment = .left
        contentView.addSubview(userNickname)
        userNickname.snp.makeConstraints { (make) in
            make.left.equalTo(userAvatar.snp.right).offset(10)
            make.top.equalTo(userAvatar.snp.top)
            make.height.equalTo(20)
            make.width.equalTo(200)
        }
        
        floorNum = UILabel()
        floorNum.font = RobotoFont.regular(with: 12)
        floorNum.textColor = Color.blueGrey.base
        floorNum.textAlignment = .right
        contentView.addSubview(floorNum)
        floorNum.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-5)
            make.top.equalTo(userNickname.snp.top)
            make.height.equalTo(20)
            make.width.equalTo(100)
        }

        dateLabel = UILabel()
        dateLabel.font = RobotoFont.regular(with: 12)
        dateLabel.textColor = Color.blueGrey.base
        dateLabel.textAlignment = .right
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.right.equalTo(contentView).offset(-5)
            make.bottom.equalTo(contentView).offset(-5)
            make.width.equalTo(SCREEN_WIDTH)
        }
        
        commentLabel = UILabel()
        commentLabel.font = RobotoFont.regular(with: 15)
        commentLabel.numberOfLines = 0
        contentView.addSubview(commentLabel)
        commentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(userAvatar.snp.right).offset(8)
            make.top.equalTo(userNickname.snp.bottom).offset(5)
            make.right.equalTo(contentView).offset(-5)
            make.bottom.equalTo(contentView).offset(-25)
        }
        


    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    func userAvatarTapped(){
        delegate.avatarTapped(avatar: userAvatar)
    }

}

protocol CommentCellUserAvatarDelegate {
    func avatarTapped(avatar:UIImageView)
}
