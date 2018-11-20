//
//  ChooseWorksCollectionViewCell.swift
//  tu
//
//  Created by Rorschach on 2017/2/11.
//  Copyright © 2017年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import Material

class ChooseWorksCollectionViewCell: UICollectionViewCell {

    var userWorks: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        for view in self.contentView.subviews{
            view.removeFromSuperview()
        }
        
        self.userWorks = UIImageView()
        self.userWorks.clipsToBounds = true
        self.contentView.layout(userWorks).edges()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
