//
//  HomeDetailWorkTableViewCell.swift
//  tu
//
//  Created by Rorschach on 2017/3/6.
//  Copyright © 2017年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import Material
import AVOSCloud
import SDWebImage
import Popover_OC

protocol HomeDetailCellButtonTappedActionDelegate {
    func loveBtnTapped(sender:IconButton,loveNum:UILabel)
    func purchaseBtnTapped(sender:FlatButton)
    func postImgTapped(sender:UIImageView)
    func shareAction(btn:IconButton)
    func deleteAction(btn:IconButton)
}
class HomeDetailWorkTableViewCell: TableViewCell {
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var postContent: UILabel!
    @IBOutlet weak var toolbar: UIView!
    @IBOutlet weak var bottomBar: UIView!
    @IBOutlet weak var userAvatar: UIImageView!
    
    @IBOutlet weak var moreBtn: IconButton!

//    var purchaseBtn:Button!
    
    @IBOutlet weak var loveBtn: IconButton!
    @IBOutlet weak var loveNum: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var purchaseBtn: FlatButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var userNickname: UILabel!
    
    var delegate:HomeDetailCellButtonTappedActionDelegate!
    
    override func layoutSubviews() {
        super.layoutSubviews()

        userAvatar.contentMode = .scaleAspectFill
        userAvatar.clipsToBounds = true
        
        
        postImg.contentMode = .scaleAspectFill
        postImg.clipsToBounds = true
        postImg.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(HomeDetailWorkTableViewCell.postImgAction))
        postImg.addGestureRecognizer(tap)
        
        postContent.backgroundColor = Color.white
        
        
        userNickname.font = RobotoFont.regular(with: 14)

        prepareToolbar()
        prepareBottombar()
    }

    
    override func prepare() {
        super.prepare()

    }
    
    func prepareToolbar(){
        moreBtn.image = Icon.cm.moreVertical
        moreBtn.tintColor = Color.blueGrey.base
        moreBtn.isUserInteractionEnabled = true
        moreBtn.addTarget(self, action: #selector(HomeDetailWorkTableViewCell.moreAction(sender:)), for: .touchUpInside)
//        toolbar.rightViews = [moreBtn]
//        toolbar.dividerAlignment = .top
//        toolbar.dividerColor = Color.grey.lighten3
        
        postTitle.font = RobotoFont.bold(with: 16)
        postTitle.textColor = Color.blueGrey.darken3
        postTitle.textAlignment = .left
    }
    
    func prepareBottombar(){

        loveBtn.image = Icon.favorite
       // loveBtn.tintColor = Color.blueGrey.base
        loveBtn.isEnabled = true
        loveBtn.isUserInteractionEnabled = true
        loveBtn.addTarget(self, action: #selector(HomeDetailWorkTableViewCell.loveAction), for: .touchUpInside)
        
        
        loveNum.font = RobotoFont.regular(with: 12)
        loveNum.textColor = Color.blueGrey.base
        loveNum.textAlignment = .left
        
        dateLabel.font = RobotoFont.regular(with: 12)
        dateLabel.textColor = Color.blueGrey.base
        dateLabel.textAlignment = .center
        
        
        purchaseBtn.titleColor = Color.white

        purchaseBtn.isUserInteractionEnabled = true

        purchaseBtn.addTarget(self, action: #selector(HomeDetailWorkTableViewCell.purchaseAction), for: .touchUpInside)
        
        priceLabel.font = RobotoFont.regular(with: 15)
        priceLabel.textColor = Color.red.lighten1
        priceLabel.textAlignment = .right
        
    }
    
    func postImgAction() {
    
        delegate.postImgTapped(sender:postImg)
    }
    
    func moreAction(sender:IconButton) {
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
    
    func loveAction() {
        delegate.loveBtnTapped(sender: loveBtn, loveNum: loveNum)
        
    }
    
    func purchaseAction() {
        delegate.purchaseBtnTapped(sender: purchaseBtn)
        
    }
    
    
    
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
