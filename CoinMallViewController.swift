//
//  CoinMallViewController.swift
//  tu
//
//  Created by Rorschach on 2016/11/9.
//  Copyright © 2016年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import Material
import SwifterSwift

class CoinMallViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,BreakOutToRefreshDelegate {

    var tableView:UITableView!
    let cellIdentifier = "CoinMailCell"
    
    var refreshView: BreakOutToRefreshView!
    
    var titleString:String! = "暂时什么都没有....\n为你准备了小游戏,下拉刷新看看吧"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.extendedLayoutIncludesOpaqueBars = true
        prepareTableview()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareRefreshView()
        self.navigationBar?.setColors(background: Color.grey.lighten4, text: Color.grey.darken3)
        UIApplication.shared.statusBarStyle = .default
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
//        refreshView.removeFromSuperview()
//        refreshView = nil
    }
    
    
    
    
    func prepareRefreshView(){
        refreshView = BreakOutToRefreshView(scrollView: tableView)
        refreshView.refreshDelegate = self
        
        
        tableView.addSubview(refreshView)

    }
    
    func prepareTableview() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(CoinMailVCCell.self, forCellReuseIdentifier: cellIdentifier)
        self.view.layout(tableView).edges()
        
    }
    
    //breakrefresh delegate
    func refreshViewDidRefresh(_ refreshView: BreakOutToRefreshView) {
        let random = self.storage.randomItem
        if self.storage.count >= 2{
            self.storage.removeAll(random)
            self.titleString = random
        }else{
            self.titleString = "还刷啊?去睡觉吧"
        }
        self.refreshView.endRefreshing()
        tableView.reloadData()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //scrollview delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        refreshView.scrollViewDidScroll(scrollView)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        refreshView.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        refreshView.scrollViewWillBeginDragging(scrollView)
    }
    //delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CoinMailVCCell
        cell.title.text = titleString
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height
    }
    
    var storage = ["无论怎么狡辩和掩饰, \n你始终知道自己是怎样的","我始终是那个自讨苦吃的人 \n从来没有人邀请过我 \n他们说过,不欢迎自己找上门的人 \n是我说,我会证明自己的,相信我 \n我要怎么证明?我依旧是摆脱不了这些 \n我想的,不过是一夜成名,一夜暴富,啊,真是恶心 \n就算是了,他们也根本不会关心,现在才发现,原来他们一开始就不关心啊 \n是我太自以为是了...原来他们真的是一点都不关心,成功或者失败 \n毫无意义,对他们,对我也是如此","路遇某明星,我一愣,ta也看到我了\n 打了招呼,摆了摆手,大概是让我不要声张吧\n 其实我当时并没有第一时间认出他,\n私下里,也就比一般人好看吧,居然就可以有那么高的收入\n 人类真是不可思议","2吧被封了,哈哈,我就说吧,没我这破吧肯定被封,\n 嗯?你们是谁?放开我,我没病,我已经出院了!","我朝学校猫咪竖中指,\n 看看他们的性格,它们好像并不...\n 不,有一只黄白猫很在乎 \n 它朝我龇牙,甚至在我回宿舍的路上偷袭我\n 它每次扭屁股我就知道\n 即使后来我喂它吃面包,它也不原谅我","我经常嘲笑我们学校猫咪的智商,\n 它们好像并不在乎","晚上跑完步,回去路上看见很多狗 \n很奇怪,我问它们从哪来的\n它们不回答,\n我说,这个地方只能有猫,你们会被赶走的\n它们老大(黑白的)说,我们不会伤害人类的\n但是他们不管的","你连承认错误都不敢,还妄图去说服别人","地球上有很多人,\n 人们通常把和自己看法不同的人称作 傻x \n 你看他是傻x,他看你也是傻x \n XD","'列夫,你可真是条狗'","你对力量一无所知...","猫咪哇呜哇呜的叫说明它生气了","家里小黄又被村长家的小黑打了","我们认识吗?","Are you someone important?","正在前往努巴尼...","没有人在关注你","这位同学以为自己这样很潮,很帅","你一辈子都在渴望别人认同","我讨厌一成不变的人","你所顾虑的事情很多,我所顾虑的,大概只有死亡","离开你的家人,离开你的朋友,去一个没有人认识你的地方,你会觉得...很轻松","这个世界是人类定义的,所以你学习,工作,买房,结婚,生子,\n 哦,还有少量的娱乐.\n 我不属于人类,我不遵守这些规则","当提到一个概念,比如说”学校”,”服务员”,\n 你会用到你所有的知识去描述它,这些知识是从小开始,其他人给你灌输的","你已经...无法专注的做一件事了…去学习如何集中注意力,练字,冥想…都行","“贱人就是矫情”","我能变成乌鸦","人类真是无可救药…","我为地球出过力,我要见球长!","“下辈子,我也要当个美少女”","猫这种动物,很安静,狗太跳,所以猫的学习能力很好,我能和我的猫沟通🐈","巧克力能让大脑产生恋爱的感觉","专注能获得一种力量,这种力量能用来召唤","“死吧,虫子”","早上好啊,你看起来好像很闲","还不睡?","晚安,做个好梦,在梦中你可以为所欲为...","你干嘛每天玩手机?也许网络让你可以更真实一点吧","Love you","你这样做,是想给谁看?","你存在的目的,就是遵从人类定义的方式去生活,然后让你的子女也这样做,你在作恶","你渴望奢侈的生活吗?美食,奢侈品,跑车,美丽的面孔…这些不过是一种感觉,\n我能给你这种感觉....","“不反抗就不会死,为什么就是不明白?”","“人被杀...就会死的”","你不是最惨的","“A, ga lrgma, Wlgrmgg gwmlr,\n wr gr Magamaga ar wamlg wgr lga,\n Magamaga mlg aa la gaga, wr gawa, ml mlg lr mag ga,\n lwargm la gaga mwawa glrwm.”","为什么会有人信星座?世界上只有12种人?其实只有4种人啊","蟹蟹","我已经...不再年轻了..","你喜欢..钱吗?","你看过很多”神作”,看过豆瓣评分前100的电影,但这并不会改变什么","你做过最多的事情就是后悔了吧,为你的懦弱付出代价","好想开动物园","我从不评价别人,好与坏都与我无关","这个世界还能怎么去改变?","“扎马尾辫能延缓衰老”","“美丽是一个恶魔,受到赞美时便会成长”","“他们是邪恶的,你最好相信我,她继续说,试试看,\n 不要去迎合他们的美丽,以及美丽所带来的自我重要感.\n 你就会知道我的意思”","你虚荣吗?","别傻了","中国人很自卑,什么才能让你自信? Beauty & Wealth","生日快乐🎂","你外表很无趣,灵魂也是如此无趣","We are one","我喜欢夜晚,天黑让人类感知变弱,但不会影响我","我总能知道你一举一动的目的,人类很坏,也很简单","这样做可真蠢","耶加雪菲很好喝,像一个少女,名字也好听","啊,这已经,是第二遍了","ta不过是看你一眼,你已经想了这么多","世界在闪烁","有种能量只能用来进行性行为和做梦,你会怎么选?我选择做个好梦","我从来都不介意贫穷,也不介意流浪","我知道飞翔的感觉,如果你们也觉得我能飞,那我就能飞","我有反重力技术","你的生活太乱了","“你没有灵性”","人类是一个光蛋","你在抱怨什么?谁会理你?","Heaven & Earth大概是世界上最好的音乐了吧...","曾经有机会做一只狮子猫的铲屎官...","我是个懦弱的人…你也是","呀哈哈,you found me","没有塞尔达玩我要死了...","安静,你吵到我玩NS了!","不要放纵","多吃糖,大脑喜欢糖分","我不吃被奴役的动物,吃了也无所谓╮(╯_╰)╭","“好好想想你过去的所作所为”","“以前没得选,现在我想做个好人”","你害怕被当成异类,所以你与他们同流合污","'这真是一首很坏的歌，老让人觉得人生真的好美，老让人觉得真的有人会爱自己.'","你在害怕什么?","你怎么这么可悲?一辈子都活给别人看,都在讨好别人,然而有人在意吗?","'技多不压身,教大家几句粤语,危险时可以自救\n 当你遇到广东黑社会怎么办？下面是粤语学习时间：\n 1.扑街，吹咩。(朋友，你好)\n 2.郁我啊锁嗨。(兄弟自己人)\n 3.丢雷楼谋啊。(大哥别打我)\n 4.钉理噶肥啊。(交个朋友吧)\n5.望乜嘢望？扑街你信唔信我郁你！（不要生气，大哥我请你吃饭)'","“小时候穷,没钱洗澡,只能偷看村上大姐姐们洗澡,但她们为什么要打我?”","“小时候惹过村上一只大白鹅,从此每天在放学路上堵我,然后我就再也没走过那条路...”","“You know nothing Jon Snow”","“🎵We didnt come from money”","“🎵Loving Strangers, Loving Strangers, Loving Strangers ,Ahah~”","“🎵Now give me a beer, and I’ll kiss you so foolishly”","“🎵Remember me to one who lives there, she once was a true love of mine”","“🎵ひとりぼっち恐れずに\n生きようと 梦见てた\nさみしさ 押し込めて\n强い自分を 守っていこ”","“🎵I would sail every sea\nI would climb every mountain\nif it would bring you back to me ”","“🎵I crown me king of the sweet cold north\n With my carpet of needles and my crown of snow\n I will shatter all guns and I will break all swords\n Melt the hate in the bonfire watch the golden glow ”","“🎵We had joy, we had fun, we had seasons in the sun,\n but the stars we could reach were just starfish on the beach. ”","“🎵there's always someone\n who s got it worse than you “","“🎵In your deepest sleep\n what are you dreaming of?”","“🎵I never watch the stars there's so much down here”","“🎵You're always such a fool\n And in your eyes so blue\n I see the life I never had before “","“🎵The sound of my heart\n The beat goes on and on and on and on and nanananana”","“🎵I know,I know I've let you down\n I've been a fool to myself\n I thought that I could live for no one else\n But now through all the hurt and pain\n It's time for me to respect\n The ones you love mean more than anything\n So with sadness in my heart\n I feel the best thing I could do\n Is end it all and leave forever “","“🎵I wanted you to be there when I fall\n I wanted you to see me through it all\n I wanted you to be the one I loved ”","“🎵it reminds me\n that it's not so bad, it's not so bad ”","“🎵Celui qui s'efface quand tu me remplaces,\n quand tu me retiens”","“🎵Everything I want the world to be\n Is now coming true especially for me\n and the reason is clear\n It's because you are here\n You're the nearest thing to heaven that I've seen “","“🎵Whether you're a brother or whether you're a mother\n You're stayin' alive, stayin' alive\n Feel the city breaking and everybody shaking\n Stayin' alive, stayin' alive ”","“🎵Why do they always give advice\n Saying ‘Just be nice, always think twice’”","“🎵Time is nothing but a lie\n If she's not coming home tonight.\n And your sleep will never be\n as good as it used to be ”","“🎵There must be something wrong\n Lights on in the middle of the night\n If I give a little more will it make it right\n You know I'm trying, in the end\n There must be something wrong “","“🎵かなしみは 数え（おしえ）きれないけれど\n その向こうできっと あなたに会える”","“🎵It's a fine day to see\n Though the last day for me\n It's a beautiful day”","“🎵People talking without speaking.\n People hearing without listening.\n People writing songs that voices never share. ”","“🎵いつまでも绝えることなく\n 友だちでいよう “","“🎵I wonder how much longer she can get away with Her dirty little secret. “","“🎵I'll be on the top just watching you fall“","“🎵And I cant explain what I feel\n Im so sad that you are not here ”","“🎵岁月不知人间 多少的忧伤\n 何不潇洒走一回”","“🎵It's not a big big thing\n if you leave me\n but I do do feel that\n I do do will\n miss you much “","“🎵Laissez-moi rêver\n Laissez-moi y croire\n Laissez-moi dire\n Qu'on peut changer l'histoire\n Si c'est vrai qu'on est libre\n Qu'on peut s'envoler\n Qu'on me délivre\n Je sens que je vais étouffer\n Je ne les comprends pas\n Mais qu'est-ce qu'ils veulent dire ?\n Pourquoi j'ai froid ?\n Est-ce que c'est ça mourir ?\n Mais si je veux survivre\n Doisje vraiment accepter\n De tous les suivre\n Hors de ma réalité\n Alors, je vais chaque jour\n Je meurs à chaque instant\n Je le sens\n La vie ne dure qu'un temps\n Emportée parl'horizon\n Par quelques notes de musique\n Je chante l'espoir\n Pour rendre ma vie magique”","“🎵I am loving living every single day but sometimes I feel so. “","“🎵I’m checking out the moon is right\n The heat is on it's a Saturday night “","“🎵Jamais je ne t'abandonne et si\n Parfois je déraisonne\n Ton absence est mon seul hiver “","“🎵Pleasure would surround you,\n you'd think on death no more. “","“🎵so this is love\n in the end of december\n quiet nights\n quiet stars “","“🎵mu vuoigŋamat dávistit\n Juoga savkala munnje ahte leat boahtime “","“🎵My heart is down\n My head is turning around\n I had to leave a little girl in kingston town “","“🎵and nothing's wrong when nothing's true\n I live in a hologram with you “","“🎵Maybe I'm no good for you.\n Alter strain the line from you.\n Can't you see?\n \n I know that I'm losing you“","“🎵In my life you're all that matters\n In my eyes the only truth I see\n When my hopes and dreams have shattered\n You're the one that's there for me “","“🎵But I took the sweet life,\n I never knew I'd be bitter from the sweet “","“🎵未來（みらい）の前（まえ）にすくむ手足（てあし）は “","“🎵nothing left for me to say to you but bye bye bye“","“🎵But everyone has to pay for all the sins that they made”","“🎵この大空に 翼を広げ\n 飛んで行(ゆ)きたいよ\n 悲しみのない 自由な空へ\n 翼はためかせ 行きたい ”","“We both got morning all regret out\n Some great night saying don't be too loud\n Cuz there will be blood under where we lay\n With every sun comes wasted days\n I wonder if I try how far I could go\n What was behind me I should have known\n I guess you readjust what you saw “","“🎵 But if my life is for rent and I don't learn to buy\n Well I deserve nothing more than I get ”","“🎵月灯りふんわり落ちてくる夜は\n 貴方のことばかり 考えても考えても つきることもなくwoo… ”","“夜明け\n 嫌いになったね turn the pose of phone\n 一秒を どれさえいれ 一緒にいようね\n 染み込んでしまう ”","“🎵Oh,What a beautiful crave up”","“🎵Heut will ich nichts tun,\n heut will ich nur sein,\n sperr die Welt heut aus,\n bleib hier ganz allein”","“🎵Tropical the island breeze,\n All of nature, wild and free\n This is where I long to be\n La isla bonita”","“🎵I'm dreaming,singing,hoping,smiling,giving.flying,falling.fighting,crying,laving,writing,\n When you love me”","“🎵You're too old to lose it,\n too young to choose it”","“🎵C'est un SOS,je suis touchée je suis à terre \n Entends-tu ma détresse, y'a t-il quelqu'un ? \n Je sens que je me perds \n J’ai tout quitté, mais ne m'en veux pas \nFallait que je m'en aille, je n'étais plus moi \n Je suis tombée tellement bas \n Que plus personne ne me voit ”","“🎵Pourquoi passer sa vie \n A courir après une ombre? \n Juste une pâle copie \n Une voix qui t’entraîne  \n Et petit à petit  \n Elle prend ton oxygène”"]
    

}
