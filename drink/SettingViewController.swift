//
//  SettingViewController.swift
//  drink
//
//  Created by wangyunwen on 18/4/12.
//  Copyright © 2018年 YunwenWang. All rights reserved.
//

import Foundation
import UIKit
import TTRangeSlider

class SettingViewController: UIViewController {
    var totalAmountSlider:TTRangeSlider?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        setupElement()
        print("setting")
        self.view.backgroundColor = .white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupElement() {
        totalAmountSlider = TTRangeSlider()
        totalAmountSlider?.add(to: self.view)
            .layout(snpMaker: { (make) in
                make.center.equalToSuperview()
                make.width.equalTo(300)
                make.height.equalTo(40)
            }).config({ (view) in
                view.tintColor = themeColor
                view.tintColorBetweenHandles = themeColor
                view.minValue = 0
                view.maxValue = 3500
                view.selectedMinimum = 0
                view.selectedMaximum = 3500
                view.addTarget(self, action: #selector(amountChange(slider:)), for: .touchUpInside)
                view.enableStep = true
                view.step = 10
                
                view.selectedMinimum = Float(getDrinkingAmount())
                view.selectedMaximum = Float(getTotalAmount())
            })
        
        CustomedButton(frame: CGRect(x: 100, y: 300, width: 30, height: 30), color: themeColor!)
            .add(to: self.view)
            .layout { (make) in
                make.right.equalToSuperview().offset(-25)
                make.top.equalToSuperview().offset(40)
                make.width.height.equalTo(30)
            }.config { (view) in
                view.setTitle("!", for: .normal)
                view.layer.borderWidth =  1
                
                view.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        }

    }
    
    func amountChange(slider: TTRangeSlider) {
        print(slider.selectedMinimum)
        changeCoreDataDrinkingAmountTo(newAmount: Int(slider.selectedMinimum))
        changeCoreDataTotalAmountTo(newAmount: Int(slider.selectedMaximum))
    }
    
    func goBack() {
        let view = ViewController()
        self.present(view, animated: true, completion: nil)
    }

}
