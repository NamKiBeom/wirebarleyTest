//
//  ViewController.swift
//  WirebarleyTest
//
//  Created by 남기범 on 2021/01/12.
//

import UIKit
import RxSwift
import RxCocoa

class CalculationController: UIViewController {
    @IBOutlet weak var remittanceCountryLabel: UILabel!
    @IBOutlet weak var recipientCountryLabel: UILabel!
    @IBOutlet weak var exchangeRateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var moneyTextField: UITextField!
    @IBOutlet weak var moneyUnitLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var countryPicker: UIPickerView!
    
    private let countrys = ["한국(KRW)", "일본(JPY)", "필리핀(PHP)"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryPicker.delegate = self
    }
}

extension CalculationController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countrys.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countrys[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
    }
}
