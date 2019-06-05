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
        guard let viewController: UIViewController = storyboard.instantiateInitialViewController() else {
            fatalError("Could not instantiate initial view controller from storyboard")
        }
        window.rootViewController = viewController
    }

    private func showListScreen() {
        let luke = IndividualDetailViewModel(id: 1, firstName: "Luke", lastName: "Sky", birthdate: Date.init(timeIntervalSinceReferenceDate: 0), profilePictureURL: URL(string: "https://edge.ldscdn.org/mobile/interview/07.png")!, isForceSensitive: true, affiliation: .jedi)
        let list = IndividualListViewModel(items: [luke])

        window.rootViewController = UIHostingController(rootView: IndividualListView(viewModel: list))
    }
}
