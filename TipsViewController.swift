//
//  TipsViewController.swift
//  tu
//
//  Created by Rorschach on 2017/6/3.
//  Copyright © 2017年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import SnapKit

class TipsViewController: UIViewController {
    var tips:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
        // Do any additional setup after loading the view.
    }
    
    func prepareView(){
        tips = UILabel()
        tips.textAlignment = .center
        tips.numberOfLines = 0
        tips.text = "如何得到口令?\nQQ群:195341077 \n新浪微博@:怎么吃你才好呢"
        self.view.addSubview(tips)
        tips.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
            make.width.equalTo(230)
            make.height.equalTo(70)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
