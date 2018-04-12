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
    var add50Button:AddButton?
    var add100Button:AddButton?
    
    var totalAmount:Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        totalAmount = getAmount()
        setupElement()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupElement() {
        circleView = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 400, height: 400)).add(to: self.view)
        circleView!.clockwise = true
        circleView!.set(colors: .cyan)
        circleView!.glowMode = .forward
        circleView!.glowAmount = 0
        circleView!.trackColor = UIColor.white
        circleView!.angle = 0
        
        let size = 50
        
        add50Button = AddButton(frame: CGRect(x: 100, y: 100, width: size, height: size))
        add50Button?.add(to: self.view)
            .config({ (view) in
                view.setTitle("+50", for: .normal)
                view.addTarget(self, action: #selector(add50), for: .touchUpInside)
        })
        
        add100Button = AddButton(frame: CGRect(x: 100, y: 300, width: size, height: size))
        add100Button?.add(to: self.view)
            .config({ (view) in
                view.setTitle("+100", for: .normal)
                view.addTarget(self, action: #selector(add100), for: .touchUpInside)
            })

    }
    
    func add50() {
        
    }
    func add100() {
        
    }
    
    func getAmount() -> Int? {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Amount>(entityName:"Amount")
        
        do {
            let fetchedObjects = try context.fetch(fetchRequest)

            //遍历查询的结果
            for info in fetchedObjects{
                print("id=\(info.drinkingAmount)")
            }
        }
        catch {
            fatalError("不能保存：\(error)")
        }
    }
    
    func changeAmountTo(newAmount: Int?) {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Amount>(entityName:"Amount")
        
        do {
            let fetchedObjects = try context.fetch(fetchRequest)
            for info in fetchedObjects{
                print("id=\(info.drinkingAmount)")
                
                amount.drinkingAmount = newAmount
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

class AddButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = frame.width / 2
        self.layer.borderWidth =  2
        self.layer.borderColor = UIColor.gray.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

