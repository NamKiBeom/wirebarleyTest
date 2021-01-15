//
//  CalculationRepository.swift
//  WirebarleyTest
//
//  Created by 남기범 on 2021/01/12.
//

import Foundation
import RxSwift

protocol RatesFetchable {
    func fetchRates(apiService: FetchAPIData) -> Observable<Quote>
}

class CalculationRepository: RatesFetchable {
    private let url = "http://api.currencylayer.com/live?access_key=7063bbdf25d9f939368df1c8087adde1"
    
    func fetchRates(apiService: FetchAPIData) -> Observable<Quote> {
        return Observable.create({ [weak self] emitter in
            apiService.request(urlString: self?.url ?? "", completion: { result in
                switch result {
                case .success(let data):
                    guard let response = try? JSONDecoder().decode(Response<Quote>.self, from: data) else {
                        emitter.onError(NSError(domain: "decode fail", code: 9999, userInfo: nil))
                        return
                    }
                    emitter.onNext(response.quotes)
                    emitter.onCompleted()
                case .failure(let error):
                    emitter.onError(error)
                }
            })
            
            return Disposables.create()
        })
    }
}
