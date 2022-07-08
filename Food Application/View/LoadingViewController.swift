//
//  LoadingViewController.swift
//  OnBoardingOnce
//
//  Created by Admin on 08.05.2022.
//
import UIKit
class LoadingViewController:UIViewController {
    private var isOnboardingScreen:Bool!
    private let navigationManager = NavigationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showInitialScreen()
    }
    func showInitialScreen() {
        if AuthService.shared.auth.currentUser != nil {
            ProfileViewModel.shared.getProfile()
            ProfileViewModel.shared.getOrders()
            navigationManager.show(screen: .mainApp, inController: self)
        } else {
            navigationManager.show(screen: .onboarding, inController: self)
        }
    }
}

