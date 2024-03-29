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
    
    var cancellables = [String: AnyCancellable]()
    
    init(window: UIWindow) {
        self.window = window
        super.init()
    }

    var navigationController: UINavigationController! {
        window.rootViewController as? UINavigationController
    }

    func start() {
        showLaunchScreen()

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
        cancellables["showList"] = viewModel.didSelectedIndividual
            .sink { [weak self] (item) in
            self?.showDetailScreen(item)
        }

        // Use a UIHostingController as window root view controller
        let view = IndividualListView().environmentObject(viewModel)
        let controller = UIHostingController(rootView: view)
        let nav = UINavigationController(rootViewController: controller)
        nav.navigationBar.isHidden = true
        window.rootViewController = nav
    }

    private func showDetailScreen(_ item:IndividualModel) {
        let viewModel = IndividualDetailViewModel(model: item)
        cancellables["detailBack"] = viewModel.didNavigateBack
            .sink { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        let view = IndividualDetailView().environmentObject(viewModel)
        let controller = UIHostingController(rootView: view)
        navigationController.pushViewController(controller, animated: true)
    }
}
