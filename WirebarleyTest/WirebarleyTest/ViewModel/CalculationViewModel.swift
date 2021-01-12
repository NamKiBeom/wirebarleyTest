//
//  CalculationViewModel.swift
//  WirebarleyTest
//
//  Created by 남기범 on 2021/01/12.
//

import Foundation
import RxSwift

protocol CalculationViewModelType {
    var quotes: Observable<Quote> { get }
}

class CalculationViewModel: CalculationViewModelType {
    var quotes: Observable<Quote>
    
    init(repository: RatesFetchable = CalculationRepository()) {
        quotes = repository.fetchRates()
    }
}
