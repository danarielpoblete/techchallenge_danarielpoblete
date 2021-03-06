//
//  DarkSkyAPI.swift
//  WeatherApp
//
//  Created by Dan.Poblete on 6/12/17.
//  Copyright © 2017 danarielpoblete. All rights reserved.
//

import Foundation
import Moya

public enum DarkSky: TargetType {
    case forecast(latitude: Double, longitude: Double)
    
    private static let apiKey = "260c12804b82e76707621c882506e92a"
    
    public var baseURL: URL {
        return URL(string: "https://api.darksky.net")!
    }
    
    public var path: String {
        switch self {
        case .forecast(let latitude, let longitude):
            return "/forecast/\(type(of: self).apiKey)/\(latitude),\(longitude)"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Task {
        switch self {
        case .forecast: return .requestPlain
        }
    }
    
    public var validate: Bool {
        switch self {
        case .forecast: return false
        }
    }
    
    public var sampleData: Data {
        switch self {
        case .forecast:
            guard let url = Bundle.main.url(forResource: "sample-dark-sky-forecast", withExtension: "json") else {
                return Data()
            }
            
            guard let jsonString = try? String(contentsOf: url) else {
                return Data()
            }
            
            return jsonString.data(using: String.Encoding.utf8)!
        }
    }
    
    public var headers: [String: String]? {
        return nil
    }
}
