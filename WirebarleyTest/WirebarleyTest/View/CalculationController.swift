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
    private var currentRate: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewBinding()
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
        
        viewModel.quotes.onNext(viewModel.countrysData[0])
    }
    
    func valueConverting(value: String) -> String {
        var components = value.components(separatedBy: " ")
        guard let doubleValue = Double(components.first ?? "0"),
              let chagedValue = Double(String(format: "%.2f", doubleValue)) else {
            fatalError("String value doesn't convert Double.")
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard var result = numberFormatter.string(from: NSNumber(value: chagedValue)) else {
            fatalError("Double value doesn't convert String")
        }
        currentRate = Double(result) ?? 0
        
        components.removeFirst()
        result = result + " " + components.reduce("", { $0 + $1 + " " })
        
        return result
    }
}

extension CalculationController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.countrysData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.countrysData[row].수취국가
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.quotes.onNext(viewModel.countrysData[row])
    }
}
