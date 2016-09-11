//
//  SimpleTransitioningDelegate.swift
//  Shifty
//
//  Created by William McGinty on 7/6/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class SimpleTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
        
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SimpleShiftAnimator(presenting: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SimpleShiftAnimator(presenting: false)
    }
}
