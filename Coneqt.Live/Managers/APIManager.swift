//
//  APIManager.swift
//  Coneqt.Live
//
//  Created by Zain Ahmed on 10/12/2021.
//

import Foundation
import Alamofire
import CoreMedia
import UIKit

enum HeaderType{
    
    case stripe
    case backend
    case test
    case none
}

class APIManager{
    let baseUrl = ""
    let headerType : HeaderType
    let parameters : Parameters?
    var url : URL = URL(string: "https://www.google.com")!
    var requestType : HTTPMethod = .post
    var controller : BaseViewController?
    var endPoint : EndPoint!
    
    
    
    var header : HTTPHeaders?{
        
        switch headerType {
        case .stripe:
            return  ["Authorization" : ""]
        case .backend:
            guard let token = Defaults.backEndToken else{
                return nil
            }
            return  ["Authorization" : "Bearer"+" "+token]
        case .test:
            
            return [ "Content-type": "application/json; charset=UTF-8" ]
        case .none:
         return nil
            
        }
    }
    
    
    
    init(headerType : HeaderType,parameters : Parameters) {
        self.headerType = headerType
        self.parameters = parameters
    }
    
    init(headerType : HeaderType,parameters : Parameters,url : URL) {
        self.headerType = headerType
        self.parameters = parameters
        self.url = url
        
        
        
    }
    
    init(controller : BaseViewController?,headerType : HeaderType = .backend,parameters : Parameters? = nil,endPoint : EndPoint,method : HTTPMethod = .post) {
        self.headerType = headerType
        self.parameters = parameters
        self.requestType = method
        self.controller = controller
        self.endPoint = endPoint
        
        
        
    }
    
    
    init(headerType : HeaderType, url : URL) {
        
        self.headerType = headerType
        self.url = url
        self.parameters = nil
        self.requestType = .get
    }
    
    init(headerType : HeaderType, url : URL,method : HTTPMethod) {
        
        self.headerType = headerType
        self.url = url
        self.requestType = method
        self.parameters = nil
    }
    
    
    
    //MARK:- GET HTTP REQUESTS
    
    public func getJSON(completion :  @escaping (Result<[String:Any],Error>) -> Void){
        print("come in getJson url",url,"method",requestType,"param",parameters,"header",header)
        AF.request(url, method: requestType, parameters: parameters, headers: header)
            .responseJSON { response in
                 print("response is come")
                switch response.result{
                case .success(let result):
                    guard let json = result as? [String:Any] else{
                        print("getJSON Fail to get the json data")
                        return
                    }
                    completion(.success(json))
                case .failure(let error):
                    print("getJSON failure",error.localizedDescription)
                    completion(.failure(error))
                }

            }
    }
    
    
    
    public func getData(onCompletion : @escaping (Data?) -> Void){
        
        AF.request(url, method: .get, headers: header)
            .validate(statusCode: (200..<299))
            .response{ response in
            
                switch response.result{
                
                case .success(let data):
                    onCompletion(data)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            
            
        }
        
    }
    
    
    
    public func getModel<T:Codable>(model : T.Type,onCompletion : @escaping (Result<T,Error>) -> Void){
        print("url is",url)
        AF.request(url, method: .get, headers: header)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { response in
            print(response.result)
           switch response.result{
                
           case .success(let model):
            onCompletion(.success(model))
            
           case .failure(let error):
            onCompletion(.failure(error))
                
            }
        }
        
    }
    
    
    public func post<T:Codable>(model : T.Type,onCompletion : @escaping (Result<T,Error>) -> Void){
        print("@@url",url,"param",parameters,"header",header)
        AF.request(url, method: .post, parameters: parameters, headers: header)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { response in
                
                switch response.result{
                
                case .success(let model):
                    print("@@Model is",model)
                    onCompletion(.success(model))
                    
                case .failure(let error):
                    print("@@error is",error.localizedDescription)
                    onCompletion(.failure(error))
                    
                }
            }
        
    }
    
    
    //MARK:- POST HTTP REQUESTS
    
    
    public func post(completion : @escaping (Result<[String:Any],Error>) -> () ){
         print("@@url is",url,parameters,header)
        AF.request(url, method: .post, parameters: parameters,headers: header).responseJSON{ response in
            
            switch response.result{
            
            case .success(let result):
                
                guard let json = result as? [String:Any] else{
                    print("@@come infail to get json")
                    completion(.failure(ServerError.failToGetJSON))
                    return
                }
                print("@@json is",json)
                completion(.success(json))
            case .failure(let error):
                print("@@come in failure",error.localizedDescription)
                completion(.failure(error))
            }
            
        }
    }
    
    
    public func postFile(image : UIImage?,completion : @escaping (Result<[String:Any],Error>) -> Void){
        let image = image
//        let _ = image.jpegData(compressionQuality: 1)
        let pngData = image?.pngData()

        
        AF.upload(multipartFormData: {  multipartFormData in

            if let imageData = pngData{
                multipartFormData.append(imageData, withName: "image1",fileName: "image1",mimeType: "image/jpg")
            }

            for (key, value) in self.parameters!
            {
                
                multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                
            }
          
        },
        to: url,headers: header).response { response in
            
            switch response.result{
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    let dict = json as? [String:Any] ?? [:]
                    completion(.success(dict))
                    
                }catch{
                    print("fail to serialize json")
                    completion(.failure(error))
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
               
                
            }
        }
        
        
    }
    
    
    public func postFile1(image : UIImage?,completion : @escaping (Result<Data,Error>) -> Void){
        
        print("url is",url,"parameters",parameters)
        
        let _ = image?.jpegData(compressionQuality: 0.2)
        let pngData = image?.pngData()!
        print("parameters are",parameters)
        print("data is",pngData)
        AF.upload(multipartFormData: {  multipartFormData in

            if let pngData = pngData{
                multipartFormData.append(pngData, withName: "image",fileName: "image",mimeType: "image/jpg")
            }

            for (key, value) in self.parameters!
            {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        },
        to: url,headers: header).response { response in
            
            switch response.result{
            case .success(let data):
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    print(json)
                    if let data = data{
                        completion(.success(data))
                    }
                    
                }catch{
                    print("fail to serialize json")
                    completion(.failure(error))
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        
        
    }
    
    
    
    public func postTest<T:Codable>(model : T.Type,completion : @escaping (Result<T,RequestError>) -> Void){
        
        print("@@parameters are",parameters,"request type",requestType,"header",header)
        
        /// check internet connection
        if !NetworkMonitor.shared.isConnected{
            completion(.failure(.internetConnectionError))
        }
        
        /// check url
        guard
            let url = URL(string: baseUrl+endPoint.rawValue) else{
                completion(.failure(.invalidURL))
                return
            }
        
        print("@@url is",url)
        /// make request
        AF.request(url, method: requestType, parameters: parameters, headers: header)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { response in
                
                switch response.result{
                    
                case .success(let model):
                    print("@@ model is",model)
                    completion(.success(model))
                    
                case .failure(let error):
                    completion(.failure(.failure(error.localizedDescription)))
                    
                }
            }
        
    }
    
    
    


    
    
    
}
    



enum ServerError : Error{
    case failToGetJSON
    
}


enum RequestError : LocalizedError{
    
    case invalidURL
    case internetConnectionError
    case failure(String)
    
    var errorDescription: String{
        
        switch self {
        case .invalidURL:
            return "Invalid url to make request"
        case .internetConnectionError:
            return "Internet Connection not Found"
        case .failure(let string):
            return string
        }
    }
    
}


extension FixedWidthInteger {
    var data: Data {
        let data = withUnsafeBytes(of: self) { Data($0) }
        return data
    }
}
