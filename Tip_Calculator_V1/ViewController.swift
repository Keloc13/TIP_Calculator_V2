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
    @IBOutlet weak var BillPlusTipL: UITextField!
    @IBOutlet weak var TipAmountL: UILabel!
    @IBOutlet weak var TipAmountValueL: UILabel!
    
    @IBOutlet weak var buttonRight: UIButton!
    @IBOutlet weak var buttonCenter: UIButton!
    @IBOutlet weak var buttonLeft: UIButton!
    
    @IBOutlet weak var LabelBillTip: UILabel!
    @IBOutlet weak var LabelTipPercent: UILabel!
    @IBOutlet weak var LabelTipAmount: UILabel!
    
    var percentType: Double = 0.0
    let DEBUG: Bool = false
    
    /* LIFECYCLE METHODS */
    
    /*
     Method Name: viewDidLoad
     Description: sets all the labels and textfields that require the currency symbol.
                  Also, this method makes the button's corner's more circular.
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialFormatOfView()
        checkForPreviousData()
    }
    
    func initialFormatOfView() {
        TipAmountL.center = CGPoint(x: 234,y: 500)
        BillPlusTipL.center = CGPoint(x: 161,y: 500)
        LabelBillTip.center = CGPoint(x: 160,y: 500)
        LabelTipPercent.center = CGPoint(x: 101,y: 500)
        LabelTipAmount.center = CGPoint(x: 99,y: 500)
        TipAmountValueL.center  = CGPoint(x: 234,y: 500)
        buttonLeft.center = CGPoint(x: 89,y: 500)
        buttonRight.center = CGPoint(x: 237,y: 500)
        buttonCenter.center = CGPoint(x: 162,y: 500)
        buttonRight.layer.cornerRadius = 8
        buttonLeft.layer.cornerRadius = 8
        
        InputBillAmountL?.delegate = self
        TipAmountValueL?.text = ViewController.getSymbolForCurrencyCode()! + "0.0"
        InputBillAmountL?.text = ViewController.getSymbolForCurrencyCode()! + "0.0"
        InputBillAmountL?.becomeFirstResponder()
    }
    
    func checkForPreviousData() {
        let defaults = UserDefaults.standard
        if let dateOne = defaults.string(forKey: defaultKeys.keyTime){
            if Double(dateOne)! + 600 > NSDate().timeIntervalSince1970 {
                if let stringOne = defaults.string(forKey: defaultKeys.key1) {
                    InputBillAmountL?.text = stringOne
                }
                if let stringTwo = defaults.string(forKey: defaultKeys.key2) {
                    BillPlusTipL?.text = stringTwo
                }
            }
            changeCoordinate()
        }
    }
    
    /*
     Method Name: viewWillAppear
     Description: updates the percent data prior to the view opening.
     */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if DEBUG { print("view will appear") }
        buttonLeft.setTitle(String(Data.getPercent(value: 0) * 100)+"%", for: .normal)
        buttonCenter.setTitle(String(Data.getPercent(value: 1) * 100)+"%", for: .normal)
        buttonRight.setTitle(String(Data.getPercent(value: 2) * 100)+"%", for: .normal)
    }
    
    /*    METHOD FOR UPDATING THE CURRENCY VALUES      */
    
    /*
     Method Name: updateInputText
     Description: updates the InputBillAmount by checking what to display for the user when they start typing the digits for the input. So when the user starts typing, it should start with only the value the user inputs.
     */
    
    @IBAction func updateInputText(_ sender: UITextField) {
        if DEBUG { print("1. Program made it into UpdateInputText method") }
       
        if let value = InputBillAmountL?.text {
            if value.count != 0 {
                if value.count == (4 + String(ViewController.getSymbolForCurrencyCode()!).count) && String(value.prefix(upTo: value.index(value.startIndex, offsetBy: 3 + String(ViewController.getSymbolForCurrencyCode()!).count ))) == String(ViewController.getSymbolForCurrencyCode()!) + "0.0" {
                    let indexEnd = value.index(value.endIndex, offsetBy: 3 + String(ViewController.getSymbolForCurrencyCode()!).count - value.count)
                    InputBillAmountL?.text = String(value[indexEnd...])
                    changeCoordinate()
                } else if value.count == String(ViewController.getSymbolForCurrencyCode()!).count + 2 && String(value.prefix(upTo: value.index(value.startIndex, offsetBy: String(ViewController.getSymbolForCurrencyCode()!).count + 2))) == String(ViewController.getSymbolForCurrencyCode()!) + "0." {
                    InputBillAmountL?.text = ""
                    changeCoordinate()
                }
            } else {
                InputBillAmountL?.text = String(ViewController.getSymbolForCurrencyCode()!) + "0.0"
                BillPlusTipL?.text = InputBillAmountL.text!
                changeCoordinate()
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
        if DEBUG { print("Made it into UpdateBillAmount") }
        
        if let stringValue = InputBillAmountL!.text {
            if (stringValue.count == 1
                && stringValue != String(describing: ViewController.getSymbolForCurrencyCode()))
                || stringValue.count > 1 {
                var billAmount = 0.0
                if  String(describing: stringValue.first) ==
                    String(describing: ViewController.getSymbolForCurrencyCode()!.first)
                    && stringValue.count > 1 {
                    let index = stringValue.index(stringValue.startIndex, offsetBy: 1)
                    billAmount = round((100) * Double(stringValue[index...])!) / 100
                } else if String(describing: stringValue.first) !=
                    String(describing: ViewController.getSymbolForCurrencyCode()!.first) {
                    billAmount = round(10 * Double(stringValue)!) / 10
                }
                BillPlusTipL?.text = String(ViewController.getSymbolForCurrencyCode()!) + String(billAmount + billAmount * percentType)
                TipAmountL?.text = String(100 * percentType) + "%"
                TipAmountValueL?.text = String(ViewController.getSymbolForCurrencyCode()!) + String(billAmount * percentType)
            }
        }
    }
    
    /* UPDATE METHOD OF THE PERCENT BUTTONS */
    
    @IBAction func updateLeftPercent(_ sender: UIButton) {
        percentType = Data.getPercent(value: 0)
        updateBillAndTip()
        buttonLeft.backgroundColor = UIColor.darkGray
        buttonCenter.backgroundColor = UIColor.gray
        buttonRight.backgroundColor = UIColor.gray
    }
    
    @IBAction func updateCenterPercent(_ sender: UIButton) {
        percentType = Data.getPercent(value: 1)
        updateBillAndTip()
        buttonLeft.backgroundColor = UIColor.gray
        buttonCenter.backgroundColor = UIColor.darkGray
        buttonRight.backgroundColor = UIColor.gray
    }
    
    @IBAction func updateRightPercent(_ sender: UIButton) {
        percentType = Data.getPercent(value: 2)
        updateBillAndTip()
        buttonLeft.backgroundColor = UIColor.gray
        buttonCenter.backgroundColor = UIColor.gray
        buttonRight.backgroundColor = UIColor.darkGray
    }
    
    /* METHOD FOR ACQUIRING THE CURRENCY SYMBOL OF THE SPECIFIC REGION */
    
    static func getSymbolForCurrencyCode() -> String? {
        return NSLocale.autoupdatingCurrent.currencySymbol
    }
    
    /* METHOD TO STORE THE BILL AMOUNT FOR FUTURE USE */
    
    func storesInputandTip(){
        if DEBUG { print("stores input and tip values in database.") }
        let defaults = UserDefaults.standard
        
        if InputBillAmountL.text != ViewController.getSymbolForCurrencyCode()! + "0.0" {
            defaults.set(String(InputBillAmountL.text!),forKey: defaultKeys.key1)
        } else {
            defaults.set(String("0.0"),forKey: defaultKeys.key1)
        }
        defaults.set(String(BillPlusTipL.text!),forKey: defaultKeys.key2)
        defaults.set(String( NSDate().timeIntervalSince1970),forKey:defaultKeys.keyTime)
    }
    
    /* ANIMATION */
    
    func changeCoordinate(){
        view.addSubview(TipAmountL)
        view.addSubview(BillPlusTipL)
        view.addSubview(LabelBillTip)
        view.addSubview(LabelTipPercent)
        view.addSubview(TipAmountValueL)
        view.addSubview(LabelTipAmount)
        view.addSubview(buttonLeft)
        view.addSubview(buttonRight)
        view.addSubview(buttonCenter)
        view.addSubview(InputBillAmountL)
        
        if InputBillAmountL.text! != String(ViewController.getSymbolForCurrencyCode()!) + "0.0" {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .allowAnimatedContent, animations: {
                self.TipAmountL.center = CGPoint(x: 234,y: 236)
                self.BillPlusTipL.center = CGPoint(x: 161,y: 199)
                self.LabelBillTip.center = CGPoint(x: 160,y: 170)
                self.LabelTipPercent.center = CGPoint(x: 101,y: 233)
                self.LabelTipAmount.center = CGPoint(x: 99,y: 263)
                self.TipAmountValueL.center  = CGPoint(x: 234,y: 264)
                self.buttonLeft.center = CGPoint(x: 89,y: 303)
                self.buttonRight.center = CGPoint(x: 237,y: 303)
                self.buttonCenter.center = CGPoint(x: 162,y: 303)
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .allowAnimatedContent, animations: {
                self.TipAmountL.center = CGPoint(x: 234,y: 500)
                self.BillPlusTipL.center = CGPoint(x: 161,y: 500)
                self.LabelBillTip.center = CGPoint(x: 160,y: 500)
                self.LabelTipPercent.center = CGPoint(x: 101,y: 500)
                self.LabelTipAmount.center = CGPoint(x: 99,y: 500)
                self.TipAmountValueL.center  = CGPoint(x: 234,y: 500)
                self.buttonLeft.center = CGPoint(x: 89,y: 500)
                self.buttonRight.center = CGPoint(x: 237,y: 500)
                self.buttonCenter.center = CGPoint(x: 162,y: 500)
            }, completion: nil)
            InputBillAmountL?.font = UIFont(name:"fontname", size: 10.0)
        }
    }
 }
