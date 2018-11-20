//
//  CoinMailVCCell.swift
//  tu
//
//  Created by Rorschach on 2017/4/9.
//  Copyright © 2017年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import Material
import SnapKit

class CoinMailVCCell: TableViewCell {

    var title:UITextView!
    override func prepare() {
        super.prepare()
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        
        prepareView()
    }

    
    
    func prepareView(){
        title = UITextView()
        title.isEditable = false
        title.textAlignment = .center
        title.font = RobotoFont.light(with: 16)
        title.textColor = Color.grey.base
        self.contentView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(10)
            make.right.equalTo(contentView).offset(-10)
            make.top.equalTo(contentView).offset(50)
            make.bottom.equalTo(contentView)
        }
        

    }
    
}
