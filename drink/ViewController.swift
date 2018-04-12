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

class ViewController: UIViewController {
    
    var circleView:KDCircularProgress?
    var add50Button:CustomedButton?
    var add100Button:CustomedButton?
    var amountLabel:UILabel?
    var themeColor:UIColor? = .lightGray
    
    var totalAmount:Int?
    
    var standardAmount = 2000
    
    var CONCRETE:UIColor = hexStringToUIColor(hex: "#95A5A6")
    var ASBESTOS:UIColor = hexStringToUIColor(hex: "#7F8C8D")
    
    override func viewWillAppear(_ animated: Bool) {
        let ud = UserDefaults.standard
        let firstLaunch:Bool = ud.bool(forKey: "Launched");
        if(!firstLaunch){
            //第一次启动
            print("first")
            let app = UIApplication.shared.delegate as! AppDelegate
            let context = app.persistentContainer.viewContext
            
            //创建User对象
            let amount = NSEntityDescription.insertNewObject(forEntityName: "Amount",
                                                           into: context) as! Amount
            
            //对象赋值
            amount.drinkingAmount = 0
            
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
        
        totalAmount = getAmount()
        themeColor = CONCRETE
        setupElement()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupElement() {
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
    func changeAmountTo(amount: Int) {
        self.totalAmount = amount
        moveCircle()
        amountLabel?.text = String(amount)
        changeCoreDataAmountTo(newAmount: totalAmount)
    }
    
    func moveCircle() {
        let degree = Double(Double(totalAmount!) / Double(standardAmount)) * 360
        circleView?.animate(toAngle: Double(degree), duration: 1, completion: { (completion) in
            print("change to \(degree)")
        })
    }
    
    func getAmount() -> Int {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Amount>(entityName:"Amount")
        var num = 0
        
        do {
            let fetchedObjects = try context.fetch(fetchRequest)

            //遍历查询的结果
            for info in fetchedObjects{
                print("id=\(info.drinkingAmount)")
                num = Int(info.drinkingAmount)
            }
        }
        catch {
            fatalError("不能保存：\(error)")
        }
        
        return num
    }
    
    func changeCoreDataAmountTo(newAmount: Int?) {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Amount>(entityName:"Amount")
        
        do {
            let fetchedObjects = try context.fetch(fetchRequest)
            for info in fetchedObjects{
                print("id=\(info.drinkingAmount)")
                
                info.drinkingAmount = Int16(newAmount!)
                try context.save()
            }
            
        } catch {
            fatalError("不能保存：\(error)")
        }

        
//        let amount = NSEntityDescription.insertNewObject(forEntityName: "Amount",
//                                                       into: context) as! Amount
//        amount.drinkingAmount = newAmount
//        
//        do {
//            try context.save()
//            print("保存成功！")
//        } catch {
//            fatalError("不能保存：\(error)")
//        }
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

