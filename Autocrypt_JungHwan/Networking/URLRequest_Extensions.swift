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
}
