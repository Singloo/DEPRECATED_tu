//
//  ColorPickerViewController.swift
//  tu
//
//  Created by Rorschach on 2017/5/6.
//  Copyright © 2017年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import SnapKit
import Material
import SwifterSwift

protocol ColorPickerDelegate {
    func selectedColorAndWidth(color:UIColor, width:CGFloat)
}

class ColorPickerViewController: UIViewController {

    var paletteView:PaletteView!
    var blackColor:UIButton!
    var sureBtn:UIButton!
    
    var delegate:ColorPickerDelegate!
    var selectedColor:UIColor!
    var selectedWidth:CGFloat!
    
    var widthPreview:UIView!
    
    var widthSlider:UISlider!
    
    var currentColor:UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

    }
    
    
    func prepareView(){
        paletteView = PaletteView(frame: CGRect(x: 0, y: 0, width: 230, height: 230), colorPickerImage: UIImage(named: "palette"))
        self.view.addSubview(paletteView)
        paletteView.currentColorBlock = {(R:CGFloat,G:CGFloat,B:CGFloat,L:CGFloat) ->Void in
            self.selectedColor = UIColor(red: R, green: G, blue: B, alpha: L)
            self.blackColor.layer.borderColor = UIColor.clear.cgColor
        }
        
        blackColor = UIButton()
        blackColor.layer.borderWidth = 2
        blackColor.backgroundColor = UIColor.black
        blackColor.addTarget(self, action: #selector(ColorPickerViewController.blackColorSelected(sender:)), for: .touchUpInside)
        self.view.addSubview(blackColor)
        blackColor.snp.makeConstraints { (make) in
            make.left.equalTo(paletteView.snp.left).offset(5)
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.top.equalTo(paletteView.snp.bottom).offset(-3)
        }
        
        sureBtn = UIButton()
        sureBtn.layer.borderWidth = 2
        sureBtn.layer.cornerRadius = 3
        sureBtn.layer.borderColor = Color.lightGreen.base.cgColor
        sureBtn.backgroundColor = UIColor.white
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(Color.lightGreen.base, for: .normal)
        sureBtn.titleLabel?.font = RobotoFont.regular(with: 14)
        sureBtn.addTarget(self, action: #selector(ColorPickerViewController.sureBtnTapped(sender:)), for: .touchUpInside)
        self.view.addSubview(sureBtn)
        sureBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(blackColor)
            make.right.equalTo(paletteView.snp.right).offset(-5)
            make.width.equalTo(40)
            make.height.equalTo(25)
        }
        
        widthPreview = UIView()
        widthPreview.layer.cornerRadius = selectedWidth/2
        widthPreview.layer.masksToBounds = true
        widthPreview.backgroundColor = UIColor.black
        self.view.addSubview(widthPreview)
        widthPreview.snp.makeConstraints { (make) in
            make.centerY.equalTo(blackColor)
            make.width.equalTo(selectedWidth)
            make.height.equalTo(selectedWidth)
            make.left.equalTo(blackColor.snp.right).offset(3)
            
        }
        
        
        widthSlider = UISlider()
        widthSlider.minimumValue = 3.0
        widthSlider.maximumValue = 13.0
        widthSlider.setValue(selectedWidth.float, animated: true)
        widthSlider.minimumTrackTintColor = Color.lightGreen.base
        widthSlider.setThumbImage(UIImage(named: "mls_thumb"), for: .normal)
        widthSlider.addTarget(self, action: #selector(ColorPickerViewController.widthSliderSwaped(sender:)), for: .valueChanged)
        self.view.addSubview(widthSlider)
        widthSlider.snp.makeConstraints { (make) in
            make.left.equalTo(blackColor.snp.right).offset(19)
            make.centerY.equalTo(blackColor)
            make.right.equalTo(sureBtn.snp.left).offset(-3)
            make.height.equalTo(13)
        }
        
        
    }

    func blackColorSelected(sender:UIButton){
        self.selectedColor = UIColor.black
        self.blackColor.layer.borderColor = Color.lightGreen.base.cgColor
    }
    
    func sureBtnTapped(sender:UIButton){
        if selectedColor == nil{

            delegate.selectedColorAndWidth(color: currentColor!, width: selectedWidth)
            self.dismiss(animated: true, completion: {
                
            })

            
        }else{
            delegate.selectedColorAndWidth(color: selectedColor, width: selectedWidth)
            self.dismiss(animated: true, completion: {
                
            })
        }
        
    }
    
    func widthSliderSwaped(sender:UISlider){
        self.selectedWidth = sender.value.cgFloat
        widthPreview.layer.cornerRadius = selectedWidth/2
        widthPreview.snp.updateConstraints { (make) in
            make.width.equalTo(selectedWidth)
            make.height.equalTo(selectedWidth)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
