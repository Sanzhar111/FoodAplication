//
//  SplashPresenter.swift
//  Food Application
//
//  Created by Admin on 07.07.2022.
//

import Foundation
import UIKit
protocol SplashPresenterDescriprion {
    func present()
    func dismiss(completion:(()->Void)?)
    var windowScene:UIWindowScene? { get set }
}
final class SplashPresenter : SplashPresenterDescriprion {
    var windowScene: UIWindowScene?
    private lazy var animator:SplashAnimatorDescription = SplashAnimator(foregroundSplashWindow: foregroundSplashWindow)
    private lazy var foregroundSplashWindow:UIWindow = {
       var splashWindow = UIWindow()
        splashWindow = UIWindow(windowScene: windowScene!)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let splashViewController = storyBoard.instantiateViewController(withIdentifier: "SplashViewController") as? SplashViewController
        splashWindow.windowLevel = .normal + 1
        splashWindow.rootViewController = splashViewController
        return splashWindow
    }()
    func present() {
        animator.animateAppearance()
    }
    func dismiss(completion: (() -> Void)?) {
        animator.animateDissapearance(completion: completion)
    }
}
