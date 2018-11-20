//
//  PhotoPickerViewController.swift
//  tu
//
//  Created by Rorschach on 2016/10/31.
//  Copyright © 2016年 Xiaofeng Yang. All rights reserved.
//

import UIKit

protocol PhotoPickerDelegate{
    func getImageFromPicker(image:UIImage)
}

class PhotoPickerViewController: UIViewController,UIImagePickerControllerDelegate {

    var alert:UIAlertController?
    var picker:UIImagePickerController!
    var delegate:PhotoPickerDelegate!
    

//    init(){
//        super.init(nibName: nil, bundle: nil)
//        self.modalPresentationStyle = .fullScreen
//        self.view.backgroundColor = UIColor.white
//        self.view.alpha = 0
//        self.picker = UIImagePickerController()
//        self.picker.delegate = self
//        self.picker.allowsEditing = false
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        self.view.backgroundColor = UIColor.clear.withAlphaComponent(0)
        self.picker = UIImagePickerController()
        self.picker.delegate = self
        self.picker.allowsEditing = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if alert == nil{
            self.alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            self.alert?.addAction(UIAlertAction(title: "打开本地相册", style: .default, handler: { (action) in
                self.openLocal()
            }))
//            self.alert?.addAction(UIAlertAction(title: "打开摄像头", style: .default, handler: { (action) in
//                self.openCamera()
//            }))
            self.alert?.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                self.dismiss(animated: true, completion: { 
                    
                })
            }))
            
            self.present(alert!, animated: true, completion: { 
              
            })
        }
        
    }
    
    
    func openLocal() {
        self.picker.sourceType = .photoLibrary
        self.present(picker, animated: true) { 
            
        }
    }
    
//    func openCamera() {
//        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
//            self.picker.sourceType = .camera
//            self.present(picker, animated: true, completion: { 
//                
//            })
//        }
//        else{
//            let alert = UIAlertController(title: "此机型无摄像头", message: nil, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "确认", style: .cancel, handler: { (action) in
//                self.dismiss(animated: true, completion: { 
//                    
//                })
//            }))
//            self.present(alert, animated: true, completion: { 
//                
//            })
//        }
//    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.picker.dismiss(animated: true) { 
            self.dismiss(animated: true, completion: { 
                
            })
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.picker.dismiss(animated: true) { 
            self.dismiss(animated: true, completion: { 
                self.delegate.getImageFromPicker(image: image)
            })
        }
    }


}
