//
//  AnimationContext.swift
//  Shifty
//
//  Created by William McGinty on 12/29/17.
//

import Foundation

public protocol AnimationContext {
    var timingParameters: UITimingCurveProvider { get }
    func performAnimations(for propertyModifications: @escaping () -> Void)
}

public struct CubicAnimationContext: AnimationContext {
    
    //MARK: Properties
    public let cubicTimingParameters: UICubicTimingParameters
    public let relativeStartTime: TimeInterval
    public let relativeEndTime: TimeInterval
    
    // MARK: Initializers
    public init(timingParameters: UICubicTimingParameters, relativeStartTime: TimeInterval = 0.0, relativeEndTime: TimeInterval = 1.0) {
        self.cubicTimingParameters = timingParameters
        self.relativeStartTime = relativeStartTime
        self.relativeEndTime = relativeEndTime
    }
    
    //MARK: AnimationContext
    public var timingParameters: UITimingCurveProvider { return cubicTimingParameters }
    public func performAnimations(for propertyModifications: @escaping () -> Void) {
        //Nesting the animation in a keyframe allows us to take advantage of relative start/end times and inherit the existing animation curve
        UIView.animateKeyframes(withDuration: 0.0, delay: 0.0, options: [.layoutSubviews], animations: {
            UIView.addKeyframe(withRelativeStartTime: self.relativeStartTime, relativeDuration: self.relativeEndTime - self.relativeStartTime) {
                propertyModifications()
            }
        }, completion: nil)
    }
    
    // MARK: Default
    public static var `default`: CubicAnimationContext {
        return CubicAnimationContext(timingParameters: UICubicTimingParameters(animationCurve: .easeInOut))
    }
}

public struct SpringAnimationContext: AnimationContext {
    
    //MARK: Properties
    public let springTimingParameters: UISpringTimingParameters
    
    // MARK: Initializers
    public init(timingParameters: UISpringTimingParameters) {
        self.springTimingParameters = timingParameters
    }
    
    //MARK: AnimationContext
    public var timingParameters: UITimingCurveProvider { return springTimingParameters }
    public func performAnimations(for propertyModifications: @escaping () -> Void) {
        /* Currently, UISpringTimingParameters do not propagate through a keyframe animation (rdar://36245304).
            For the time being, we'll restrict the use of relativeStart/End with spring timing parameters. */
        propertyModifications()
    }
}


