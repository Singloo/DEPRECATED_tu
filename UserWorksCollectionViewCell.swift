//
//  UserWorksCollectionViewCell.swift
//  tu
//
//  Created by Rorschach on 2016/12/4.
//  Copyright © 2016年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import Material
import SnapKit
import Popover_OC

protocol MoreBtnActionDelegate {
    func shareAction(btn:IconButton)
    func deleteAction(btn:IconButton)
}

class UserWorksCollectionViewCell: CollectionViewCell {
    
    var userWorks: UIImageView!
    let blurEffect = UIVisualEffectView(effect: UIBlurEffect(style: .light))

    var delegate:MoreBtnActionDelegate!
    var moreIcon:IconButton!
    override func prepare() {
        super.prepare()
        for view in contentView.subviews{
            view.removeFromSuperview()
        }
        
        prepareView()
    }
    
    func prepareView(){
        self.userWorks = UIImageView()
        self.userWorks.clipsToBounds = true
        userWorks.isUserInteractionEnabled = true
        self.contentView.layout(userWorks).edges()

        let bkView = UIView()
        bkView.backgroundColor = Color.grey.base.withAlphaComponent(0.7)
        userWorks.addSubview(bkView)
        bkView.snp.makeConstraints { (make) in
            make.bottom.equalTo(userWorks)
            make.left.equalTo(userWorks.snp.left)
            make.right.equalTo(userWorks.snp.right)
            make.height.equalTo(30)
        }

        
        bkView.addSubview(blurEffect)
        blurEffect.isUserInteractionEnabled = true
        blurEffect.snp.makeConstraints { (make) in
            make.bottom.equalTo(userWorks)
            make.left.equalTo(userWorks.snp.left)
            make.right.equalTo(userWorks.snp.right)
            make.height.equalTo(30)
        }

        moreIcon = IconButton(image: Icon.cm.moreVertical, tintColor: Color.grey.lighten4.withAlphaComponent(0.8))
        moreIcon.isUserInteractionEnabled = true
        moreIcon.isEnabled = true
        moreIcon.addTarget(self, action: #selector(UserWorksCollectionViewCell.moreIconAction(sender:)), for: .touchUpInside)
        blurEffect.addSubview(moreIcon)
        moreIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(blurEffect)
            make.right.equalTo(blurEffect)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
    }
    
    func moreIconAction(sender:IconButton){
        let popView = PopoverView()
        let shareAction = PopoverAction(title: "分享") { (action) in
            self.delegate.shareAction(btn: sender)
        }
        let deleteAction = PopoverAction(title: "删除") { (action) in
            self.delegate.deleteAction(btn: sender)
        }
        popView.style = .dark
        popView.show(to: sender, with: [shareAction!,deleteAction!])
        
    }
}
