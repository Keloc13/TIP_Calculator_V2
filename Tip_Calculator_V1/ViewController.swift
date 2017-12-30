 //
//  ViewController.swift
//  Tip_Calculator_V1
//
//  Created by Kevin Nguyen on 12/13/17.
//  Copyright © 2017 KevinVuNguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var InputBillAmountL: UITextField!
    @IBOutlet weak var InputPlusTipL: UITextField!
    @IBOutlet weak var TipAmountL: UILabel!
    @IBOutlet weak var TipAmountValueL: UILabel!
    
    @IBOutlet weak var button30: UIButton!
    @IBOutlet weak var button25: UIButton!
    @IBOutlet weak var button15: UIButton!
    
    @IBOutlet weak var BillTipLabel: UILabel!
    @IBOutlet weak var TipPercentLabel: UILabel!
    @IBOutlet weak var TipAmountLabel: UILabel!
    
    var percentType = 0.0
    
    let DEBUG = false
    
    /*
     LIFECYCLE METHODS
     */
    
    /*
     Method Name: viewDidLoad
     Description: sets all the labels and textfields that require the currency symbol.
                  Also, this method makes the button's corner's more circular.
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        TipAmountL.center = CGPoint(x: 234,y: 500)
        InputPlusTipL.center = CGPoint(x: 161,y: 500)
        BillTipLabel.center = CGPoint(x: 160,y: 500)
        TipPercentLabel.center = CGPoint(x: 101,y: 500)
        TipAmountLabel.center = CGPoint(x: 99,y: 500)
        TipAmountValueL.center  = CGPoint(x: 234,y: 500)
        button15.center = CGPoint(x: 89,y: 500)
        button30.center = CGPoint(x: 237,y: 500)
        button25.center = CGPoint(x: 162,y: 500)
        button30.layer.cornerRadius = 8
        button15.layer.cornerRadius = 8
        InputBillAmountL.delegate = self

        TipAmountValueL.text! = ViewController.getSymbolForCurrencyCode()! + "0.0"
        InputBillAmountL.text! = ViewController.getSymbolForCurrencyCode()! + "0.0"
        
        InputBillAmountL.becomeFirstResponder()
        
        let defaults = UserDefaults.standard
        
        if let dateOne = defaults.string(forKey: defaultKeys.keyTime){
            
            if(Double(dateOne)! + 600 > NSDate().timeIntervalSince1970)
            {
                if let stringOne = defaults.string(forKey: defaultKeys.key1){
                    InputBillAmountL.text! = stringOne
                }
                if let stringTwo = defaults.string(forKey: defaultKeys.key2){
                    InputPlusTipL.text! = stringTwo
                }
            }
            changeCorrdinate()
        }
    }
    
    /*
     Method Name: viewWillAppear
     Description: updates the percent data prior to the view opening.
     */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if DEBUG{ print("view will appear")}
        button15.setTitle(String(Data.getPercent(value: 0)*100)+"%", for: .normal)
        button25.setTitle(String(Data.getPercent(value: 1)*100)+"%", for: .normal)
        button30.setTitle(String(Data.getPercent(value: 2)*100)+"%", for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if DEBUG{ print("view did appear")}
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if DEBUG{ print("View will disappear")}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*    METHOD FOR UPDATING THE CURRENCY VALUES      */
    
    /*
     Method Name: updateInputText
     Description: updates the InputBillAmount by checking what to display for the user when they start typing the digits for the input. So when the user starts typing, it should start with only the value the user inputs.
     */
    
    @IBAction func updateInputText(_ sender: UITextField) {
        if DEBUG{ print("1. Program made it into UpdateInputText method")}
       
        if let value = InputBillAmountL!.text{
            if value.count != 0{
                if value.count == (4 + String(ViewController.getSymbolForCurrencyCode()!).count) && String(value.prefix(upTo: value.index(value.startIndex, offsetBy: 3 + String(ViewController.getSymbolForCurrencyCode()!).count ))) == String(ViewController.getSymbolForCurrencyCode()!) + "0.0"{
                   
                    let indexEnd = value.index(value.endIndex, offsetBy: 3 + String(ViewController.getSymbolForCurrencyCode()!).count - value.count)
                    InputBillAmountL.text! = String(value[indexEnd...])
                    changeCorrdinate()
                }
                else if value.count == String(ViewController.getSymbolForCurrencyCode()!).count + 2 && String(value.prefix(upTo: value.index(value.startIndex, offsetBy: String(ViewController.getSymbolForCurrencyCode()!).count + 2))) == String(ViewController.getSymbolForCurrencyCode()!) + "0."{
                    
                    InputBillAmountL.text! = ""
                    changeCorrdinate()
                }
            }
           else{
                InputBillAmountL?.text = String(ViewController.getSymbolForCurrencyCode()!) + "0.0"
                InputPlusTipL?.text = InputBillAmountL.text!
                changeCorrdinate()
            }
        }
        updateBillAndTip()
        storesInputandTip()
    }
    
    /*
     Method Name: updateBillAndTip
     Description: This method checks places the percent increase from the tip and the bill amount. This is displayed on the Bill + Tip Text Field.
     */
    
    func updateBillAndTip(){
        if DEBUG{ print("Made it into UpdateBillAmount")}
        
        if let stringValue = InputBillAmountL!.text{
            if((stringValue.count == 1
                && stringValue != String(describing: ViewController.getSymbolForCurrencyCode()))
                || stringValue.count > 1){
                var billAmount = 0.0
                if(String(describing: stringValue.first) == String(describing: ViewController.getSymbolForCurrencyCode()!.first) && stringValue.count > 1){
                    
                    let index = stringValue.index(stringValue.startIndex, offsetBy: 1)
                    billAmount = round((100)*Double(stringValue[index...])!)/100
                    
                }else if String(describing: stringValue.first) != String(describing: ViewController.getSymbolForCurrencyCode()!.first)  {
                    print("THE VALUE IS \(stringValue)")
                    billAmount = round(10*Double(stringValue)!)/10
                }
                
                InputPlusTipL.text! = String(ViewController.getSymbolForCurrencyCode()!) + String(billAmount + billAmount*percentType)
                TipAmountL.text! = String(100*percentType) + "%"
                TipAmountValueL.text! = String(ViewController.getSymbolForCurrencyCode()!) + String(billAmount*percentType)
            }
        }
    }
    
    /*
    update Methods for the percent
     */
    @IBAction func update15Percent(_ sender: UIButton) {
        percentType = Data.getPercent(value: 0)
        print(Data.getPercent(value: 0)*100)
        updateBillAndTip()
        button15.backgroundColor = UIColor.darkGray
        button25.backgroundColor = UIColor.gray
        button30.backgroundColor = UIColor.gray
    }
    
    @IBAction func update25Percent(_ sender: UIButton) {
        percentType = Data.getPercent(value: 1)
        updateBillAndTip()
        button15.backgroundColor = UIColor.gray
        button25.backgroundColor = UIColor.darkGray
        button30.backgroundColor = UIColor.gray
    }
    
    @IBAction func update30Percent(_ sender: UIButton) {
        percentType = Data.getPercent(value: 2)
        updateBillAndTip()
        button15.backgroundColor = UIColor.gray
        button25.backgroundColor = UIColor.gray
        button30.backgroundColor = UIColor.darkGray
    }
    
    /*
        method for getting the currency symbol of the region
     */
    static func getSymbolForCurrencyCode() -> String? {
        return NSLocale.autoupdatingCurrent.currencySymbol
    }
    
    func storesInputandTip(){
        if DEBUG{print("stores input and tip values in database.")}
        let defaults = UserDefaults.standard
        
        if InputBillAmountL.text! != ViewController.getSymbolForCurrencyCode()! + "0.0"{
            defaults.set(String(InputBillAmountL.text!),forKey: defaultKeys.key1)
        }else{
            defaults.set(String("0.0"),forKey: defaultKeys.key1)
        }
        defaults.set(String(InputPlusTipL.text!),forKey: defaultKeys.key2)
        defaults.set(String( NSDate().timeIntervalSince1970),forKey:defaultKeys.keyTime)
    }
    
    /*
     Animations
     */
    func changeCorrdinate(){
        view.addSubview(TipAmountL)
        view.addSubview(InputPlusTipL)
        view.addSubview(BillTipLabel)
        view.addSubview(TipPercentLabel)
        view.addSubview(TipAmountValueL)
        view.addSubview(TipAmountLabel)
        view.addSubview(button15)
        view.addSubview(button30)
        view.addSubview(button25)
        view.addSubview(InputBillAmountL)
        
        if InputBillAmountL.text! != String(ViewController.getSymbolForCurrencyCode()!) + "0.0"{
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .allowAnimatedContent, animations: {
                self.TipAmountL.center = CGPoint(x: 234,y: 236)
                self.InputPlusTipL.center = CGPoint(x: 161,y: 199)
                self.BillTipLabel.center = CGPoint(x: 160,y: 170)
                self.TipPercentLabel.center = CGPoint(x: 101,y: 233)
                self.TipAmountLabel.center = CGPoint(x: 99,y: 263)
                self.TipAmountValueL.center  = CGPoint(x: 234,y: 264)
                self.button15.center = CGPoint(x: 89,y: 303)
                self.button30.center = CGPoint(x: 237,y: 303)
                self.button25.center = CGPoint(x: 162,y: 303)
            }, completion: nil)
        }
        else{
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .allowAnimatedContent, animations: {
                self.TipAmountL.center = CGPoint(x: 234,y: 500)
                self.InputPlusTipL.center = CGPoint(x: 161,y: 500)
                self.BillTipLabel.center = CGPoint(x: 160,y: 500)
                self.TipPercentLabel.center = CGPoint(x: 101,y: 500)
                self.TipAmountLabel.center = CGPoint(x: 99,y: 500)
                self.TipAmountValueL.center  = CGPoint(x: 234,y: 500)
                self.button15.center = CGPoint(x: 89,y: 500)
                self.button30.center = CGPoint(x: 237,y: 500)
                 self.button25.center = CGPoint(x: 162,y: 500)
            }, completion: nil)
            InputBillAmountL.font = UIFont(name:"fontname", size: 10.0)
        }
    }
 }

