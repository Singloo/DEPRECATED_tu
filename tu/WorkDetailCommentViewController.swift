//
//  WorkDetailCommentViewController.swift
//  tu
//
//  Created by Rorschach on 2017/3/15.
//  Copyright © 2017年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import Material
import SlackTextViewController
import MJRefresh
import ISEmojiView
import AVOSCloud
import SDWebImage
import SVProgressHUD
import SwifterSwift
import SKPhotoBrowser
import YYKeyboardManager
import Popover_OC

class WorkDetailCommentViewController: SLKTextViewController,ISEmojiViewDelegate,HeaderViewButtonTappedDelegate {

    //needed object
    var headObject:AVObject!
    
    var buyerUserAccount:AVObject!
    
    var sellerUserAccount:AVObject!
    var seller:AVObject!
    var userWork:AVObject!
    var postWork:AVFile!
    
    var rightItem:UIBarButtonItem!

    
    var workTranscationObject:AVObject!
    
    var manager = YYKeyboardManager.default()
    
    var commentDataArr = NSMutableArray()
    override var tableView: UITableView?{
        get{
           return super.tableView!
        }
    }

    var emojiView:ISEmojiView!
    var emojiIsShow:Bool = false
//    override init(tableViewStyle style: UITableViewStyle) {
//        super.init(tableViewStyle: .plain)
//    }
//    
//    required init(coder decoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

//    override class func tableViewStyle(for decoder: NSCoder) -> UITableViewStyle {
//        
//        return .plain
//    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.extendedLayoutIncludesOpaqueBars = true
       
        self.textInputbar.maxCharCount = 256
        manager.add(self)
        rightItem = UIBarButtonItem()
        rightItem.style = .plain
        rightItem.image = Icon.cm.moreVertical
        rightItem.addTargetForAction(target: self, action: #selector(WorkDetailCommentViewController.navigationBarItemAction))
        rightItem.isEnabled = true
        self.navigationItem.rightBarButtonItem = rightItem
    
        prepareBaseData()
        prepareBaseSet()
        prepareInputBar()
        prepareCommentCell()
        
                
    }

    //navigationBarItemAction
    
    func navigationBarItemAction() {
        let popView = PopoverView()
        let shareAction = PopoverAction(title: "分享") { (action) in
            self.shareAction()
        }
        let deleteAction = PopoverAction(title: "举报") { (action) in
            self.reportAction()
        }
        popView.style = .dark
        popView.show(to: CGPoint(x: SCREEN_WIDTH - 20, y: 64), with: [shareAction!,deleteAction!])

    }
    
    func shareAction() {
        let workFile = headObject["workFile"] as! AVFile
        let workPrice = headObject["workPrice"] as! Int
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

    
    func reportAction() {
        
        let vc = ReportViewController()
        vc.reportedObject = headObject
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

    
    
    //prepare
    func prepareInputBar(){
        self.leftButton.setImage(UIImage(named: "mls_Happy"), for: .normal)
        self.leftButton.tintColor = Color.grey.base
        self.rightButton.setTitle("评论", for: .normal)
        
        
    }
    
    func prepareCommentCell(){
        let query = AVQuery(className: "WorksOnSalesComment")
        query.order(byAscending: "createdAt")
        query.skip = 0
        query.limit = 20
        query.whereKey("commentWork", equalTo: headObject)
        query.selectKeys(["commentSender","commentContent","createdAt","commentSenderUsername"])
        query.findObjectsInBackground { (result, error) in
            self.commentDataArr.removeAllObjects()
            self.commentDataArr.addObjects(from: result!)
            self.tableView?.reloadData()
            
        }
    }
    
    func prepareBaseSet(){
        self.isInverted = false
        self.isKeyboardPanningEnabled = true
        self.shouldScrollToBottomAfterKeyboardShows = false
        
        
        self.tableView?.separatorStyle = .singleLine
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        
        self.tableView?.register(WDHeaderTableViewCell.self, forCellReuseIdentifier: "HeaderCell")
        self.tableView?.register(WDCommentTableViewCell.self, forCellReuseIdentifier: "CommentCell")
        self.tableView?.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(WorkDetailCommentViewController.footerRefresh))
        self.tableView?.estimatedRowHeight = 100
        self.tableView?.rowHeight = UITableViewAutomaticDimension

    }
    
    func prepareBaseData() {
        //query seller account
        let sellerObjc = headObject["workOwner"] as! AVObject
        self.seller = sellerObjc
        let queryS = AVQuery(className: "UserAccount")
        queryS.whereKey("user", equalTo: sellerObjc)
        queryS.findObjectsInBackground { (result, error) in
            if error == nil{
                let object = result?[0] as! AVObject
                self.sellerUserAccount = object
            }else{
                SVProgressHUD.showError(withStatus: "网络不太好..")

            }
        }
        
        //query current user account
        if AVUser.current() != nil{
            let queryB = AVQuery(className: "UserAccount")
            queryB.whereKey("user", equalTo: AVUser.current())
            queryB.findObjectsInBackground({ (result, error) in
                if error == nil{
                    self.buyerUserAccount = result?[0] as! AVObject
                }
            })
 
        }
        
        let file = headObject["workFile"] as! AVFile
        self.postWork = file
        
        //fetch work
        let originalWork = headObject["workOnSale"] as! AVObject
        let queryUserWork = AVQuery(className: "UserWorks")
        queryUserWork.getObjectInBackground(withId: originalWork.objectId!) { (object, error) in
            if error == nil{
                self.userWork = object
            }
        }
        //
        let transcationQuery = AVQuery(className: "WorksTranscationHistory")
        transcationQuery.whereKey("workOnSale", equalTo: headObject)
        transcationQuery.findObjectsInBackground { (result, error) in
            if error == nil{
                self.workTranscationObject = result?[0] as! AVObject
            }
        }
        
        
    }
    //config button action
    override func didPressLeftButton(_ sender: Any?) {
        super.didPressLeftButton(sender)
        emojiView = ISEmojiView()
        emojiView.delegate = self
        if emojiIsShow {
            emojiIsShow = false
            self.leftButton.setImage(UIImage(named: "mls_Happy"), for: .normal)
            self.textView.inputView = nil
            self.textView.resignFirstResponder()
            self.presentKeyboard(true)
//            self.textView.becomeFirstResponder()
 
        }else{
            emojiIsShow = true
            self.leftButton.setImage(UIImage(named: "mls_Happy_selected"), for: .normal)
            self.dismissKeyboard(true)
            self.textView.inputView = emojiView
            self.textView.becomeFirstResponder()
 
            
        }
    }
    
    override func didPressRightButton(_ sender: Any?) {
        super.didPressLeftButton(sender)

        self.dismissKeyboard(true)
        let indexpath = IndexPath(item: self.commentDataArr.count, section: 1)
        let rowAnimation:UITableViewRowAnimation = .bottom

        if AVUser.current() == nil{
            self.rightButton.isEnabled = false
        }else{
            let object = AVObject(className: "WorksOnSalesComment")
            object.setObject(AVUser.current(), forKey: "commentSender")
            object.setObject(self.textView.text, forKey: "commentContent")
            object.setObject(self.headObject, forKey: "commentWork")
            object.setObject(AVUser.current()?.username, forKey: "commentSenderUsername")
            object.saveInBackground { (success, error) in
                if success{
                    SVProgressHUD.showSuccess(withStatus: "评论成功!~")
 
                    SVProgressHUD.dismiss(withDelay: 1)
    
                    self.textView.clear()
                    self.tableView?.beginUpdates()
                    self.commentDataArr.insert(object, at: self.commentDataArr.count)
   
                    self.tableView?.insertRows(at: [indexpath], with: rowAnimation)
                    self.tableView?.endUpdates()
                    self.tableView?.reloadRows(at: [indexpath], with: .automatic)

                }else{
                    SVProgressHUD.showError(withStatus: "网络不太好哦~~")
                    SVProgressHUD.dismiss(withDelay: 1)
                }
            }
        }
        
    }
    
    func emojiViewDidPressDeleteButton(emojiView: ISEmojiView) {
        self.textView.deleteBackward()
    }
    
    func emojiViewDidSelectEmoji(emojiView: ISEmojiView, emoji: String) {
        self.textView.insertText(emoji)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        self.navigationBar?.setColors(background: Color.grey.lighten4, text: Color.grey.darken3)
        UIApplication.shared.statusBarStyle = .default

        self.dismissKeyboard(true)
        self.textInputbar.updateConstraints()
        self.textInputbar.setNeedsLayout()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    // refresh
    func footerRefresh(){
        let query = AVQuery(className: "WorksOnSalesComment")
        query.order(byAscending: "createdAt")
        query.skip = self.commentDataArr.count
        query.limit = 20
        query.whereKey("commentWork", equalTo: headObject)
    query.selectKeys(["commentSender","commentContent","createdAt","commentSenderUsername"])
        query.findObjectsInBackground { (result, error) in
            self.tableView?.mj_footer.endRefreshing()
            self.commentDataArr.addObjects(from: result!)
            self.tableView?.reloadData()
            
        }

    }
    
    
    
    //config tableview
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [1,self.commentDataArr.count][section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! WDHeaderTableViewCell
            cell1.delegate = self
            
            prepareHeadView(data: headObject, cell: cell1)
            return cell1
            
        case 1:
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! WDCommentTableViewCell
   
            let object = commentDataArr[indexPath.row] as! AVObject
            prepareCommentCell(data: object, cell: cell2, indexPath: indexPath)
            return cell2
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            return cell
        }
    }
    
    
    //
    //headCellDelegate
    
    func loveBtnTapped(sender:IconButton,loveNum:UILabel){
        if AVUser.current() != nil {
            sender.isEnabled = false
            
            let query = AVQuery(className: "LoveWorks")
            query.whereKey("user", equalTo: AVUser.current())
            query.whereKey("lovedWork", equalTo: headObject)
            query.findObjectsInBackground({ (result, error) in
                if result != nil && result?.count != 0{
                    for object in result! {
                        let objc = object as! AVObject
                        objc.deleteEventually()
                    }
                    sender.tintColor = Color.blueGrey.base
                    loveNum.text = "\((loveNum.text?.int)! - 1)"
                    self.headObject.incrementKey("loveNumber", byAmount: NSNumber(value: -1))
                    self.headObject.saveInBackground()
                }else{
                    let loveObject = AVObject(className: "LoveWorks")
                    loveObject.setObject(AVUser.current(), forKey: "user")
                    loveObject.setObject(self.headObject, forKey: "lovedWork")
                    loveObject.saveInBackground({ (success, error) in
                        if success{
                            sender.tintColor = Color.red.lighten2
                            loveNum.text = "\((loveNum.text?.int)! + 1)"
                            self.headObject.incrementKey("loveNumber", byAmount: NSNumber(value: 1))
                            self.headObject.saveInBackground()
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
        }

    }
    
    func postWorkTapped() {
        let status = self.keyboardStatus
        var images = [SKPhoto]()
        if status == .didHide && self.textView.inputView == nil {
            let photo = SKPhoto.photoWithImageURL(postWork.url!)
            images.append(photo)
            
            let browser = SKPhotoBrowser(photos: images)
            browser.initializePageIndex(0)
            self.present(browser, animated: true) { 
                
            }
        }
    }
    
    func purchaseBtnTapped(sender: FlatButton) {
    
        if AVUser.current() == nil{
            SVProgressHUD.showError(withStatus: "请先登录!")
            SVProgressHUD.dismiss(withDelay: 1)
        }else{
            let price = headObject["workPrice"] as! Int
            let alert = UIAlertController(title: nil, message: "确认购买这幅作品吗? 价格:\(price)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in

                if AVUser.current()!.objectId == self.seller.objectId{
                    SVProgressHUD.showError(withStatus: "这是你自己的作品...不能购买")
                    SVProgressHUD.dismiss(withDelay: 1)
                }else{

                    let query = AVQuery(className: "UserAccount")
                    query.whereKey("user", equalTo: AVUser.current())
                    query.findObjectsInBackground({ (result, error) in
                        if error == nil{
                            let object = result?[0] as! AVObject
                            let buyerProperty = object["userCoin"] as! Int
                            self.handleIfCurrenWorkCouldBuy(buyerProperty: buyerProperty, price: price, buyerUserAccount: object, sender: sender)
                        }else{
                            let e1 = error as! NSError
                            SVProgressHUD.showError(withStatus: "网络异常\(e1.code)")
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
    //could buy
    func handleIfCurrenWorkCouldBuy(buyerProperty:Int, price:Int, buyerUserAccount:AVObject, sender:FlatButton){

        SVProgressHUD.show()
        headObject.fetchInBackground(withKeys: ["hadSale"]) { (object, error) in
            let isSold = object?["hadSale"] as! Bool
            if isSold {
                SVProgressHUD.showError(withStatus: "哎呀,你慢了一步,已经被人买掉了")
                SVProgressHUD.dismiss(withDelay: 1)
            }else{
                if buyerProperty > price {
                    //继续交易
                    //1.add coin
                    self.sellerUserAccount.incrementKey("userCoin", byAmount: NSNumber(value: price))
                    self.sellerUserAccount.saveInBackground({ (success, error) in
                        if success{
                            //2.change work info
                            self.userWork.setObject(true, forKey: "saleable")
                            self.userWork.setObject(AVUser.current(), forKey: "user")
                            self.userWork.incrementKey("transcationTimes", byAmount: NSNumber(value: 1))
                            self.userWork.saveInBackground({ (success, error) in
                                if success{
                                    //3.changse post info
                                    self.headObject.setObject(true, forKey: "hadSale")
                                    self.headObject.saveInBackground({ (success, error) in
                                        if success{
                                            //4.reduce buyer coin
                                            buyerUserAccount.incrementKey("userCoin", byAmount: NSNumber(value: -price))
                                            buyerUserAccount.saveInBackground({ (success, error) in
                                                if success{

                                                    //5.save transcation
                                                self.workTranscationObject.setObject(AVUser.current(), forKey: "currentOwner")
                                                self.workTranscationObject.saveInBackground()
                                                    //6.upload notification
                                                    let notifyObject = AVObject(className: "NotifyOwner")
                                                    notifyObject.setObject(self.headObject, forKey: "soldWork")
                                                    notifyObject.setObject(AVUser.current()?.username, forKey: "buyerName")
                                                    notifyObject.setObject(self.seller, forKey: "owner")
                                                    notifyObject.setObject(price, forKey: "price")
                                                    notifyObject.saveEventually()
                                                    SVProgressHUD.showSuccess(withStatus: "购买成功,快去看看吧~")
                                                    SVProgressHUD.dismiss(withDelay: 1)
                                                }else{
                                                    let e1 = error as! NSError

                                                    SVProgressHUD.showError(withStatus: "扣款失败.. \(e1)")
                                                    SVProgressHUD.dismiss(withDelay: 1)
                                                }
                                            })
                                        }else{
                                            let e1 = error as! NSError
                                            SVProgressHUD.showError(withStatus: "修改出售状态失败 \(e1)")
                                            SVProgressHUD.dismiss(withDelay: 1)
                                        }
                                    })
                                }else{
                                    let e1 = error as! NSError
                                    SVProgressHUD.showError(withStatus: "修改作品新主人失败 \(e1)")
                                    SVProgressHUD.dismiss(withDelay: 1)
                                }
                            })
                        }else{
                            let e1 = error as! NSError
                            SVProgressHUD.showError(withStatus: "coin到账失败 \(e1)")
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
    
    
    //config cellData
    func prepareHeadView(data:AVObject, cell:WDHeaderTableViewCell){

        
        let user = headObject["workOwner"] as! AVObject
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

        let hadSale = data["hadSale"] as! Bool
        if hadSale {
            cell.purchaseBtn.title = "已售出"
            cell.purchaseBtn.backgroundColor = Color.grey.lighten1
            cell.purchaseBtn.isUserInteractionEnabled = false
        }
        
        let date = data["updatedAt"] as! Date
        let format = DateFormatter()
        format.dateStyle = .short
        format.timeStyle = .short
        cell.dateLabel.text = format.string(from: date)

        
        let userName = data["workOwnerName"] as! String
        cell.userNickname.text = userName
        
        cell.postWork.sd_setImage(with: URL(string: postWork.url!))
        
        let loveNum = data["loveNumber"] as! Int
        cell.loveNum.text = "\(loveNum)"

        
        let price = data["workPrice"] as! Int
        cell.price.text = "\(price)"
        
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
    
    func prepareCommentCell(data: AVObject,cell: WDCommentTableViewCell,indexPath: IndexPath){
        let commentSender = data["commentSender"] as! AVObject
        let query = AVQuery(className: "UserAccount")
        query.whereKey("user", equalTo: commentSender)
        query.findObjectsInBackground { (result, error) in
            if error == nil{
                let object = result?[0] as! AVObject
                let file = object["userAvatar"] as! AVFile
                cell.userAvatar.sd_setImage(with: URL(string: file.url!))

            }
        }
        
        let username = data["commentSenderUsername"] as! String
        cell.userNickname.text = username
        cell.userAvatar.tag = indexPath.row
        cell.delegate = self
        
        let comment = data["commentContent"] as! String
        cell.commentLabel.text = comment
        
        let date = data["createdAt"] as! Date
        let format = DateFormatter()
        format.dateStyle = .short
        format.timeStyle = .short
        cell.dateLabel.text = format.string(from: date)
        
        cell.floorNum.text = "\(indexPath.row + 1)楼"
        
    }


}

extension WorkDetailCommentViewController:YYKeyboardObserver{
    func keyboardChanged(with transition: YYKeyboardTransition) {
        let keyboardView = manager.keyboardFrame
        self.textInputbar.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view).offset(keyboardView.size.height)
        }
    }
}

extension WorkDetailCommentViewController:CommentCellUserAvatarDelegate{
    func avatarTapped(avatar: UIImageView) {
        let object = commentDataArr[avatar.tag] as! AVObject
        let userOBJC = object["commentSender"] as! AVObject
        let vc = StrangerUserInfoViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.userObject = userOBJC
        self.navigationController?.pushViewController(vc, animated: true)

    }
}
