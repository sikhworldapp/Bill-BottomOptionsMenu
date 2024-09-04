//
//  SceneDelegate.swift
//  BillingSystem
//
//  Created by Amanpreet Singh on 31/08/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    
    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Ensure the scene is a UIWindowScene
        
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Create a new UIWindow using the windowScene constructor which takes a window scene
        let window = UIWindow(windowScene: windowScene)
        
        var storyBoard : UIStoryboard?
        // Load the storyboard
       
        var isAdmin = false
        
        if !isAdmin
        {
            storyBoard = UIStoryboard(name: "Main", bundle: nil)//fixes
        }
        else
        {
            storyBoard = UIStoryboard(name: "AdminFlow", bundle: nil)
        }
       
        let isLoggedIn = prefs.bool(forKey: AppConstants.shared.isLoggedIn)
        
        var initialViewController: UIViewController?
        
        if isLoggedIn
        {
            initialViewController = storyBoard?.instantiateViewController(withIdentifier: "BeforeDash")
        }
        else
        {
             initialViewController = storyBoard?.instantiateViewController(withIdentifier: "beforeHome")
        }
         
        // Instantiate the initial view controller by its Storyboard ID
      
        
        // Set the root view controller of the window with your view controller
        window.rootViewController = initialViewController
        
        // Set this window as the main window and show it
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

