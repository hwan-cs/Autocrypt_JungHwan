//
//  URLRequest_Extensions.swift
//  Autocrypt_JungHwan
//
//  Created by Jung Hwan Park on 2023/01/13.
//

import Foundation
import RxSwift
import Alamofire
import RxCocoa

struct Resource<T> {
    let url: URL
    var parameter: [String: String]?
}

extension URLRequest
{
    static func load<T: Decodable>(resource: Resource<T>) -> Observable<T>
    {
//        return Observable.just(resource.url)
//            .flatMap { url -> Observable<(HTTPURLResponse)> in
//                let request = URLRequest(url: url)
//                return AF.request(resource.url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).responseData { response -> T in
//                    switch response.result
//                    {
//                        case .success(let data):
//                            do
//                            {
//                                try JSONDecoder().decode(T.self, from: data)
//                            }
//                            catch
//                            {
//                                
//                            }
//                    case .failure(let error): break
//                            
//                    }
//                }
//            }.asObservable()
        
        return Observable.create
        { observer in
            let request = AF.request(resource.url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).responseData
            { response in
                switch response.result
                {
                    case .success(let data):
                        do
                        {
                            let model : T = try JSONDecoder().decode(T.self, from: data)
                            observer.onNext(model)
                        }
                        catch
                        {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        observer.onError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create
            {
                request.cancel()
            }
        }
    }
    
//    static func load<T: Decodable>(resource: Resource<T>) -> Observable<T>
//    {
//        return Observable.just(resource.url).flatMap
//        { url -> Observable<(response: HTTPURLResponse, data: Data)> in
//            let request = URLRequest(url: url)
//            return URLSession.shared.rx.response(request: request)
//        }.map
//        { response, data -> T in
//            if 200 ..< 300 ~= response.statusCode
//            {
//                return try JSONDecoder().decode(T.self, from: data)
//            }
//            else
//            {
//                throw AFError.explicitlyCancelled
//            }
//        }.asObservable()
//    }
}
