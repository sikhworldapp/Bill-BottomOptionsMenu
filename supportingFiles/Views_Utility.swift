//
//  Views_Utility.swift
//  Sanjay Project
//
//  Created by Amanpreet Singh on 26/07/24.
//


import UIKit

extension UIView {
    func addTapGesture(closure: @escaping () -> Void) {
        self.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGestureRecognizer)
        
        // Store the closure in an associated object
        objc_setAssociatedObject(self, &AssociatedKeys.tapClosure, closure, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    @objc private func handleTap() {
        // Retrieve and execute the closure
        if let closure = objc_getAssociatedObject(self, &AssociatedKeys.tapClosure) as? () -> Void {
            closure()
        }
    }
}

// Define a key for associated objects
private struct AssociatedKeys {
    static var tapClosure = "tapClosure"
}



extension UIView {
    
    @IBInspectable var forceRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            // To avoid clipping the shadow, don't set masksToBounds to true
            self.layer.masksToBounds = false
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let cgColor = layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: cgColor)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    func applyDefaultShadow() {
        // You can call this method to apply a default professional shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        self.layer.masksToBounds = false
    }
}

