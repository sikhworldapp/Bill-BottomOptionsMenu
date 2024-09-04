//
//  VC++.swift
//  Sanjay Project
//
//  Created by Amanpreet Singh on 25/08/24.
//

import UIKit

extension UIViewController {
    static func getTopViewController(base: UIViewController? = UIApplication.shared.connectedScenes
                                        .filter({ $0.activationState == .foregroundActive })
                                        .map({ $0 as? UIWindowScene })
                                        .compactMap({ $0 })
                                        .first?.windows
                                        .filter({ $0.isKeyWindow }).first?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopViewController(base: selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        
        return base
    }
}
