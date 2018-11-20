//
//  WDHeaderTableViewCell.swift
//  tu
//
//  Created by Rorschach on 2017/3/17.
//  Copyright © 2017年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import Material
import SnapKit
import SKPhotoBrowser
import Popover_OC

protocol HeaderViewButtonTappedDelegate {
    func postWorkTapped()
    func purchaseBtnTapped(sender:FlatButton)
    func loveBtnTapped(sender:IconButton,loveNum:UILabel)
}

class WDHeaderTableViewCell: TableViewCell {


    var userAvatar:UIImageView!
    var userNickname:UILabel!
    
    var postTitle:UILabel!
    var postWork:UIImageView!
    var postContent:UILabel!

    var loveBtn:IconButton!
    var loveNum:UILabel!
    var dateLabel:UILabel!
    
    
    var price:UILabel!
    var purchaseBtn:FlatButton!
    
    var delegate:HeaderViewButtonTappedDelegate!
    
    override func prepare() {
        super.prepare()
        
        for view in contentView.subviews{
            view.removeFromSuperview()
        }
        
        prepareUserAbout()
        preparePostAbout()
        preparePurchaseAbout()

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func prepareUserAbout() {
        userAvatar = UIImageView()
        userAvatar.layer.cornerRadius = 25
        userAvatar.contentMode = .scaleAspectFill
        userAvatar.clipsToBounds = true
        contentView.addSubview(userAvatar)
        userAvatar.snp.makeConstraints { (make) in
            make.top.left.equalTo(contentView).offset(8)
            make.width.height.equalTo(50)
            
        }
        
        userNickname = UILabel()
        userNickname.font = RobotoFont.regular(with: 14)
        userNickname.textAlignment = .left
        contentView.addSubview(userNickname)
        userNickname.snp.makeConstraints { (make) in
            make.top.equalTo(userAvatar.snp.top)
            make.left.equalTo(userAvatar.snp.right).offset(8)
            make.width.equalTo(120)
            make.height.equalTo(20)
        }
        
    }
    
    func preparePostAbout() {
        postTitle = UILabel()
        postTitle.font = RobotoFont.bold(with: 16)
        postTitle.textColor = Color.blueGrey.darken3
        postTitle.textAlignment = .left
        contentView.addSubview(postTitle)
        postTitle.snp.makeConstraints { (make) in
            make.bottom.equalTo(userAvatar.snp.bottom)
            make.left.equalTo(userNickname.snp.left)
            make.height.equalTo(20)
            make.right.equalTo(contentView).offset(-30)
        }
        
        postWork = UIImageView()
        postWork.contentMode = .scaleAspectFill
        postWork.clipsToBounds = true
        postWork.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(WDHeaderTableViewCell.showPostWork))
        postWork.addGestureRecognizer(tap)
        contentView.addSubview(postWork)
        postWork.snp.makeConstraints { (make) in
            make.left.equalTo(userAvatar.snp.centerX)
            make.top.equalTo(postTitle.snp.bottom).offset(8)
            make.width.equalTo(SCREEN_WIDTH - 58)
            make.height.equalTo(SCREEN_WIDTH - 58)
        }
        
        postContent = UILabel()
        postContent.font = RobotoFont.regular(with: 14)
        postContent.numberOfLines = 0
        contentView.addSubview(postContent)
        postContent.snp.makeConstraints { (make) in
            make.top.equalTo(postWork.snp.bottom).offset(2)
            make.left.equalTo(postWork.snp.left)
            make.right.equalTo(contentView).offset(-10)
            make.bottom.equalTo(contentView).offset(-33)
        }
    }
    
    func preparePurchaseAbout() {
        purchaseBtn = FlatButton()
        purchaseBtn.title = "购买"
        purchaseBtn.titleColor = Color.white
        purchaseBtn.titleLabel?.font = RobotoFont.regular(with: 15)
        purchaseBtn.backgroundColor = Color.lightGreen.base
        purchaseBtn.isUserInteractionEnabled = true
        purchaseBtn.isEnabled = true
        purchaseBtn.addTarget(self, action: #selector(WDHeaderTableViewCell.purchaseAction), for: .touchUpInside)
        contentView.addSubview(purchaseBtn)
        purchaseBtn.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-5)
            make.bottom.equalTo(contentView.snp.bottom).offset(-3)
            make.height.equalTo(21)
            make.width.equalTo(50)
        }
        
        price = UILabel()
        price.font = RobotoFont.regular(with: 15)
        price.textColor = Color.red.lighten1
        price.textAlignment = .right
        contentView.addSubview(price)
        price.snp.makeConstraints { (make) in
            make.right.equalTo(purchaseBtn.snp.left).offset(-2)
            make.centerY.equalTo(purchaseBtn)
            make.height.equalTo(21)
            make.width.equalTo(100)
        }
        
        loveBtn = IconButton()
        loveBtn.image = Icon.favorite
        loveBtn.isEnabled = true
        loveBtn.isUserInteractionEnabled = true
        loveBtn.addTarget(self, action: #selector(WDHeaderTableViewCell.loveAction), for: .touchUpInside)
        contentView.addSubview(loveBtn)
        loveBtn.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(8)
            make.centerY.equalTo(purchaseBtn)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        loveNum = UILabel()
        loveNum.font = RobotoFont.regular(with: 12)
        loveNum.textColor = Color.blueGrey.base
        loveNum.textAlignment = .left
        contentView.addSubview(loveNum)
        loveNum.snp.makeConstraints { (make) in
            make.left.equalTo(loveBtn.snp.right)
            make.centerY.equalTo(purchaseBtn)
            make.width.equalTo(40)
            make.height.equalTo(21)
        }
        
        dateLabel = UILabel()
        dateLabel.font = RobotoFont.regular(with: 12)
        dateLabel.textColor = Color.blueGrey.base
        dateLabel.textAlignment = .center
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(purchaseBtn)
            make.width.equalTo(125)
            make.height.equalTo(21)
        }
    }
    
    
    func loveAction(){
        delegate.loveBtnTapped(sender: loveBtn, loveNum: loveNum)
    }
    
    func showPostWork() {
        delegate.postWorkTapped()
        
    }
    
    func purchaseAction() {
        delegate.purchaseBtnTapped(sender: self.purchaseBtn)
    }
}
