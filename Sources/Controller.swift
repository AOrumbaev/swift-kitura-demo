//
//  Controller.swift
//  hello-api
//
//  Created by Altynbek Orumbayev on 7/2/17.
//
//

import Foundation
import Kitura
import SwiftyJSON
import LoggerAPI
import Configuration
import CloudFoundryEnv
#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

public class Controller {
    let router: Router
    let appEnv: ConfigurationManager
    
    var url: String {
        get { return appEnv.url }
    }
    
    var port: Int {
        get { return appEnv.port }
    }
    
    let vehiclesArray : [Dictionary<String, Any>] = [
        
        ["make":"Nissan", "model":"Murano", "year":2017],
        ["make":"Nissan", "model":"Rogue", "year":2016],
        ["make":"Dodge", "model":"Ram", "year":2012]
        
    ]
    
    init () throws {
        appEnv = ConfigurationManager()
        
        router = Router()
        
        router.get("/", handler: getMain)
        router.get("/vehicles", handler: getAllVehicles)
        router.get("/vehicles/random", handler: getRandomVehicle)
    }
    
    public func getMain(reguest : RouterRequest, response : RouterResponse, next : @escaping () -> Void) throws {
        Log.debug("GET - / router handler...")
        var json = JSON([:])
        json["course"].stringValue = "Beginner APIs with Swift, Kitura and Bluemix"
        json["myName"].stringValue = "Altynbek Orumbayev"
        json["company"].stringValue = "Replicon"
        
        try response.status(.OK).send(json: json).end()
    }
    
    public func getAllVehicles(reguest : RouterRequest, response : RouterResponse, next : @escaping () -> Void) throws {
        Log.debug("GET - /vehicles router handler...")
        let json = JSON(vehiclesArray)
        try response.status(.OK).send(json: json).end()
    }
    
    public func getRandomVehicle(reguest : RouterRequest, response : RouterResponse, next : @escaping () -> Void) throws {
        Log.debug("GET - /vehicles router handler...")
        #if os(Linux)
            srandom(UInt32(NSDate().timeIntervalSince1970))
            let randomIndex = random() % vehiclesArray.count
        #else
            let randomIndex = Int(arc4random_uniform(UInt32(vehiclesArray.count)))
        #endif
     
        let json = JSON(vehiclesArray[randomIndex])
        try response.status(.OK).send(json: json).end()
    }
    
}
