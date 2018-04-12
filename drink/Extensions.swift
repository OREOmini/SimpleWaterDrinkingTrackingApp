//
//  Extensions.swift
//  drink
//
//  Created by wangyunwen on 18/4/12.
//  Copyright © 2018年 YunwenWang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol ViewChainable: class { }


extension ViewChainable where Self: UIView {
    @discardableResult
    func config(_ config: (Self) -> Void) -> Self {
        config(self)
        return self
    }
}


extension UIView: ViewChainable {
    
    @discardableResult
    func add(to targetView: UIView) -> Self {
        targetView.addSubview(self)
        return self
    }
    
    @discardableResult
    func layout(snpMaker: (ConstraintMaker) -> Void) -> Self {
        self.snp.makeConstraints { (make) in
            snpMaker(make)
        }
        return self
    }
    
    @discardableResult
    func updateLayout(snpMaker: (ConstraintMaker) -> Void) -> Self {
        self.snp.updateConstraints { (make) in
            snpMaker(make)
        }
        return self
    }
    
    @discardableResult
    func reLayout(snpMaker: (ConstraintMaker) -> Void) -> Self {
        self.snp.remakeConstraints { (make) in
            snpMaker(make)
        }
        return self
    }
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.characters.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
