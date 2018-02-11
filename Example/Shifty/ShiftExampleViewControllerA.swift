//
//  ViewControllerA.swift
//  Shifty
//
//  Created by William McGinty on 7/6/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import Shifty

class ShiftExampleViewControllerA: UIViewController, ShiftTransitionable {
    
    @IBOutlet var yellowView: UIView!
    @IBOutlet var orangeView: UIView!
    @IBOutlet var shiftButton: UIButton!
    private var shiftTransitioningManager = SimpleShiftTransitioningDelegate()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
    }
    
    // MARK: IBActions
    @IBAction func shiftItButtonPressed(sender: AnyObject) {
        
        yellowView.shiftID = "yellow"
        orangeView.shiftID = "orange"
        shiftButton.actions = [.translate(byX: 0, y: 50), .fade(to: 0)]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "ShiftExampleViewControllerB") as? ShiftExampleViewControllerB else { return }
        
        controller.modalPresentationStyle = .currentContext
        controller.transitioningDelegate = shiftTransitioningManager
        
        present(controller, animated: true, completion: nil)
    }
}
