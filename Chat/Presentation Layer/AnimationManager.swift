//
//  TransitionManager.swift
//  Chat
//
//  Created by Павел Левищев on 27.11.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import Foundation
import UIKit

enum AnimationType {
    case present
    case dismiss
}

final class AnimationManager: NSObject {

    // MARK: - Variables
    private let animationDuration: Double
    private let animationType: AnimationType

    // MARK: - Init
    init(animationDuration: Double, animationType: AnimationType) {
        self.animationDuration = animationDuration
        self.animationType = animationType
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension AnimationManager: UIViewControllerAnimatedTransitioning {
    // Return the animation duration defined when we instantiated the view.
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(exactly: animationDuration) ?? 0.2
    }

    // Retrieve the ViewControllers and call the animation method
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from)
        else {
            // We only complete transition with success if the transition was executed.
            transitionContext.completeTransition(false)
            return
        }

        // According to the animation type we call the method to animate the presenting or dismissing.
        switch animationType {
        case .present:
            presentAnimation(
                transitionContext: transitionContext,
                fromView: fromViewController,
                toView: toViewController
            )
        case .dismiss:
            dismissAnimation(
                transitionContext: transitionContext,
                fromView: fromViewController,
                toView: toViewController
            )
        }
    }
}

// MARK: - Preenting animation
private extension AnimationManager {
    func presentAnimation(transitionContext: UIViewControllerContextTransitioning,
                          fromView: UIViewController,
                          toView: UIViewController) {

        let container = transitionContext.containerView
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        let offScreenRight = CGAffineTransform(translationX: container.frame.width, y: 0)
        let offScreenLeft = CGAffineTransform(translationX: -container.frame.width, y: 0)
        
        toView.transform = offScreenRight
        
        container.addSubview(toView)
        container.addSubview(fromView)
        
        let duration = self.transitionDuration(using: transitionContext)
        transitionContext.completeTransition(true)
        
        UIView.animate(withDuration: duration, delay: 0.2,
                                   usingSpringWithDamping: 0.49,
                                   initialSpringVelocity: 0.81,
                                   options: [], animations: { () -> Void in
            fromView.transform = offScreenLeft
            toView.transform = CGAffineTransform.identity
        }) { (finished) -> Void in
            transitionContext.completeTransition(true)
        }
    }
}

// MARK: - Dismissing animation
private extension AnimationManager {
    func dismissAnimation(transitionContext: UIViewControllerContextTransitioning,
                          fromView: UIViewController,
                          toView: UIViewController) {
        
        let container = transitionContext.containerView
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        let offScreenRight = CGAffineTransform(translationX: container.frame.width, y: 0)
        let offScreenLeft = CGAffineTransform(translationX: -container.frame.width, y: 0)
        
        toView.transform = offScreenLeft
        
        container.addSubview(toView)
        container.addSubview(fromView)

        let duration = self.transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration) {
            fromView.transform = offScreenRight
        } completion: { (_) in
            transitionContext.completeTransition(true)
        }
    }
}
