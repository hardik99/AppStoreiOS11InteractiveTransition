//
//  CardPresentationController.swift
//  AppStoreInteractiveTransition
//
//  Created by Wirawit Rueopas on 31/7/18.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import UIKit

final class CardPresentationController: UIPresentationController {

    private lazy var blurView = UIVisualEffectView(effect: nil)

    // Default is false.
    // And also means you can access only `.to` when present, and `.from` when dismiss (e.g., can touch only 'presented view').
    //
    // If true, the presenting view is removed and you have to add it during animation accessing `.from` key.
    // And you will have access to both `.to` and `.from` view. (In the typical .fullScreen mode)
    override var shouldRemovePresentersView: Bool {
        return false
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        return containerView!.bounds
    }
    
    override func presentationTransitionWillBegin() {
        let container = containerView!
        container.addSubview(blurView)
        blurView.frame = container.bounds
        blurView.alpha = 0.0

        presentingViewController.beginAppearanceTransition(false, animated: false)
        presentedViewController.transitionCoordinator!.animate(alongsideTransition: { (ctx) in
            UIView.animate(withDuration: 0.5, animations: {
                self.blurView.effect = UIBlurEffect(style: .light)
                self.blurView.alpha = 1
            })
        }) { (ctx) in }
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        presentingViewController.endAppearanceTransition()
    }

    override func dismissalTransitionWillBegin() {
        presentingViewController.beginAppearanceTransition(true, animated: true)
        presentedViewController.transitionCoordinator!.animate(alongsideTransition: { (ctx) in
            self.blurView.alpha = 0.0
        }, completion: nil)
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        presentingViewController.endAppearanceTransition()
        if completed {
            blurView.removeFromSuperview()
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (ctx) in
            self.presentedView?.frame = self.frameOfPresentedViewInContainerView
        }, completion: nil)
    }
}