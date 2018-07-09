//
//  NetworkProccessor.swift
//  wheathery
//
//  Created by Ashkan on 5/24/18.
//  Copyright © 2018 Ashkan. All rights reserved.
//

import Foundation
class NetworkProcessor {
    lazy var configuration: URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session: URLSession = URLSession(configuration: self.configuration)
    let url: URL
    init(url: URL) {
        self.url = url
    }
    typealias jsonDictionaryHandler = (([String : Any]?) -> Void)
    func downloadJsonFromUrl(_ completion: @escaping jsonDictionaryHandler){
        let request = URLRequest(url: self.url)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200 :
                        //successfull response
                        if let data = data {
                            do {
                            let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                                completion(jsonDictionary as? [String:Any])
                            }catch let error as NSError{
                                print("Error processing json data: \(error.localizedDescription)")
                                
                            }
                        }
                    default : print("HTTP response code : \(httpResponse.statusCode)")
                    }
                }
            }else{
                print("Error : \(error?.localizedDescription)")
            }
        }
        dataTask.resume()
    }
}
