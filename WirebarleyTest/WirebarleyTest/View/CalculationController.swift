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
    
    private let viewModel = CalculationViewModel()
    private let disposeBag = DisposeBag()
    private let countrys = ["한국(KRW)", "일본(JPY)", "필리핀(PHP)"]
    private var currentRate: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewBinding()
        keyboardToolbarSetting()
        timeLabel.text = Date().toString()
        countryPicker.delegate = self
    }
}

private extension CalculationController {
    func viewBinding() {
        viewModel.remittanceCountry
            .bind(to: remittanceCountryLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.recipientCountry
            .bind(to: recipientCountryLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.exchangeRate
            .map { [weak self] in
                return self?.valueConverting(value: $0) ?? ""
            }
            .bind(to: exchangeRateLabel.rx.text)
            .disposed(by: disposeBag)
        
        if !viewModel.countrysData.isEmpty {
            viewModel.quotes.onNext(viewModel.countrysData[0])
        }
    }
    
    func valueConverting(value: String) -> String {
        var components = value.components(separatedBy: " ")
        guard let doubleValue = Double(components.first ?? "0"),
              let chagedValue = Double(String(format: "%.2f", doubleValue)) else {
            fatalError("String value doesn't convert Double.")
        }
        
        currentRate = chagedValue
        var result = (components.first ?? "").toDecimal()
        
        components.removeFirst()
        result = result + " " + components.reduce("", { $0 + $1 + " " })
        
        return result
    }
    
    func keyboardToolbarSetting() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneAction))
        toolbar.items = [doneButton]
        moneyTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneAction() {
        guard let moneyUnit = (recipientCountryLabel.text ?? "").getArrayAfterRegex(regex: "[A-Z]+").first,
              let value = Double(moneyTextField.text ?? "") else {
            return
        }
        
        let result = "\(currentRate * value)".toDecimal()
        resultLabel.text = "수취금액은 " + "\(result)" + " \(moneyUnit)" + " 입니다."
        
        view.endEditing(true)
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
        viewModel.quotes.onNext(viewModel.countrysData[row])
        moneyTextField.text = ""
        resultLabel.text = "송금액을 입력해주세요."
    }
}
