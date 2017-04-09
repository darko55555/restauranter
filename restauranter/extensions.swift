//
//  extensions.swift
//  restauranter
//
//  Created by Darko Dujmovic on 01/04/2017.
//  Copyright © 2017 Darko Dujmovic. All rights reserved.
//

import UIKit

class extensions: NSObject {

}

extension UIViewController{
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}

extension UIView{
    //animation extension
    func shakeAndColor() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.06
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: self.center.x - 15, y:self.center.y)
        animation.toValue = CGPoint(x: self.center.x + 15, y:self.center.y)
        self.layer.add(animation, forKey: "position")
       
        
//        let startColor = self.backgroundColor
//        let endColor = UIColor(red:0.97, green:0.26, blue:0.34, alpha:1.0)
//        self.backgroundColor = endColor
//        self.layer.borderColor = endColor.cgColor
//        
//        UIView.animate(withDuration: 1) { 
//            self.backgroundColor = endColor
//            self.layer.borderColor = endColor.cgColor
//            UIView.animate(withDuration: 1, animations: { 
//                self.backgroundColor = startColor
//                self.layer.borderColor = startColor?.cgColor
//            })
//        }
    }
}
