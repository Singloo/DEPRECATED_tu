//
//  StatementViewController.swift
//  tu
//
//  Created by Rorschach on 2016/11/9.
//  Copyright © 2016年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import Material

class StatementViewController: UIViewController {

    var contentLabel:UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = true


        contentLabel = UITextView(frame: CGRect(x: 0, y: 10, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        
        contentLabel.textAlignment = .left
        contentLabel.isEditable = false
        contentLabel.font = RobotoFont.regular(with: 13)
        contentLabel.text = "啊,终于是做完了... 洒家不是学编程的..所以,可能很多地方做得没那么好,bug可能也很多..\n请多包涵啦,感谢各位开源作者,没有这些库..洒家是根本做不出来的...\n https://github.com/suzuki-0000/SKPhotoBrowser SKPhotoBrowser \n https://github.com/CoderMJLee/MJRefresh MJRefresh\n https://github.com/SnapKit/SnapKit SnapKit \n https://github.com/ruslanskorb/RSKImageCropper RSKImageCropper \n https://github.com/slackhq/SlackTextViewController SlackTextViewController \n https://github.com/isaced/ISEmojiView ISEmojiView \n https://github.com/SwifterSwift/SwifterSwift SwifterSwift \n https://github.com/CosmicMind/Material Material \n https://github.com/PageGuo/PGScratchView PGScratchView \n https://github.com/rs/SDWebImage SDWebImage \n https://github.com/dasdom/BreakOutToRefresh BreakOutToRefresh \n https://github.com/gontovnik/DGElasticPullToRefresh DGElasticPullToRefresh \n https://github.com/lifution/Popover  Popover \n https://github.com/ibireme/YYKit YYKeyboardManager \n \n 交流或者提交BUG \n QQ群:195341077 \n \n 成为洒家第三个粉丝? \n 新浪微博@:怎么吃你才好呢 \n \n 想获得和洒家一样的品味? \n 网易云音乐@:牛肉面没有面   (啊,占了你的昵称,当时想取的被占了,就随便填了) \n \n 以前是个索狗没得选,现在只想玩ns \n SW-0014-5903-3431 \n \n为我提供技术支持 \n singloo.yang@gmail.com 我会尽快回复 \n 有懂游戏开发的大佬也可联系↑↑,我...我我..没有钱,但是..可以教你魔法\n 帮助我 \n singloo.yang@outlook.com 同样会尽快回复 \n \n 你们能看到这段话我已经很感谢了,如果你觉得这个app还不赖嘛,推荐给你的朋友吧 \n 感谢你的支持!"
        self.view.addSubview(contentLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationBar?.setColors(background: Color.grey.lighten4, text: Color.grey.darken3)
        

    }

}
