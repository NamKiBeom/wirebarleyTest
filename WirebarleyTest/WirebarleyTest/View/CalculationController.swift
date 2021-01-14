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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewBinding()
        timeLabel.text = Date().toString()
        viewModel.quotes.onNext(viewModel.countrysData[0])
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
            .bind(to: exchangeRateLabel.rx.text)
            .disposed(by: disposeBag)
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
