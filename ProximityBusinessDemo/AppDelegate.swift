//
//  AppDelegate.swift
//  ProximityBusinessDemo
//
//  Created by Josh Holton on 11/1/21.
//

import UIKit
import AWSCognito
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var isProduction : Bool = true
    var dictUsers : NSMutableDictionary = NSMutableDictionary()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        ProximityApp.Local.setIsProduction(isProduction: isProduction)
        
        let cognitoIdentityPoolId : String = "us-east-2:4de63481-db3c-4c56-abd7-b58b8a2fbd86"
        
        let credentialsProvider : AWSCognitoCredentialsProvider = AWSCognitoCredentialsProvider.init(regionType: AWSRegionType.USEast2, identityPoolId: cognitoIdentityPoolId)
        
        let configuration : AWSServiceConfiguration = AWSServiceConfiguration.init(region: AWSRegionType.USEast2, credentialsProvider: credentialsProvider)
        
        configuration.timeoutIntervalForRequest = 60;
        configuration.timeoutIntervalForResource = 60;
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

