//
//  OnSaleWorksViewController.swift
//  tu
//
//  Created by Rorschach on 2017/4/17.
//  Copyright © 2017年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import Material
import MJRefresh
import AVOSCloud
import SVProgressHUD
import SDWebImage

class OnSaleWorksViewController: UIViewController{

    var collectionView:UICollectionView!
    var layout = UICollectionViewFlowLayout()
    var dataArray = NSMutableArray()

    let cellIdentifier = "OnSaleWorksVCCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color.grey.lighten3
        self.extendedLayoutIncludesOpaqueBars = true

        prepareCollectionView()
        headRefresh()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .default
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationBar?.setColors(background: Color.grey.lighten4, text: Color.grey.darken3)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func prepareCollectionView(){
        let width:CGFloat = (SCREEN_WIDTH - 3)/2
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width, height: width)
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(OnSaleWorksCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        self.collectionView.backgroundColor = Color.grey.lighten3
        
        self.view.layout(collectionView).edges()
        self.collectionView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(OnSaleWorksViewController.headRefresh))
        self.collectionView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(OnSaleWorksViewController.footerRefresh))
        self.collectionView.reloadData()
        
    }
    
    func headRefresh(){
        let query = AVQuery(className: "WorksOnSale")
        query.whereKey("hadSale", equalTo: false)
        query.whereKey("workOwner", equalTo: AVUser.current())
        query.limit = 10
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground { (result, error) in
            if result?.count == 0{
                let label = UILabel()
                label.text = "没有在售的作品哦.."
                label.textColor = Color.grey.base
                label.textAlignment = .center
                label.font = RobotoFont.light(with: 17)
                self.view.layout(label).edges()
                self.view.bringSubview(toFront: label)
            }else{
                if error == nil{
                    self.collectionView.mj_header.endRefreshing()
                    self.dataArray.removeAllObjects()
                    self.dataArray.addObjects(from: result!)
                    self.collectionView.reloadData()
                }else{
                    let e1 = error as! NSError
                    SVProgressHUD.show(nil, status: "网络不太好...\(e1)")
                    SVProgressHUD.dismiss(withDelay: 2)
                }
            }
        }
        
    }
    
    func footerRefresh(){
        let query = AVQuery(className: "WorksOnSale")
        query.whereKey("hadSale", equalTo: false)
        query.whereKey("workOwner", equalTo: AVUser.current())
        query.order(byDescending: "createdAt")
        query.limit = 10
        query.skip = self.dataArray.count
        query.findObjectsInBackground({ (result, error) in
            if error == nil{
                self.collectionView.mj_footer.endRefreshing()
                self.dataArray.addObjects(from: result!)
                self.collectionView.reloadData()
            }else{
                let e1 = error as! NSError
                SVProgressHUD.show(nil, status: "网络不太好..\(e1.code)")
                SVProgressHUD.dismiss(withDelay: 2)
            }
            
        })
    }
    

}

extension OnSaleWorksViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! OnSaleWorksCollectionViewCell
        cell.delegate = self
        let object = self.dataArray[indexPath.row] as! AVObject
        let file = object["workFile"] as! AVFile
        cell.userWorks.sd_setImage(with: URL(string: file.url!))
        cell.moreIcon.tag = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let object = self.dataArray[indexPath.row] as! AVObject
        let vc = WorkDetailCommentViewController()
        vc.headObject = object
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension OnSaleWorksViewController:MoreBtnActionDelegate{
    func shareAction(btn: IconButton) {
        let object = self.dataArray[btn.tag] as! AVObject

        let workFile = object["workFile"] as! AVFile
        let workPrice = object["workPrice"] as! Int
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: "同学,来玩呀,点进来嘛~(*￣3￣)╭",
                                          images : UIImage(data: workFile.getData()!),
                                          url : URL(string: "https://itunes.apple.com/us/app/涂了个鸭/id1239162142?l=zh&ls=1&mt=8"),
                                          title : "这幅画居然价值 \(workPrice)! w(ﾟДﾟ)w",
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
        SVProgressHUD.show()
        let workOnSaleObject = self.dataArray[btn.tag] as! AVObject
        workOnSaleObject.fetchInBackground { (object, error) in
            let hadSale = object?["hadSale"] as! Bool
            if hadSale{
                SVProgressHUD.show(nil, status: "啊哦,你晚了一步..已经卖掉了")
                SVProgressHUD.dismiss(withDelay: 2)
            }else{
                let userWork = object!["workOnSale"] as! AVObject
                let userWorkObject = AVObject(className: "UserWorks", objectId: userWork.objectId!)
                userWorkObject.fetchInBackground({ (userwork, error) in
                    userwork?.setObject(true, forKey: "saleable")
                    userwork?.saveInBackground({ (success, error) in
                        if success{
                            object?.deleteInBackground({ (success, error) in
                                if success{
                                    let commentQuery = AVQuery(className: "WorksOnSalesComment")
                                    commentQuery.whereKey("commentWork", equalTo: workOnSaleObject)
                                    commentQuery.findObjectsInBackground({ (commentResult, error) in
                                        if error == nil{
                                            for commentObject in commentResult!{
                                                (commentObject as! AVObject).deleteInBackground()
                                            }
                                            self.dataArray.removeObject(at: btn.tag)
                                            SVProgressHUD.show(nil, status: "取消成功!")
                                            self.collectionView.reloadData()
                                            SVProgressHUD.dismiss(withDelay: 1)

                                        }else{
                                            let e1 = error as! NSError
                                            SVProgressHUD.showError(withStatus: "网络不太好...\(e1)")
                                            SVProgressHUD.dismiss(withDelay: 1)
                                        }
                                    })
                                   
                                }else{
                                    let e1 = error as! NSError
                                    SVProgressHUD.showError(withStatus: "网络不太好...\(e1)")
                                    SVProgressHUD.dismiss(withDelay: 1)
                                }
                            })
                        }else{
                            let e1 = error as! NSError
                            SVProgressHUD.showError(withStatus: "网络不太好...\(e1)")
                            SVProgressHUD.dismiss(withDelay: 2)
                        }
                    })
                })
            }
        }
    }
}
