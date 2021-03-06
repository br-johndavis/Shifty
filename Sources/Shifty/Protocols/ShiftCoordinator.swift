//
//  DefaultCoordinator.swift
//  Shifty
//
//  Created by William McGinty on 12/28/17.
//

import UIKit

public protocol ShiftCoordinator {
    func shifts(from sources: [State], to destinations: [State]) -> [Shift]
}

public struct DefaultCoordinator: ShiftCoordinator {
    
    // MARK: Properties
    public let timingContext: TimingContext
    
    // MARK: Initializers
    public init(animationContext: TimingContext) {
        self.timingContext = animationContext
    }
    
    public init(timingCurve: UIViewAnimationCurve = .easeInOut) {
        self.init(animationContext: CubicAnimationContext(timingParameters: UICubicTimingParameters(animationCurve: timingCurve)))
    }

    // MARK: ShiftCoordinator
    public func shifts(from sources: [State], to destinations: [State]) -> [Shift] {
        return sources.compactMap { source in
            let match = destinations.first { $0 == source }
            return match.map { Shift(source: source, destination: $0, timingContext: timingContext) }
        }
    }
}
