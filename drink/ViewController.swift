//
//  ViewController.swift
//  drink
//
//  Created by wangyunwen on 18/4/12.
//  Copyright © 2018年 YunwenWang. All rights reserved.
//

import UIKit
import SnapKit
import KDCircularProgress
import CoreData

var CONCRETE:UIColor = hexStringToUIColor(hex: "#95A5A6")
var ASBESTOS:UIColor = hexStringToUIColor(hex: "#7F8C8D")
var TEAL200:UIColor = hexStringToUIColor(hex: "#80CBC4")

var themeColor:UIColor? = .lightGray

class ViewController: UIViewController {
    
    var circleView:KDCircularProgress?
    var amountLabel:UILabel?
    
    
    var totalAmount:Int?
    
    var standardAmount = 2000
    
    override func viewWillAppear(_ animated: Bool) {
        let ud = UserDefaults.standard
        let firstLaunch:Bool = ud.bool(forKey: "Launched");
        if(!firstLaunch && !hasData()){
            //第一次启动
            print("first")
            deleteAll()
            let app = UIApplication.shared.delegate as! AppDelegate
            let context = app.persistentContainer.viewContext
            
            //创建User对象
            let amount = NSEntityDescription.insertNewObject(forEntityName: "Amount",
                                                           into: context) as! Amount
            
            //对象赋值
            amount.drinkingAmount = 0
            amount.totalAmount = 2000
            
            //保存
            do {
                try context.save()
                print("保存成功！")
            } catch {
                fatalError("不能保存：\(error)")
            }
        }else{
            print("not first")
            ud.setValue(true, forKey: "Launched")
            ud.synchronize()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        totalAmount = getDrinkingAmount()
        standardAmount = getTotalAmount()
        themeColor = CONCRETE
        setupElement()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupElement() {
        self.view.backgroundColor = .white
        circleView = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
            .add(to: self.view)
            .layout(snpMaker: { (make) in
                make.center.equalToSuperview()
                make.width.height.equalTo(400)
        })
        circleView!.clockwise = true
        circleView!.set(colors: .white)
        circleView!.glowMode = .forward
        circleView!.glowAmount = 0
        circleView!.trackColor = themeColor!
        circleView!.startAngle = -90
        circleView!.progressThickness = 0.3
        circleView!.trackThickness = 0.5
        moveCircle()
        
        let size = 70
        
        amountLabel = UILabel().add(to: self.view)
            .layout { (make) in
                make.center.equalTo(circleView!)
                make.edges.equalTo(circleView!)
        }.config { (view) in
            view.text = String(totalAmount!)
            view.textAlignment = .center
            view.textColor = .gray
            view.font = UIFont.boldSystemFont(ofSize: 30)
        }
        
        
        CustomedButton(frame: CGRect(x: 0, y: 0, width: size, height: size), color: themeColor!)
            .add(to: self.view)
            .layout { (make) in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(circleView!.snp.top)
                make.width.height.equalTo(size)
        }.config { (view) in
            view.setTitle("reset", for: .normal)
            view.addTarget(self, action: #selector(reset), for: .touchUpInside)

        }
        
        
        CustomedButton(frame: CGRect(x: 100, y: 100, width: size, height: size), color: themeColor!)
            .add(to: self.view)
            .layout(snpMaker: { (make) in
                make.top.equalTo((circleView?.snp.bottom)!)
                make.left.equalToSuperview().offset(60)
                make.width.height.equalTo(size)
        })
            .config({ (view) in
                view.setTitle("+50", for: .normal)
                view.addTarget(self, action: #selector(add50), for: .touchUpInside)
        })
        
        
        CustomedButton(frame: CGRect(x: 100, y: 100, width: size, height: size), color: themeColor!)
            .add(to: self.view)
            .layout(snpMaker: { (make) in
                make.top.equalTo((circleView?.snp.bottom)!)
                make.centerX.equalToSuperview()
                make.width.height.equalTo(size)
            })
            .config({ (view) in
                view.setTitle("+100", for: .normal)
                view.addTarget(self, action: #selector(add100), for: .touchUpInside)
            })
        
        CustomedButton(frame: CGRect(x: 100, y: 300, width: size, height: size), color: themeColor!)
            .add(to: self.view)
            .layout(snpMaker: { (make) in
                make.top.equalTo((circleView?.snp.bottom)!)
                make.right.equalToSuperview().offset(-60)
                make.width.height.equalTo(size)

            })

            .config({ (view) in
                view.setTitle("+200", for: .normal)
                view.addTarget(self, action: #selector(add200), for: .touchUpInside)
            })
        
        
        // setting button
        CustomedButton(frame: CGRect(x: 100, y: 300, width: 30, height: 30), color: themeColor!)
            .add(to: self.view)
            .layout { (make) in
                make.right.equalToSuperview().offset(-25)
                make.top.equalToSuperview().offset(40)
                make.width.height.equalTo(30)
        }.config { (view) in
            view.setTitle("!", for: .normal)
            view.layer.borderWidth =  1

            view.addTarget(self, action: #selector(goToSetting), for: .touchUpInside)
        }
    }
    
    func add50() {
        let temp = totalAmount! + 50
        changeAmountTo(amount: temp)
    }
    func add100() {
        let temp = totalAmount! + 100
        changeAmountTo(amount: temp)
    }
    func add200() {
        let temp = totalAmount! + 200
        changeAmountTo(amount: temp)

    }
    func reset() {
        changeAmountTo(amount: 0)
    }
    func goToSetting() {
        let setting = SettingViewController()
        self.present(setting, animated: true, completion: nil)
    }
    func changeAmountTo(amount: Int) {
        self.totalAmount = amount
        moveCircle()
        amountLabel?.text = String(amount)
        changeCoreDataDrinkingAmountTo(newAmount: totalAmount)
    }
    
    func moveCircle() {
        let ratio = Double(Double(totalAmount!) / Double(standardAmount))
        let degree = ratio * 360
        if (ratio >= 1) {
            circleView?.trackColor = TEAL200
        } else {
            circleView?.trackColor = themeColor!
        }
        circleView?.animate(toAngle: Double(degree), duration: 1, completion: { (completion) in
            print("change to \(degree)")
        })
    }


}

class CustomedButton: UIButton {
    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        self.layer.cornerRadius = frame.width / 2
        self.layer.borderWidth =  4
        self.layer.borderColor = color.cgColor
        self.setTitleColor(color, for: .normal)
        self.tintColor = color
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

