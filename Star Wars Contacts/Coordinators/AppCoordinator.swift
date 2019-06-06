//
//  AppCoordinator.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/5/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import UIKit
import SwiftUI

class AppCoordinator: Coordinator, CoordinatorProtocol {
    let window: UIWindow
    override init() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        super.init()
    }

    func start() {
        showLaunchScreen()
        window.makeKeyAndVisible()

        DispatchQueue.main.async { [weak self] in
            self?.showListScreen()
        }
    }

    private func showLaunchScreen() {
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() else {
            fatalError("Could not instantiate initial view controller from storyboard")
        }
        window.rootViewController = viewController
    }

    private func showListScreen() {
        let viewModel = IndividualListViewModel()
        viewModel.fetchItems()

        window.rootViewController = UIHostingController(rootView: IndividualListView().environmentObject(viewModel))
    }
}
