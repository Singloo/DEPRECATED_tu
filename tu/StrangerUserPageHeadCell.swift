//
//  StrangerUserPageHeadCell.swift
//  tu
//
//  Created by Rorschach on 2017/4/24.
//  Copyright © 2017年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import Material
import AVOSCloud
import SDWebImage
import SKPhotoBrowser

class StrangerUserPageHeadCell: TableViewCell {

    var collectionView:UICollectionView!
    var dataArr = NSMutableArray()
    var images = [SKPhoto]()
    
    var delegate:strangerUserWorkTappedDelegate!
    override func prepare() {
        super.prepare()

        let layout = UICollectionViewFlowLayout()
        let width:CGFloat = (SCREEN_WIDTH - 3)/2
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width, height: width)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ChooseWorksCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = Color.grey.lighten3
        
        self.contentView.layout(collectionView).edges()
        collectionView.reloadData()
        
    }
}

extension StrangerUserPageHeadCell:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChooseWorksCollectionViewCell
        let object = self.dataArr[indexPath.row] as! AVObject
        let file = object["userWork"] as! AVFile
        cell.userWorks.sd_setImage(with: URL(string: file.url!))
        let photo = SKPhoto.photoWithImage(UIImage(data: file.getData()!)!)
        images.append(photo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {


        self.delegate.cellTapped(index: indexPath.row, images: images)


    }
}

protocol strangerUserWorkTappedDelegate {
    func cellTapped(index:Int,images:[SKPhoto])
}


