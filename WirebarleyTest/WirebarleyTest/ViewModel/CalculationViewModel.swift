//
//  CalculationViewModel.swift
//  WirebarleyTest
//
//  Created by 남기범 on 2021/01/12.
//

import Foundation
import RxSwift

protocol CalculationViewModelType {
    var quotes: PublishSubject<ExchangeRateData> { get }
    var disposeBag: DisposeBag { get }
    var remittanceCountry: Observable<String> { get }
    var recipientCountry: Observable<String> { get }
    var exchangeRate: Observable<String> { get }
}

class CalculationViewModel: CalculationViewModelType {
    var quotes: PublishSubject<ExchangeRateData>
    var remittanceCountry: Observable<String>
    var recipientCountry: Observable<String>
    var exchangeRate: Observable<String>
    var disposeBag: DisposeBag = DisposeBag()
    var countrysData: [ExchangeRateData] = []
    
    init(repository: RatesFetchable = CalculationRepository()) {
        quotes = PublishSubject<ExchangeRateData>()
        remittanceCountry = quotes.map { $0.송금국가 }
        recipientCountry = quotes.map { $0.수취국가 }
        exchangeRate = quotes.map { $0.환율 }
        
        repository.fetchRates()
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { element in
                self.countrysData = [
                    ExchangeRateData(송금국가: "미국(USD)", 수취국가: "한국(KRW)", 환율: "\(element.USDKRW)"),
                    ExchangeRateData(송금국가: "미국(USD)", 수취국가: "일본(JPY)", 환율: "\(element.USDJPY)"),
                    ExchangeRateData(송금국가: "미국(USD)", 수취국가: "필리핀(PHP)", 환율: "\(element.USDPHP)")
                ]
            }, onCompleted: {
                print("data setting is successful.")
            }).disposed(by: disposeBag)
    }
}
