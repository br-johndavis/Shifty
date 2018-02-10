//
//  State.swift
//  Shifty
//
//  Created by Will McGinty on 5/2/16.
//  Copyright © 2016 will.mcginty. All rights reserved.
//

import UIKit

/// Represents a single state of a shifting `UIView`.
public struct State {
    
    public enum Configuration {
        public typealias Configurator = (_ baseView: UIView) -> UIView
        
        case snapshot
        case configured(Configurator)
        
        // MARK: Interface
        func configuredShiftingView(for baseView: UIView, afterScreenUpdates: Bool) -> UIView {
            switch self {
            case .snapshot:
                //Ensure we take the snapshot with no corner radius, and then apply that radius to the snapshot (and reset the baseView).
                let cornerRadius = baseView.layer.cornerRadius
                baseView.layer.cornerRadius = 0
                
                guard let s = baseView.snapshotView(afterScreenUpdates: afterScreenUpdates) else { fatalError("Unable to snapshot view: \(baseView)") }
                let snapshot = SnapshotView(contentView: s)
                
                snapshot.layer.masksToBounds = true
                snapshot.layer.cornerRadius = cornerRadius
                baseView.layer.cornerRadius = cornerRadius
                
                return snapshot
                
            case .configured(let configurator):
                return configurator(baseView)
            }
        }
    }
    
    // MARK: Properties
    public let view: UIView /// The view being subjected to the shift.
    public let identifier: AnyHashable /// The identifier assigned to this `State`. Each identifier in the source should match an identifier in the destination.
    public let configuration: Configuration /// The method used to configure the view. Defaults to .snapshot.
    
    // MARK: Initializers    
    public init(view: UIView, identifier: AnyHashable, configuration: Configuration = .snapshot) {
        self.view = view
        self.identifier = identifier
        self.configuration = configuration
    }
}

// MARK: Public Interface
public extension State {
    
    func configuredReplicantView(inContainer container: UIView, afterScreenUpdates: Bool) -> UIView {
        
        //Create, add and place the replicantView with respect to the container
        let replicantView = viewForShiftWithRespect(toContainer: container, afterScreenUpdates: afterScreenUpdates)
        container.addSubview(replicantView)
        applyState(to: replicantView, in: container)
        
        //Configure the native view as hidden so the replicantView is the only visible copy, then return it
        configureNativeView(hidden: true)
        return replicantView
    }
    
    func viewForShiftWithRespect(toContainer container: UIView, afterScreenUpdates: Bool) -> UIView {
        return configuration.configuredShiftingView(for: view, afterScreenUpdates: afterScreenUpdates)
    }
    
    func applyState(to view: UIView, in container: UIView) {
        currentSnapshot().applyState(to: view, in: container)
    }
    
    func cleanupReplicantView(_ replicantView: UIView) {
        configureNativeView(hidden: false)
        replicantView.removeFromSuperview()
    }
}

// MARK: Internal Interface
extension State {
    
    /// Returns a `Snapshot` of the current state of the `State`.
    func currentSnapshot() -> Snapshot {
        return Snapshot(view: view)
    }
    
    func configureNativeView(hidden: Bool) {
        view.isHidden = hidden
    }
}

// MARK: Hashable
extension State: Hashable {
    
    public var hashValue: Int {
        return identifier.hashValue
    }
    
    public static func == (lhs: State, rhs: State) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
