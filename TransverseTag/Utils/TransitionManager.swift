//
//  TransitionManager.swift
//  TransverseTag
//
//  Created by Gontse Ranoto on 2018/11/17.
//  Copyright © 2018 Gontse Ranoto. All rights reserved.
//

import Foundation
import UIKit


class TransitionManager: NSObject,UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {

    let duration = 0.5
    var isPresenting = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard  let fromView = transitionContext.view(forKey: .from) else {return}
        
        guard  let toView = transitionContext.view(forKey: .to) else {return}
        
        
        //set up the transition we'll use in the animation
        let container = transitionContext.containerView
        
        //animator obj
        let offSreenLeft =  CGAffineTransform(translationX: -container.frame.width, y: 0)
        
        //Make the toView off screen
        if isPresenting{
            toView.transform = offSreenLeft
        }
        
        //views to the containerView
        if isPresenting {
            container.addSubview(fromView)
            container.addSubview(toView)
        }else{
            container.addSubview(toView)
            container.addSubview(fromView)
        }
        
        //animations
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
            
            if self.isPresenting{
                toView.transform = CGAffineTransform.identity
            }else{
                fromView.transform = offSreenLeft
            }
            
        }, completion: { finished in
            
            transitionContext.completeTransition(true)
        })
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresenting = false
        return self
    }
}
