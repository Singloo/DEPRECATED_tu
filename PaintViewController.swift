//
//  PaintViewController.swift
//  tu
//
//  Created by Rorschach on 2016/10/29.
//  Copyright © 2016年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import AVOSCloud
import SVProgressHUD
import Material

class PaintViewController: UIViewController,UIImagePickerControllerDelegate{

    var tools = [pencil(),eraser(),dot(),brush()]
    @IBOutlet weak var Board: board!

    @IBOutlet weak var colorPicker: UIButton!
    @IBOutlet weak var Pencil: UIButton!
    @IBOutlet weak var Eraser: UIButton!
    @IBOutlet weak var Circle: UIButton!
    @IBOutlet weak var Ruler: UIButton!
    @IBOutlet weak var upBK: UIImageView!
    @IBOutlet weak var downBK: UIImageView!
    @IBOutlet weak var saveBtn: UIButton!
    var isNewWork:Bool = true
    var currentObject:AVObject?
    
    var currentWidth:CGFloat!
    var currentColor:UIColor = UIColor.black
    
    var touchView:UIView!
    var lastScale:CGFloat = 1 {
        didSet{
            print(":::\(lastScale)")
            self.moveBoard(currentScale: lastScale)
        }
    }
    
//    var lastCenter:CGPoint!
    var selectedImage = ["mls_pencil_selected","mls_eraser_selected","mls_brush_selected","mls_dot_selected"]
    var nonSelectedImage = ["mls_pencil","mls_eraser","mls_brush","mls_dot"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color.grey.lighten3

        self.Board.isUserInteractionEnabled = true
        
        self.Board.brush = tools[0]
        self.currentWidth = self.Board.strokeWidth
        
        touchView = UIView(frame: CGRect(x: 0, y: SCREEN_HEIGHT - 170, width: 100, height: 100))
        touchView.backgroundColor = Color.lightGreen.lighten4
        touchView.isUserInteractionEnabled = true
        touchView.isHidden = true
        self.view.addSubview(touchView)
        self.view.bringSubview(toFront: touchView)
        
        setGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //
    func moveBoard(currentScale:CGFloat){
        if currentScale == 1{
            self.touchView.isHidden = true
        }else if currentScale > 1{
            self.touchView.isHidden = false
        }
    }
    // gestureRecoginzer
    func setGesture(){
        self.Board.isExclusiveTouch = true
        
        let panOne = UIPanGestureRecognizer(target: self, action: #selector(PaintViewController.moveBoard(pan:)))
        panOne.maximumNumberOfTouches = 1
        panOne.minimumNumberOfTouches = 1
        
        self.touchView.addGestureRecognizer(panOne)

        
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(PaintViewController.pinchGesture(pinch:)))
        self.Board.addGestureRecognizer(pinch)

    }
    
    func moveBoard(pan:UIPanGestureRecognizer){
        let point = pan.translation(in: self.touchView)
        self.Board.center = CGPoint(x: self.Board.center.x + point.x * lastScale * 1.5, y: self.Board.center.y + point.y * lastScale * 1.5)
        pan.setTranslation(CGPoint.zero, in: self.touchView)
    }
    
    
    func pinchGesture(pinch:UIPinchGestureRecognizer){
        let scale = pinch.scale

        if scale > 1 {
            self.moveBoard(currentScale: scale)
            self.Board.transform = CGAffineTransform(scaleX: lastScale * scale, y: lastScale * scale)
        }else{
            self.moveBoard(currentScale: scale)
            self.Board.transform = CGAffineTransform(scaleX: lastScale * scale, y: lastScale * scale)
           
        }
        
        if pinch.state == .ended{
            if scale > 1{
                lastScale = lastScale * scale
                if lastScale > 3{
                    self.Board.transform = CGAffineTransform.init(scaleX: 3, y: 3)
                    self.lastScale = 3
                }
            }else{
                lastScale = lastScale * scale
                if lastScale < 1{
                    self.Board.center = CGPoint(x: SCREEN_WIDTH/2, y: SCREEN_HEIGHT/2)
                    self.Board.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                    self.lastScale = 1
                }
            }
        }

    }
    
    @IBAction func pencilPressed(_ sender: AnyObject) {
        self.Board.brush = self.tools[0]
        btnSelected(btn: 0)
        

    }
    
    @IBAction func eraserPressed(_ sender: AnyObject) {
        self.Board.brush = self.tools[1]
        btnSelected(btn: 1)


    }
    
    @IBAction func rulerPressed(_ sender: AnyObject) {
        self.Board.brush = self.tools[2]
        btnSelected(btn: 3)
    }
    
    @IBAction func circlePressed(_ sender: AnyObject) {
        self.Board.brush = self.tools[3]
        btnSelected(btn: 2)
 
    }
    
    @IBAction func colorPickerPressed(_ sender: AnyObject) {
        let vc = ColorPickerViewController()
        vc.selectedWidth = self.currentWidth
        vc.currentColor = self.currentColor
        vc.delegate = self
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = CGSize(width: 230, height: 262)
        let popover:UIPopoverPresentationController = vc.popoverPresentationController!
        popover.delegate = self
        popover.sourceView = self.view
        popover.sourceRect = CGRect(x: SCREEN_WIDTH - 40, y: SCREEN_HEIGHT - 70, width: 65, height: 65)
        popover.permittedArrowDirections = .down
        self.present(vc, animated: true) {
            
        }
    }
    
    //seleted
    func btnSelected(btn:Int) {
        switch btn {
        case 0:
            Pencil.setImage(UIImage(named: selectedImage[0]), for: .normal)
            Eraser.setImage(UIImage(named: nonSelectedImage[1]), for: .normal)
            Circle.setImage(UIImage(named: nonSelectedImage[2]), for: .normal)
            Ruler.setImage(UIImage(named: nonSelectedImage[3]), for: .normal)
        case 1:
            Pencil.setImage(UIImage(named: nonSelectedImage[0]), for: .normal)
            Eraser.setImage(UIImage(named: selectedImage[1]), for: .normal)
            Circle.setImage(UIImage(named: nonSelectedImage[2]), for: .normal)
            Ruler.setImage(UIImage(named: nonSelectedImage[3]), for: .normal)
        case 2:
            Pencil.setImage(UIImage(named: nonSelectedImage[0]), for: .normal)
            Eraser.setImage(UIImage(named: nonSelectedImage[1]), for: .normal)
            Circle.setImage(UIImage(named: selectedImage[2]), for: .normal)
            Ruler.setImage(UIImage(named: nonSelectedImage[3]), for: .normal)
        case 3:
            Pencil.setImage(UIImage(named: nonSelectedImage[0]), for: .normal)
            Eraser.setImage(UIImage(named: nonSelectedImage[1]), for: .normal)
            Circle.setImage(UIImage(named: nonSelectedImage[2]), for: .normal)
            Ruler.setImage(UIImage(named: selectedImage[3]), for: .normal)

        default:
            break
        }
    }
    
    
    @IBAction func buildNew(_ sender: AnyObject) {
        self.Board.clearBoard()
        self.isNewWork = true
        self.Board.center = CGPoint(x: SCREEN_WIDTH/2, y: SCREEN_HEIGHT/2)
        self.lastScale = 1
        self.Board.transform = CGAffineTransform.init(scaleX: 1, y: 1)
    }
    
    @IBAction func saveWorks(_ sender: AnyObject) {
        SVProgressHUD.show()
        self.saveBtn.isEnabled = false
        if isNewWork{
            let userWork = self.Board.takeImage()
            let object = AVObject(className: "UserWorks")
            let file = AVFile(data: UIImagePNGRepresentation(userWork)!)
            object.setObject(file, forKey: "userWork")
            object.setObject(AVUser.current(), forKey: "user")
            object.saveInBackground { (success, error) in
                if success{
                    self.isNewWork = false
                    self.currentObject = object
                    SVProgressHUD.showSuccess(withStatus: "保存成功!~")
                    SVProgressHUD.dismiss(withDelay: 1)
                    self.saveBtn.isEnabled = true
                }else{
                    let e1 = error as! NSError
                    SVProgressHUD.showError(withStatus: "网络不稳定..保存失败...\(e1.code)")
                    SVProgressHUD.dismiss(withDelay: 1)
                    self.saveBtn.isEnabled = true
                }
            }
        }else{
            let object = AVObject(className: "UserWorks", objectId: (currentObject?.objectId)!)
            let userWork = self.Board.takeImage()
            let file = AVFile(data: UIImagePNGRepresentation(userWork)!)
            object.setObject(file, forKey: "userWork")
            object.saveInBackground({ (success, error) in
                if success{
                    self.isNewWork = false
                    SVProgressHUD.showSuccess(withStatus: "保存成功!~")
                    SVProgressHUD.dismiss(withDelay: 1)
                    self.saveBtn.isEnabled = true
                }else{
                    self.isNewWork = false
                    let e1 = error as! NSError
                    SVProgressHUD.showError(withStatus: "网络不稳定..保存失败...\(e1.code)")

                    self.saveBtn.isEnabled = false
                }
            })
        }
        
    }
    
    @IBAction func undo(_ sender: AnyObject) {
        self.Board.undo()
    }
    
    @IBAction func redo(_ sender: AnyObject) {
        self.Board.redo()
    }
    
    @IBAction func quit(_ sender: AnyObject) {
        self.dismiss(animated: true) { 
            
        }
    }
}

extension PaintViewController:UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension PaintViewController:ColorPickerDelegate{
    func selectedColorAndWidth(color: UIColor, width:CGFloat) {
        self.Board.strokeColor = color
        self.Board.strokeWidth = width
        self.currentWidth = width
        self.currentColor = color
    }

}
