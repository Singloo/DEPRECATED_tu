//
//  board.swift
//  tu
//
//  Created by Rorschach on 16/10/19.
//  Copyright © 2016年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import SwifterSwift
enum DrawingState {
    case began,moved,ended
}

class board: UIImageView {
    private var drawingState:DrawingState!
    private var boardMemoryManager = memoryManager()
    var realImage:UIImage?
    
    var brush:tools?

    var strokeWidth:CGFloat?
    var strokeColor:UIColor?

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.strokeColor = UIColor.black
        self.strokeWidth = 3
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
        self.strokeColor = UIColor.black
        self.strokeWidth = 3


    }
    
    func takeImage() -> UIImage{
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
        
        self.backgroundColor?.setFill()
        UIRectFill(self.bounds)
        self.image?.draw(in: self.bounds)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let brush = self.brush {
            brush.lastPoint = nil
            
            brush.beginPoint = touches.first?.location(in: self)
            brush.samplePoints.removeAll()
            brush.samplePoints.append((touches.first?.location(in: self))!)
            brush.endPoint = brush.beginPoint
            self.drawingState = .began
        
            self.drawingImage()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let brush = self.brush {
            brush.samplePoints.append((touches.first?.location(in: self))!)
            brush.endPoint = touches.first?.location(in: self)
        
            brush.lastPoint = touches.first?.previousLocation(in: self)
            self.drawingState = .moved
            self.drawingImage()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let brush = self.brush {
            brush.endPoint = nil
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let brush = self.brush {
            
            brush.endPoint = touches.first?.location(in: self)
            brush.lastPoint = touches.first?.previousLocation(in: self)
            brush.samplePoints.append((touches.first?.location(in: self))!)
            self.drawingState = .ended
            self.drawingImage()
        }
    }
 
    
    var canUndo:Bool {
        get {
            return self.boardMemoryManager.canUndo
        }
    }
    var canRedo:Bool {
        get {
            return self.boardMemoryManager.canRedo
        }
    }
    
    func undo() {
        if self.canUndo == false {
            return
        }
        self.image = self.boardMemoryManager.imageForUndo()
        self.realImage = self.image
    }

    func redo() {
        if self.canRedo == false {
            return
        }
        self.image = self.boardMemoryManager.imageForRedo()
        self.realImage = self.image
    }
    
    func clearBoard() {
        self.realImage = nil
        self.boardMemoryManager.images.removeAll()
        self.boardMemoryManager.index = -1
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)

        self.image = UIGraphicsGetImageFromCurrentImageContext()


        UIGraphicsEndImageContext()
    }
    
    private func drawingImage() {

        if let brush = self.brush {
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
            
            let context = UIGraphicsGetCurrentContext()
    
            UIColor.clear.setFill()
            UIRectFill(self.bounds)
            
            context?.setLineCap(.round)
            context?.setLineWidth(self.strokeWidth!)
            context?.setStrokeColor(self.strokeColor!.cgColor)
            
            if let realImage = self.realImage {
                realImage.draw(in: self.bounds)
            }
            
            brush.strokeWidth = self.strokeWidth
            brush.drawInContext(context: context!)
            context?.strokePath()
            
            let previewImage = UIGraphicsGetImageFromCurrentImageContext()
            if self.drawingState == .ended || brush.supportedContinuesDrawing() {
                self.realImage = previewImage
            }
            
            UIGraphicsEndImageContext()
            
            if self.drawingState == .ended {
                self.boardMemoryManager.addImage(image: self.image!)
            }
            
            self.image = previewImage
            
            brush.lastPoint = brush.endPoint
        }
        
    }
    
    private class memoryManager {
        class ImageFault:UIImage{}
        private static var INVALID_INDEX = -1
        var images = [UIImage]()
        var index = INVALID_INDEX
        
        func clearImageIndex() {
            images = [UIImage]()
            index = -1
        }
        
        var canUndo:Bool {
            get{
                return index != memoryManager.INVALID_INDEX
            }
        }
        
        var canRedo:Bool {
            get{
                return (index + 1) < images.count
            }
        }
        
        func addImage(image:UIImage) {
            if index < images.count - 1{
                images[index + 1 ... images.count - 1] = []
            }
            images.append(image)
            
            index = images.count - 1
            
            setCache()
        }
        
        func imageForUndo() -> UIImage? {
            if self.canUndo {
                index -= 1
                if self.canUndo == false {
                    return nil
                }else{
                    setCache()
                    return images[index]
                }
            }else{
                return nil
            }
        }
        
        func imageForRedo() -> UIImage? {
            var image:UIImage? = nil
            if self.canRedo {
                image = images[index + 1]
            }
            
            setCache()
            return image
        }
        
        private static let cahcesLength = 3
        
        private static let basePath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        private func setFaultImage(image:UIImage, index:Int) {
            if !image.isKind(of: ImageFault.self) {
                let imagePath = memoryManager.basePath.appendingPathComponent("\(index)")
                do{
                    try UIImagePNGRepresentation(image)!.write(to: URL(fileURLWithPath: imagePath))
                    images[index] = ImageFault()
                }catch{
                    
                }
            }
        }
        
        private func setRealImage(image:UIImage, index:Int) {
            if image.isKind(of: ImageFault.self) {
                let imagePath = memoryManager.basePath.appendingPathComponent("\(index)")
 
                let data = UIImagePNGRepresentation(image)
            
                do{
                    try data?.write(to: URL(fileURLWithPath: imagePath))
                    let imgData = try NSData(contentsOfFile: imagePath) as Data
                    images[index] = UIImage(data: imgData)!

                }catch{
                    
                }
            }
        }
        
        private func setCache() {
            if images.count >= memoryManager.cahcesLength {
                let location = max(0, index - memoryManager.cahcesLength)
                let length = min(images.count - 1, index + memoryManager.cahcesLength)
                for i in location ... length {
                    autoreleasepool {
                        let image = images[i]
                        
                        if i > index - memoryManager.cahcesLength && i < index + memoryManager.cahcesLength {
                            setRealImage(image: image, index: i)
                        }else{
                            setFaultImage(image: image, index: i)
                        }
                    }
                }
            }
        }
        
    }
}
