//
//  MyCoffeeAppApp.swift
//  MyCoffeeApp
//
//  Created by César on 10/05/21.
//

import SwiftUI
import Firebase

@main
struct MyCoffeeAppApp: App {
    
    //Declaring delegate:
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

//Initializing Firebase....

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

