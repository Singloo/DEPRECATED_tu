//
//  SoldWorkRepresentationCollectionViewCell.swift
//  tu
//
//  Created by Rorschach on 2017/3/29.
//  Copyright © 2017年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import Material
import SnapKit
import Popover_OC


class SoldWorkRepresentationCollectionViewCell: CollectionViewCell {

    var presentedWork:UIImageView!
    
    var price:UILabel!
    var pricePre:UILabel!
    var moreBtn:IconButton!
    let blurEffect = UIVisualEffectView(effect: UIBlurEffect(style: .light))

    var delegate:MoreBtnActionDelegate!
    
    override func prepare() {
        super.prepare()
        prepareView()
    }
    
    func prepareView(){
        contentView.clipsToBounds = true
        self.presentedWork = UIImageView()
        presentedWork.clipsToBounds = true
        presentedWork.isUserInteractionEnabled = true
        contentView.layout(presentedWork).edges()
        
        
        let bkView = UIView()
        bkView.backgroundColor = Color.grey.base.withAlphaComponent(0.7)
        presentedWork.addSubview(bkView)
        bkView.snp.makeConstraints { (make) in
            make.bottom.equalTo(presentedWork)
            make.left.equalTo(presentedWork.snp.left)
            make.right.equalTo(presentedWork.snp.right)
            make.height.equalTo(30)
        }
        
        bkView.addSubview(blurEffect)
        blurEffect.isUserInteractionEnabled = true
        blurEffect.snp.makeConstraints { (make) in
            make.bottom.equalTo(presentedWork)
            make.left.equalTo(presentedWork.snp.left)
            make.right.equalTo(presentedWork.snp.right)
            make.height.equalTo(30)
        }
        
        
        pricePre = UILabel()
        pricePre.text = "成交价格:"
        pricePre.font = RobotoFont.regular(with: 12)
        pricePre.textAlignment = .left
        pricePre.textColor = Color.white
        blurEffect.addSubview(pricePre)
        pricePre.snp.makeConstraints { (make) in
            make.centerY.equalTo(blurEffect)
            make.left.equalTo(blurEffect).offset(5)
            make.width.equalTo(55)
            make.height.equalTo(20)
        }
        
        price = UILabel()
        price.font = RobotoFont.regular(with: 15)
        price.textAlignment = .left
        price.textColor = Color.red.lighten3

        blurEffect.addSubview(price)
        price.snp.makeConstraints { (make) in
            make.centerY.equalTo(pricePre)
            make.left.equalTo(pricePre.snp.right).offset(0)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        moreBtn = IconButton(image: Icon.cm.moreVertical, tintColor: Color.grey.lighten4.withAlphaComponent(0.8))
        moreBtn.isUserInteractionEnabled = true
        moreBtn.isEnabled = true
        moreBtn.addTarget(self, action: #selector(SoldWorkRepresentationCollectionViewCell.moreBtnAction(sender:)), for: .touchUpInside)
        blurEffect.addSubview(moreBtn)
        moreBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(blurEffect)
            make.right.equalTo(blurEffect)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }

    }
    
    func moreBtnAction(sender:IconButton){
        let popView = PopoverView()
        let shareAction = PopoverAction(title: "分享") { (action) in
            self.delegate.shareAction(btn: sender)
        }
        let deleteAction = PopoverAction(title: "举报") { (action) in
            self.delegate.deleteAction(btn: sender)
        }
        popView.style = .dark
        popView.show(to: sender, with: [shareAction!,deleteAction!])

    }

    
}
