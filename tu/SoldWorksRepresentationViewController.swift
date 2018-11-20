//
//  SoldWorksRepresentationViewController.swift
//  tu
//
//  Created by Rorschach on 2017/3/29.
//  Copyright © 2017年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import Material
import AVOSCloud
import SDWebImage
import SwifterSwift
import SVProgressHUD
import MJRefresh
class SoldWorksRepresentationViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource{

    var collectionView:UICollectionView!
    var dataArr = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar?.setColors(background: Color.lightGreen.base, text: UIColor.white)
        prepareCollectionView()
        headRefreshData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        self.tabBarController?.tabBar.isHidden = false
//        self.navigationBar?.setColors(background: Color.lightGreen.base, text: Color.grey.lighten4)
        self.navigationBar?.setBackgroundImage(UIImage(named: "navigationBK"), for: .default)
        self.navigationBar?.tintColor = Color.white

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func refresh(_ sender: Any) {
        self.collectionView.scrollsToTop = true
        self.headRefreshData()
    }
    
    func headRefreshData(){
        SVProgressHUD.show()
        let query = AVQuery(className: "WorksOnSale")
        query.whereKey("hadSale", equalTo: true)
        query.order(byDescending: "upDatedAt")
        query.limit = 20
        query.findObjectsInBackground { (result, error) in
            if error == nil{
                self.collectionView.mj_header.endRefreshing()
                self.dataArr.removeAllObjects()
                self.dataArr.addObjects(from: result!)
                self.collectionView.reloadData()
                SVProgressHUD.dismiss()
            }else{
                let e1 = error as! NSError
                SVProgressHUD.show(nil, status: "网络出现了一点问题....\(e1)")
                SVProgressHUD.dismiss(withDelay: 1)
            }
        }
    }
    
    func footerRefresh(){
        SVProgressHUD.show()
        let query = AVQuery(className: "WorksOnSale")
        query.whereKey("hadSale", equalTo: true)
        query.order(byDescending: "upDatedAt")
        query.limit = 20
        query.skip = self.dataArr.count
        query.findObjectsInBackground { (result, error) in
            if error == nil{
                self.collectionView.mj_footer.endRefreshing()
                self.dataArr.addObjects(from: result!)
                self.collectionView.reloadData()
                SVProgressHUD.dismiss()
            }else{
                let e1 = error as! NSError
                SVProgressHUD.show(nil, status: "网络出现了一点问题....\(e1)")
                SVProgressHUD.dismiss(withDelay: 1)
            }
        }

    }

    func prepareCollectionView(){
        let layout = UICollectionViewFlowLayout()
        let width:CGFloat = (SCREEN_WIDTH - 3)/2
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width, height: width)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SoldWorkRepresentationCollectionViewCell.self, forCellWithReuseIdentifier: "presentationCell")

        collectionView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(SoldWorksRepresentationViewController.headRefreshData))
        collectionView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(SoldWorksRepresentationViewController.footerRefresh))
        self.view.layout(collectionView).edges()
        collectionView.reloadData()
    }
    
    
    //config cv
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "presentationCell", for: indexPath) as! SoldWorkRepresentationCollectionViewCell
        let object = self.dataArr[indexPath.row] as! AVObject
        let file = object["workFile"] as! AVFile
        let price = object["workPrice"] as! Int
        cell.delegate = self
        cell.presentedWork.sd_setImage(with: URL(string: file.url!))
        cell.price.text = "\(price)"
        cell.moreBtn.tag = indexPath.row
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let object = self.dataArr[indexPath.row] as! AVObject
        let vc = WorkDetailCommentViewController()
        vc.headObject = object
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SoldWorksRepresentationViewController:MoreBtnActionDelegate{
    func shareAction(btn: IconButton) {
        let object = self.dataArr[btn.tag] as! AVObject
        
        let workFile = object["workFile"] as! AVFile
        let workPrice = object["workPrice"] as! Int
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: "同学,来玩呀,点进来嘛~(*￣3￣)╭",
                                          images : UIImage(data: workFile.getData()!),
                                          url : URL(string: "https://itunes.apple.com/us/app/涂了个鸭/id1239162142?l=zh&ls=1&mt=8"),
                                          title : "这幅画居然卖了 \(workPrice)! w(ﾟДﾟ)w",
            type : SSDKContentType.auto)
        
        SSUIShareActionSheetStyle.setShareActionSheetStyle(.simple)
        
        ShareSDK.showShareActionSheet(view, items: nil, shareParams: shareParames) { (state, platformType, userData, contentEntity, error, end) -> Void in
            
            
            switch state{
                
            case SSDKResponseState.success:
                if AVUser.current() != nil{
                    let query = AVQuery(className: "UserAccount")
                    query.whereKey("user", equalTo: AVUser.current())
                    query.findObjectsInBackground({ (result, error) in
                        if error == nil{
                            let object = result?[0] as! AVObject
                            object.incrementKey("userCoin", byAmount: 5)
                            object.saveInBackground()
                        }
                    })
                    SVProgressHUD.show(nil, status: "分享成功,+5 涂币")
                    SVProgressHUD.dismiss(withDelay: 0.8)
                }else{
                    SVProgressHUD.show(nil, status: "感谢你的分享")
                    SVProgressHUD.dismiss(withDelay: 0.8)
                }
            case SSDKResponseState.fail:
                SVProgressHUD.show(nil, status: "分享失败")
                SVProgressHUD.dismiss(withDelay: 0.8)
            case SSDKResponseState.cancel:
                SVProgressHUD.show(nil, status: "分享取消")
                SVProgressHUD.dismiss(withDelay: 0.8)
                
            default:
                break
            }
        }

    }
    
    func deleteAction(btn: IconButton) {
        let object = self.dataArr[btn.tag] as! AVObject
        let vc = ReportViewController()
        vc.reportedObject = object
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)

    }
}
