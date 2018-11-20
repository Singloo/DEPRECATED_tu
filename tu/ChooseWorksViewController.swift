//
//  ChooseWorksViewController.swift
//  tu
//
//  Created by Rorschach on 2017/2/11.
//  Copyright © 2017年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import AVOSCloud
import MJRefresh
import Material
import SwifterSwift

class ChooseWorksViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    var collectionView: UICollectionView!

    
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)

    var dataArr = NSMutableArray()
    var imgFile:AVFile = AVFile()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.extendedLayoutIncludesOpaqueBars = true

        self.view.backgroundColor = UIColor.white

        self.setCollectionView()
        self.headRefresh()


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        UIApplication.shared.statusBarStyle = .default
        self.navigationBar?.setColors(background: Color.grey.lighten4, text: Color.grey.darken3)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let width:CGFloat = (SCREEN_WIDTH - 3)/2
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width, height: width)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Color.grey.lighten3
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.register(ChooseWorksCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.collectionView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(ChooseWorksViewController.headRefresh))
        self.view.layout(collectionView).edges()
        self.collectionView.reloadData()
        
    }
    
    func headRefresh() {
        let query = AVQuery(className: "UserWorks")
        query.whereKey("user", equalTo: AVUser.current()!)
        query.whereKey("saleable", equalTo: true)
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground { (result, error) in
            if error == nil{
                self.collectionView?.mj_header.endRefreshing()
                self.dataArr.removeAllObjects()
                self.dataArr.addObjects(from: result!)
                self.collectionView?.reloadData()
            }else{
                let err = error as! NSError
                print("\(err.code)")
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChooseWorksCollectionViewCell
        let object = self.dataArr[indexPath.row] as! AVObject
        let file = object["userWork"] as! AVFile
        let url = URL(string: file.url!)
        cell.userWorks.sd_setImage(with: url)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = InputWorkInfoViewController()
        let object = self.dataArr[indexPath.row] as! AVObject
        
        vc.imgFile = object["userWork"] as? AVFile
        vc.selectedWork = object
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

