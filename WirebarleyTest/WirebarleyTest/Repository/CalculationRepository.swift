//
//  CalculationRepository.swift
//  WirebarleyTest
//
//  Created by 남기범 on 2021/01/12.
//

import Foundation
import RxSwift

protocol RatesFetchable {
    func fetchRates() -> Observable<Quote>
}

class CalculationRepository: RatesFetchable {
    func fetchRates() -> Observable<Quote> {
        return Observable.create({ emitter in
            APIService.shared.request(urlString: url, completion: { result in
                switch result {
                case .success(let data):
                    guard let response = try? JSONDecoder().decode(Response<Quote>.self, from: data) else {
                        emitter.onError(NSError(domain: "decode fail", code: 9999, userInfo: nil))
                        return
                    }
                    emitter.onNext(response.quotes)
                case .failure(let error):
                    emitter.onError(error)
                }
            })
            
            return Disposables.create()
        })
    }
}
