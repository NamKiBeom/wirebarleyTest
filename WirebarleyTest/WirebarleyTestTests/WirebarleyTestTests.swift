//
//  WirebarleyTestTests.swift
//  WirebarleyTestTests
//
//  Created by 남기범 on 2021/01/12.
//

import XCTest
import RxSwift
import RxCocoa
@testable import WirebarleyTest

class WirebarleyTestTests: XCTestCase {
    let disposeBag = DisposeBag()
    
    class MockAPIService: FetchAPIData {
        private let networkChecker: Bool
        
        init(checker: Bool) {
            self.networkChecker = checker
        }
        
        func request(urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
            if networkChecker {
                let quote = Quote(USDKRW: 1.234, USDJPY: 2.345, USDPHP: 3.456)
                guard let data = try? JSONEncoder().encode(quote) else {
                    return
                }
                completion(.success(data))
            } else {
                completion(.failure(.responseError))
            }
        }
    }
    
    class MockRepository: RatesFetchable {
        let url: String
        
        init(url: String) {
            self.url = url
        }
        
        func fetchRates(apiService: FetchAPIData) -> Observable<Quote> {
            return Observable.create({ [weak self] emitter in
                guard let self = self else {
                    fatalError()
                }
                
                apiService.request(urlString: self.url, completion: { result in
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
    
    func testCalculationRepositoryDependencyInjection() throws {
        let repository = CalculationRepository()
        let successMock = MockAPIService(checker: true)
        
        repository.fetchRates(apiService: successMock)
            .subscribe(onNext: { element in
                XCTAssertEqual(element.USDKRW, 1.234)
                XCTAssertEqual(element.USDJPY, 2.345)
                XCTAssertEqual(element.USDPHP, 3.456)
            }).disposed(by: disposeBag)
        
        let errorMock = MockAPIService(checker: false)
        repository.fetchRates(apiService: errorMock)
            .subscribe(onError: { error in
                guard let error = error as? NetworkError else {
                    return
                }
                XCTAssertEqual(error, .responseError)
            }).disposed(by: disposeBag)
    }
    
    func testCalculationViewModelDependencyInjection() throws {
        let mockRepository = MockRepository(url: "https://mockurl")
        let successMock = MockAPIService(checker: true)
        
        let networkOnViewModel = CalculationViewModel(repository: mockRepository, apiService: successMock)
        
        networkOnViewModel.exchangeRate
            .subscribe(onNext: { element in
                XCTAssertEqual(element, "1.234 KRW / USD")
            }).disposed(by: disposeBag)
        
        networkOnViewModel.quotes.onNext(ExchangeRateData(송금국가: "미국(USD)",
                                                 수취국가: "한국(KSW)",
                                                 환율: "1.234 KRW / USD"))
        
        let failMock = MockAPIService(checker: false)
        let networkOffViewModel = CalculationViewModel(repository: mockRepository, apiService: failMock)
        
        networkOffViewModel.exchangeRate
            .subscribe(onError: { error in
                guard let error = error as? NetworkError else {
                    return
                }
                XCTAssertEqual(error, .responseError)
            }).disposed(by: disposeBag)
    }
}
