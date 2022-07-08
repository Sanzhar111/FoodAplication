//
//  SplashAnimator.swift
//  Food Application
//
//  Created by Admin on 07.07.2022.
//
import Foundation
import UIKit
protocol SplashAnimatorDescription {
    func animateAppearance()
    func animateDissapearance(completion:(()->Void)?)
}
final class SplashAnimator : SplashAnimatorDescription {
    private unowned let foregroundSplashWindow : UIWindow
    private unowned let foregroundSplashViewController:SplashViewController
    init(foregroundSplashWindow:UIWindow) {
        self.foregroundSplashWindow = foregroundSplashWindow
        guard let foregroundSplashViewController = foregroundSplashWindow.rootViewController as? SplashViewController
        else {
             fatalError("splashwindwow does not have a viewController")
         }
        self.foregroundSplashViewController = foregroundSplashViewController
    }
    func animateAppearance() {
        foregroundSplashWindow.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.foregroundSplashViewController.logoImageView.transform = CGAffineTransform(scaleX: 88/72, y: 88/72)
        }
    }
    func animateDissapearance(completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.3) {
            self.foregroundSplashWindow.alpha = 0
        } completion: { (_) in
            completion?()
        }
    }
}
