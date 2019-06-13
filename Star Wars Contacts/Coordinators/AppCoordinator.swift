//
//  AppCoordinator.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/5/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

class AppCoordinator: Coordinator, CoordinatorProtocol {
    let window: UIWindow
    override init() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        super.init()
    }

    var navigationController: UINavigationController! {
        window.rootViewController as? UINavigationController
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
        _ = viewModel.didSelectedIndividual
            .sink { (item) in
            self.showDetailScreen(item)
        }

        // Use a UIHostingController as window root view controller
        let view = IndividualListView().environmentObject(viewModel)
        let controller = UIHostingController(rootView: view)
        let nav = UINavigationController(rootViewController: controller)
        nav.navigationBar.isHidden = true
        window.rootViewController = nav
    }

    private func showDetailScreen(_ item:IndividualDetailViewModel) {
        let view = IndividualDetailView().environmentObject(item)
        let controller = UIHostingController(rootView: view)
        _ = item.didNavigateBack.sink {
            self.navigationController.popViewController(animated: true)
        }
        navigationController.pushViewController(controller, animated: true)
    }
}
