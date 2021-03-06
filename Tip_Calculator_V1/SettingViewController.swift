//
//  SettingViewController.swift
//  Tip_Calculator_V1
//
//  Created by Kevin Nguyen on 12/16/17.
//  Copyright © 2017 KevinVuNguyen. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    let DEBUG: Bool = false
    
    @IBOutlet weak var resetOL: UIButton!
    @IBOutlet weak var changeOL: UIButton!
    
    @IBOutlet weak var firstCurrentPerc: UILabel!
    @IBOutlet weak var secondCurrentPerc: UILabel!
    @IBOutlet weak var thirdCurrentPerc: UILabel!
    @IBOutlet weak var newInput1: UITextField!
    @IBOutlet weak var newInput2: UITextField!
    @IBOutlet weak var newInput3: UITextField!
    
    /*
     Method Name: viewDidLoad
     Description: When the view loads, the labels are updated with the new percentage.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        if DEBUG { print("Made it to settingViewController load") }
        resetOL.layer.cornerRadius = 8
        changeOL.layer.cornerRadius = 8
        updateData()
    }
    
    /*
     Method Name: changeButton
     Description: This method takes the percent from the three text fields and updates the percent choices on the previous page.
     */
    @IBAction func changeButton(_ sender: UIButton) {
        if newInput1.text != "" {
            if let newPercent1 = newInput1!.text {
                firstCurrentPerc.text! =  newInput1.text! + "%"
                Data.setPercent(value: 0, newPercent: Double(newPercent1)!/100)
            }
        }
        if (newInput2!.text! != "") {
            if let newPercent2 = newInput2!.text {
                secondCurrentPerc.text! =  newInput2.text! + "%"
                Data.setPercent(value: 1, newPercent: Double(newPercent2)!/100)
            }
        }
        if newInput3!.text! != "" {
            if let newPercent1 = newInput3!.text {
                thirdCurrentPerc.text! =  newInput3.text! + "%"
                Data.setPercent(value: 2, newPercent: Double(newPercent1)!/100)
            }
        }
        updateData()
    }
    
    /*
     Method Name: resetButton
     Description: This method sets all the text fields and percent to the default 15%, 25%, and 30%.
     */
    @IBAction func resetButton(_ sender: UIButton) {
        if  let _ = firstCurrentPerc,
            let _ = secondCurrentPerc,
            let _ = thirdCurrentPerc {
        firstCurrentPerc.text = "15.0%"
        secondCurrentPerc.text = "25.0%"
        thirdCurrentPerc.text = "30.0%"
        }
        
        newInput1.text = ""
        newInput2.text = ""
        newInput3.text = ""
        
        Data.setPercent(value: 0, newPercent: 0.15)
        Data.setPercent(value: 1, newPercent: 0.25)
        Data.setPercent(value: 2, newPercent: 0.30)
    }
    
    func updateData() {
        if  let _ = firstCurrentPerc.text,
            let _ = secondCurrentPerc.text,
            let _ = thirdCurrentPerc.text {
            firstCurrentPerc?.text = String(Data.getPercent(value: 0) * 100) + "%"
            secondCurrentPerc?.text = String(Data.getPercent(value: 1) * 100) + "%"
            thirdCurrentPerc?.text = String(Data.getPercent(value: 2) * 100) + "%"
        }
    }
}
