//
//  UserWorksViewController.swift
//  tu
//
//  Created by Rorschach on 2016/11/8.
//  Copyright © 2016年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import SKPhotoBrowser
import SnapKit
import AVOSCloud
import MJRefresh
import SwifterSwift
import Material
import SVProgressHUD

class UserWorksViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    var images = [SKPhoto]()
//    var userWorks:NSMutableArray = []
    var collectionView:UICollectionView!
    var layout = UICollectionViewFlowLayout()
    var dataArray = NSMutableArray()


    let cellIdentifier = "userWorkCVCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color.grey.lighten2
        self.extendedLayoutIncludesOpaqueBars = true
        

        prepareCollectionView()
        self.headRefresh()
        

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
        
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UserWorksCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        self.collectionView.backgroundColor = Color.grey.lighten3
        
        self.view.layout(collectionView).edges()
        
        self.collectionView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(UserWorksViewController.headRefresh))
        self.collectionView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(UserWorksViewController.footerRefresh))
        
        collectionView.reloadData()

    }
    
    func headRefresh() {
        let query = AVQuery(className: "UserWorks")
        query.whereKey("user", equalTo: AVUser.current()!)
        query.whereKey("saleable", equalTo: true)
        query.selectKeys(["userWork"])
        query.limit = 10
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground({ (result, error) in
            if result?.count == 0{
                let label = UILabel()
                label.text = "这里什么都没有.."
                label.textColor = Color.grey.base
                label.textAlignment = .center
                label.font = RobotoFont.light(with: 17)
                self.view.layout(label).edges()
                self.view.bringSubview(toFront: label)
            }else{
                if error == nil{
                    self.images.removeAll()
                    self.collectionView.mj_header.endRefreshing()
                    self.dataArray.removeAllObjects()
                    self.dataArray.addObjects(from: result!)
                    self.collectionView.reloadData()
                }else{
                    SVProgressHUD.show(nil, status: "网络不太好..")
                    SVProgressHUD.dismiss(withDelay: 1)
                }
            }
        })
    }

    func footerRefresh(){
        let query = AVQuery(className: "UserWorks")
        query.whereKey("user", equalTo: AVUser.current()!)
        query.whereKey("saleable", equalTo: true)
        query.selectKeys(["userWork"])
        query.limit = 10
        query.skip = self.dataArray.count
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground({ (result, error) in
                if error == nil{
                    self.collectionView.mj_footer.endRefreshing()
                    self.dataArray.addObjects(from: result!)
                    self.collectionView.reloadData()
                }else{
                    SVProgressHUD.show(nil, status: "网络不太好..")
                    SVProgressHUD.dismiss(withDelay: 1)
                }
            
        })

    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! UserWorksCollectionViewCell

        let object = self.dataArray[indexPath.row] as! AVObject
        let imageFile = object["userWork"] as! AVFile
        let photo = SKPhoto.photoWithImageURL(imageFile.url!)
        self.images.append(photo)
        cell.userWorks.sd_setImage(with: URL(string: imageFile.url!))
        cell.delegate = self
        cell.moreIcon.tag = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! UserWorksCollectionViewCell

        let browser = SKPhotoBrowser(originImage: cell.userWorks.image! ?? UIImage(), photos: images, animatedFromView: cell)
        browser.initializePageIndex(indexPath.row)
        self.present(browser, animated: true) { 
            
        }
 
    }


}

extension UserWorksViewController:MoreBtnActionDelegate{
    
    func shareAction(btn:IconButton) {
        let object = self.dataArray[btn.tag] as! AVObject
        let workFile = object["userWork"] as! AVFile
        
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: "同学,来玩呀,点进来嘛~(*￣3￣)╭",
                                          images : UIImage(data: workFile.getData()!),
                                          url : URL(string: "https://itunes.apple.com/us/app/涂了个鸭/id1239162142?l=zh&ls=1&mt=8"),
                                          title : "这幅画你觉得值多少?( ⊙ o ⊙ )啊！",
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
    
    func deleteAction(btn:IconButton) {
        
        let alert = UIAlertController(title: "确定删除?", message: "(无法恢复)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
            SVProgressHUD.show()
            let object = self.dataArray[btn.tag] as! AVObject
            object.fetchInBackground { (object, error) in
                if error == nil{
                    object?.deleteInBackground({ (success, error) in
                        if success {
                            
                            self.dataArray.removeObject(at: btn.tag)
                            self.collectionView.reloadData()
                            SVProgressHUD.show(nil, status: "删除成功!")
                            SVProgressHUD.dismiss(withDelay: 1)
                        }else{
                            let e1 = error as! NSError
                            SVProgressHUD.show(nil, status: "网络不太好..\(e1.code)")
                            SVProgressHUD.dismiss(withDelay: 1)
                        }
                    })
                }else{
                    let e1 = error as! NSError
                    SVProgressHUD.show(nil, status: "网络不太好..\(e1.code)")
                    SVProgressHUD.dismiss(withDelay: 1)
                }
            }

        }))
        alert.addAction(UIAlertAction(title: "点错了", style: .cancel, handler: nil))
        self.present(alert, animated: true) { 
            
        }
    }
}
