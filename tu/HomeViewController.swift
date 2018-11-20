//
//  HomeViewController.swift
//  tu
//
//  Created by Rorschach on 2017/2/23.
//  Copyright © 2017年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import AVOSCloud
import MJRefresh
import DGElasticPullToRefresh
import Material
import SnapKit
import SDWebImage
import SVProgressHUD
import SwifterSwift
import SKPhotoBrowser

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,HomeDetailCellButtonTappedActionDelegate{

//    @IBOutlet weak var tableview: UITableView!
    var tableview:UITableView!
    var currentPostWork:AVObject!
    
    var buyerAccount:AVObject!
    
    var seller:AVObject!
    var sellerAccount:AVObject!
    
    var userWork:AVObject!
    
    var workTranscationObject:AVObject?
    


    let loadingView = DGElasticPullToRefreshLoadingViewCircle()
    
    var dataArray:NSMutableArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()


        
        self.view.backgroundColor = Color.white
        self.prepareTableview()
        self.headRefresh()
        
        self.queryNotification()
        
    }

    func queryNotification() {
        let query = AVQuery(className: "AnyNotification")
        query.findObjectsInBackground { (result, error) in
            if result?.count == 0{
                
            }else{
                let object = result?[0] as! AVObject
                let message = object["message"] as! String
                let alert = UIAlertController(title: "通知", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "嗯,知道了", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: { 
                    
                })
            }
        }
    }
  
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent

        let bk = UIImage(named: "navigationBK")
        bk?.resizableImage(withCapInsets: .zero, resizingMode: .stretch)

        self.navigationBar?.setBackgroundImage(bk, for: .default)
        self.navigationBar?.shadowImage = UIImage()
        self.navigationBar?.tintColor = Color.white
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //hide navigationbar
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 0 {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            UIApplication.shared.statusBarStyle = .default
        }else{
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }

    
    // prepare
    func prepareTableview() {
        loadingView.tintColor = Color.lightGreen.lighten4
        
        self.tableview = UITableView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64))

        
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.separatorStyle = .singleLine
        self.tableview.backgroundColor = Color.white

        
        let nib = UINib(nibName: "HomeDetailWorkTableViewCell", bundle: nil)
        self.tableview.register(nib, forCellReuseIdentifier: "cell")

        
        self.tableview.dg_addPullToRefreshWithActionHandler({ 
            self.headRefresh()
        }, loadingView: loadingView)
        self.tableview.dg_setPullToRefreshFillColor(Color.lightGreen.lighten1)
        self.tableview.dg_setPullToRefreshBackgroundColor(UIColor.clear)
        
        self.tableview.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(HomeViewController.footerRefresh))
        
        self.tableview.mj_footer.isAutomaticallyHidden = true
        self.view.addSubview(tableview)
        
    }

    func prepareBaseData(currentRow:Int) {
        let object = self.dataArray[currentRow] as! AVObject
        currentPostWork = object
        let sellerUser = object["workOwner"] as! AVObject
        self.seller = sellerUser
        let queryS = AVQuery(className: "UserAccount")
        queryS.whereKey("user", equalTo: seller)
        queryS.findObjectsInBackground { (result, error) in
            if error == nil{
                self.sellerAccount = result?[0] as! AVObject
            }
        }

        
        if AVUser.current() != nil{
            let queryB = AVQuery(className: "UserAccount")
            queryB.whereKey("user", equalTo: AVUser.current())
            queryB.findObjectsInBackground({ (result, error) in
                if error == nil{
                    self.buyerAccount = result?[0] as! AVObject
                }
            })

            
        }
        
        let originalWork = object["workOnSale"] as! AVObject
        let queryUserWork = AVQuery(className: "UserWorks")
        queryUserWork.getObjectInBackground(withId: originalWork.objectId!) { (object, error) in
            if error == nil{
                self.userWork = object
            }
        }
        
        let transcationQuery = AVQuery(className: "WorksTranscationHistory")
        transcationQuery.whereKey("workOnSale", equalTo: object)
        transcationQuery.findObjectsInBackground { (result, error) in
            if error == nil{
                self.workTranscationObject = result?[0] as! AVObject
            }
        }
        
        
    }

    
    
    
    // tableview funcs
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeDetailWorkTableViewCell
        cell.delegate = self
        let object = self.dataArray[indexPath.row] as! AVObject
        cell.purchaseBtn.tag = indexPath.row
        cell.loveBtn.tag = indexPath.row
        cell.moreBtn.tag = indexPath.row
        cell.postImg.tag = indexPath.row
        prepareCell(data: object, cell: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = WorkDetailCommentViewController()
        let object = self.dataArray[indexPath.row] as! AVObject
        vc.headObject = object
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (68 + 44 + 40 + SCREEN_WIDTH/1.618)
    }
    
    
    //delegate cell

    func shareAction(btn:IconButton){
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
    
    func deleteAction(btn:IconButton){
        let object = self.dataArray[btn.tag] as! AVObject
        let vc = ReportViewController()
        vc.reportedObject = object
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        
    }

    
    func loveBtnTapped(sender: IconButton, loveNum: UILabel) {
        if AVUser.current() != nil {
            sender.isEnabled = false
            let object = self.dataArray[sender.tag] as! AVObject
            
            let query = AVQuery(className: "LoveWorks")
            query.whereKey("user", equalTo: AVUser.current())
            query.whereKey("lovedWork", equalTo: object)
            query.findObjectsInBackground({ (result, error) in
                if result != nil && result?.count != 0{
                    for object in result! {
                        let objc = object as! AVObject
                        objc.deleteEventually()
                    }
                    sender.tintColor = Color.blueGrey.base
                    loveNum.text = "\((loveNum.text?.int)! - 1)"
                    object.incrementKey("loveNumber", byAmount: NSNumber(value: -1))
                    object.saveInBackground()
                }else{
                    let loveObject = AVObject(className: "LoveWorks")
                    loveObject.setObject(AVUser.current(), forKey: "user")
                    loveObject.setObject(object, forKey: "lovedWork")
                    loveObject.saveInBackground({ (success, error) in
                        if success{
                            sender.tintColor = Color.red.lighten2
                            loveNum.text = "\((loveNum.text?.int)! + 1)"
                            object.incrementKey("loveNumber", byAmount: NSNumber(value: 1))
                            object.saveInBackground()
                        }else{
                            let e1 = error as! NSError
                            SVProgressHUD.showError(withStatus: "网络出现了一些问题...\(e1.code)")
                            SVProgressHUD.dismiss(withDelay: 1)
                        }
                    })
                }
                sender.isEnabled = true
                
            })
            
            
        }else{
            SVProgressHUD.showError(withStatus: "登录后开启更多功能~")
            SVProgressHUD.dismiss(withDelay: 1)
        }
        
    }
    
    func purchaseBtnTapped(sender: FlatButton) {
        if AVUser.current() == nil{
            SVProgressHUD.showError(withStatus: "请先登录!")
            SVProgressHUD.dismiss(withDelay: 1)
        }else{
            self.prepareBaseData(currentRow: sender.tag)
            let price = currentPostWork["workPrice"] as! Int
            let alert = UIAlertController(title: nil, message: "确认购买这幅作品吗? 价格:\(price)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
                let seller = self.currentPostWork["workOwner"] as! AVObject
                if AVUser.current()?.objectId == seller.objectId{
                    SVProgressHUD.showError(withStatus: "这是你自己的作品...不能购买")
                    SVProgressHUD.dismiss(withDelay: 1)
                }else{
                    let query = AVQuery(className: "UserAccount")
                    query.whereKey("user", equalTo: AVUser.current())
                    query.findObjectsInBackground({ (result, error) in
                        if error == nil{
                            let account = result?[0] as! AVObject
                            let buyerProperty = account["userCoin"] as! Int
                            self.handleIfCurrenWorkCouldBuy(buyerProperty: buyerProperty, price: price, buyerUserAccount: account, sender: sender)
                        }else{
                            let e1 = error as! NSError
                            SVProgressHUD.showError(withStatus: "网络异常\(e1)")
                            SVProgressHUD.dismiss(withDelay: 1)

                        }
                    })
                }
                
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: {
                
            })
        }

    }
    
    func postImgTapped(sender: UIImageView) {
        let object = self.dataArray[sender.tag] as! AVObject
        let workFile = object["workFile"] as! AVFile
        var images = [SKPhoto]()
        let photo = SKPhoto.photoWithImageURL(workFile.url!)
        images.append(photo)
        
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        self.present(browser, animated: true) {
            
        }

    }
    
    //MJRefresh
    func headRefresh(){
        SVProgressHUD.show()
        let query = AVQuery(className: "WorksOnSale")
        query.whereKey("hadSale", equalTo: false)
        query.order(byDescending: "updatedAt")
        query.limit = 10
        query.findObjectsInBackground { (result, error) in
            if error == nil{
                SVProgressHUD.dismiss()
                self.tableview.dg_stopLoading()
                self.dataArray.removeAllObjects()
                self.dataArray.addObjects(from: result!)
                self.tableview.reloadData()
                
            }else{
                let e1 = error as! NSError
                SVProgressHUD.show(nil, status: "网络不太好.. \(e1.code)")
                SVProgressHUD.dismiss(withDelay: 1)
            }
        }
 
    }
    
    func footerRefresh(){
        SVProgressHUD.show()
        let query = AVQuery(className: "WorksOnSale")
        query.whereKey("hadSale", equalTo: false)
        query.order(byDescending: "updatedAt")
        query.skip = self.dataArray.count
        query.limit = 10
        query.findObjectsInBackground { (result, error) in
            if error == nil{
                SVProgressHUD.dismiss()
                self.tableview.mj_footer.endRefreshing()
                self.dataArray.addObjects(from: result!)
                self.tableview.reloadData()
                
            }else{
                let e1 = error as! NSError
                SVProgressHUD.show(nil, status: "网络不太好..\(e1.code)")
                SVProgressHUD.dismiss(withDelay: 1)
            }
        }

    }

    func handleIfCurrenWorkCouldBuy(buyerProperty:Int, price:Int, buyerUserAccount:AVObject, sender:FlatButton){
        
        SVProgressHUD.show()
        currentPostWork.fetchInBackground(withKeys: ["hadSale"]) { (object, error) in
            let isSold = object?["hadSale"] as! Bool
            if isSold {
                SVProgressHUD.showError(withStatus: "哎呀,你慢了一步,已经被人买掉了")
                SVProgressHUD.dismiss(withDelay: 1)
            }else{
                if buyerProperty > price {
                    //继续交易
                    //1.add coin
                    self.sellerAccount.incrementKey("userCoin", byAmount: NSNumber(value: price))
                    self.sellerAccount.saveInBackground({ (success, error) in
                        if success{
                            //2.change work info
                            self.userWork.setObject(true, forKey: "saleable")
                            self.userWork.setObject(AVUser.current(), forKey: "user")
                            self.userWork.incrementKey("transcationTimes", byAmount: NSNumber(value: 1))

                            self.userWork.saveInBackground({ (success, error) in
                                if success{
                                    //3.changse post info
                                    self.currentPostWork.setObject(true, forKey: "hadSale")
                                    self.currentPostWork.saveInBackground({ (success, error) in
                                        if success{
                                            //4.reduce buyer coin
                                            buyerUserAccount.incrementKey("userCoin", byAmount: NSNumber(value: -price))
                                            buyerUserAccount.saveInBackground({ (success, error) in
                                                if success{
                                                    
                                                    //5.save transcation
                                                    self.workTranscationObject?.setObject(AVUser.current(), forKey: "currentOwner")
                                                    self.workTranscationObject?.saveInBackground()
                                                    //6.upload notification
                                                    let notifyObject = AVObject(className: "NotifyOwner")
                                                    notifyObject.setObject(self.currentPostWork, forKey: "soldWork")
                                                    notifyObject.setObject(self.seller, forKey: "owner")
                                                    notifyObject.setObject(AVUser.current()?.username, forKey: "buyerName")
                                                    notifyObject.setObject(price, forKey: "price")
                                                    notifyObject.saveInBackground()
                                                    SVProgressHUD.showSuccess(withStatus: "购买成功,快去看看吧~")
                                                    SVProgressHUD.dismiss(withDelay: 1)
                                                    
                                                }else{
                                                    let e1 = error as! NSError
                                                    SVProgressHUD.showError(withStatus: "扣款失败..\(e1.code)")
                                                    SVProgressHUD.dismiss(withDelay: 1)
                                                }
                                            })
                                        }else{
                                            let e1 = error as! NSError
                                            SVProgressHUD.showError(withStatus: "修改售出失败\(e1.code)")
                                            SVProgressHUD.dismiss(withDelay: 1)
                                        }
                                    })
                                }else{
                                    let e1 = error as! NSError
                                    SVProgressHUD.showError(withStatus: "修改作品新主人失败\(e1.code)")
                                    SVProgressHUD.dismiss(withDelay: 1)
                                }
                            })
                        }else{
                            let e1 = error as! NSError
                            SVProgressHUD.showError(withStatus: "coin到账失败")
                            SVProgressHUD.dismiss(withDelay: 1)
                        }
                    })
 
                }else{
                    //cancel
                    SVProgressHUD.showError(withStatus: "你的涂币不够哦...继续努力吧")
                    SVProgressHUD.dismiss(withDelay: 1)
                }
                
            }
        }
        
    }


    // action
    
    @IBAction func refresh(_ sender: Any) {
        self.tableview.scrollToTop(animated: true)
        self.headRefresh()
    }
    
    @IBAction func addNewPosts(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PaintVC")
        let vc2 = ChooseWorksViewController()
        
        
        
        if AVUser.current() == nil{
            SVProgressHUD.showSuccess(withStatus: "登录后开启更多功能哦~")
            SVProgressHUD.dismiss(withDelay: 1)
        }else{
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "创建一个新涂鸦", style: .default, handler: { (action) in
                self.present(vc, animated: true, completion: {
                    
                })
            }))
            alert.addAction(UIAlertAction(title: "从已有的作品中选择", style: .default, handler: { (action) in
                
                self.navigationController?.pushViewController(vc2, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                
            }))
            self.present(alert, animated: true) {
                
            }
        }

    }
    
    func prepareCell(data:AVObject , cell:HomeDetailWorkTableViewCell){
        let user = data["workOwner"] as! AVObject
        let query = AVQuery(className: "UserAccount")
        query.whereKey("user", equalTo: user)
        query.selectKeys(["userAvatar"])
        query.findObjectsInBackground { (result, error) in
            if error == nil{
                let object = result?[0] as! AVObject
                let file = object["userAvatar"] as! AVFile
                cell.userAvatar.sd_setImage(with: URL(string: file.url!))
            }
        }


        
        let userName = data["workOwnerName"] as! String
        cell.userNickname.text = userName
        
        let file = data["workFile"] as! AVFile
 
        cell.postImg.sd_setImage(with: URL(string: file.url!))

        let date = data["updatedAt"] as! Date
        let format = DateFormatter()
        format.dateStyle = .short
        format.timeStyle = .short
        cell.dateLabel.text = format.string(from: date)

        
        let hadSale = data["hadSale"] as! Bool
        if hadSale{
            cell.purchaseBtn.setTitle("已出售", for: .normal)
            cell.purchaseBtn.backgroundColor = Color.grey.darken3
            cell.purchaseBtn.isEnabled = false
        }else{
            cell.purchaseBtn.setTitle("购买", for: .normal)
            cell.purchaseBtn.backgroundColor = Color.lightGreen.base
            cell.purchaseBtn.isEnabled = true
        }
        
        let loveNum = data["loveNumber"] as! Int
        cell.loveNum.text = "\(loveNum)"
        
        let price = data["workPrice"] as! Int
        cell.priceLabel.text = "\(price)"
        
        let title = data["workTitle"] as! String
        cell.postTitle.text = title
        
        let postDetail = data["workDetailDescription"] as! String
        cell.postContent.text = postDetail
        
        let queryIfLoved = AVQuery(className: "LoveWorks")
        queryIfLoved.whereKey("user", equalTo: AVUser.current())
        queryIfLoved.whereKey("lovedWork", equalTo: data)
        queryIfLoved.findObjectsInBackground { (result, error) in
            if result != nil && result?.count != 0{
                cell.loveBtn.tintColor = Color.red.lighten2
            }else{
                cell.loveBtn.tintColor = Color.blueGrey.base
            }
        }

    }


}

