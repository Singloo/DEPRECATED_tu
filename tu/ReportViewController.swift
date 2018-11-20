//
//  ReportViewController.swift
//  tu
//
//  Created by Rorschach on 2017/5/30.
//  Copyright © 2017年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import Material
import AVOSCloud
import SnapKit
import YYKeyboardManager
import SVProgressHUD

class ReportViewController: UIViewController {

    var keyboardManager = YYKeyboardManager.default()
    
    var rightItem = UIBarButtonItem(title: "确定", style: .plain, target: self, action: #selector(ReportViewController.btnSure))
    
    var reportedObject:AVObject!
    var reportTextview:TextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.extendedLayoutIncludesOpaqueBars = true
        
        self.navigationItem.rightBarButtonItem = rightItem
        
        keyboardManager.add(self)
        prepareView()

        
    }
    
    func prepareView() {
        reportTextview = TextView()
        reportTextview.becomeFirstResponder()
        reportTextview.textColor = Color.grey.base
        reportTextview.font = RobotoFont.regular(with: 16)
        reportTextview.placeholder = "   输入举报内容,我们会尽快处理..."
        self.view.addSubview(reportTextview)
        reportTextview.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(10)
            make.centerX.equalTo(view)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(SCREEN_HEIGHT - 10)
        }

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
    

    func btnSure() {
        let object = AVObject(className: "ReportedAffairs")
        SVProgressHUD.show()
        rightItem.isEnabled = false
        if reportTextview.isEmpty {
            SVProgressHUD.showError(withStatus: "请输入举报理由")
            SVProgressHUD.dismiss(withDelay: 1)
            rightItem.isEnabled = true
        }else{
            object.setObject(reportedObject, forKey: "reportedObject")
            object.setObject(reportTextview.text, forKey: "reportedReason")
            object.saveInBackground({ (success, error) in
                if success{
                    SVProgressHUD.show(nil, status: "我们已收到您的举报,会尽快处理,蟹蟹")
                    SVProgressHUD.dismiss(withDelay: 1)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    SVProgressHUD.showError(withStatus: "网络不太好...我们未能收到您的举报内容")
                    SVProgressHUD.dismiss(withDelay: 1)
                    self.rightItem.isEnabled = true
                }
            })
        }
    }

}

extension ReportViewController:YYKeyboardObserver{
    func keyboardChanged(with transition: YYKeyboardTransition) {
        let keyboardView = keyboardManager.keyboardFrame
        self.reportTextview.snp.updateConstraints { (make) in
            make.height.equalTo(SCREEN_HEIGHT - 10 - keyboardView.size.height)
        }

    }
}


