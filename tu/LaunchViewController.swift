//
//  LaunchViewController.swift
//  tu
//
//  Created by Rorschach on 2017/4/21.
//  Copyright © 2017年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import Material
import SnapKit

class LaunchViewController: UIViewController {

    var label:UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

 
        self.view.backgroundColor = Color.white

    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        label = UILabel()
        label.text = "你好,人类."
        label.textAlignment = .center
        label.textColor = Color.grey.darken2
        label.font = RobotoFont.light(with: 17)
        label.alpha = 0.2
        self.view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(-50)
            make.height.equalTo(30)
            make.width.equalTo(200)
        }
        

        UIView.animate(withDuration: 1, delay: 0, options: .autoreverse, animations: {
            self.label.alpha = 1
        }, completion: { (bool) in
            self.dismiss(animated: true) {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "oneVC")
                self.present(vc, animated: true, completion: nil)
            }

        })

        

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
