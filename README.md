# Example of MVVM-Coordinator pattern with SwiftUI

## Explain
SwiftUI seems to lend itself well with the MVVM design pattern, but not necessarily to the MVVM-Coordinator pattern. I have spent some time and collaboration to figure out one way it can be done, altough it is somewhat hacky. This is my example project demonstrating the method I have come up with.

It all comes down to how to transfer control from the NavigationButton to the Coordinator so that the Coordinator can be in charge of creating the next View and displaying it. Normally the NavigationButton requires the next View to be provided right there in the constructor and takes care of all this for you. The bad thing about this is that it couples that next View to the current View and now must follow no matter where the current View is used in the app. This breaks modularity and reusability of both the current View and the next View. So, circumventing the normal behavior of a NavigationButton (or NavigationLink) I use a `Button` instead and then use the `action` closure parameter to send a signal that the Coordinator can listen to. Then the coordinator creates and pushes the next View onto a traditional UINavigationController. I told you it was hacky.

## Show

### CurrentView
```
Button(action: {
    // tell the viewModel to publish a signal
    self.viewModel.userSelectedNext()
}, label: { Text("Next") })
```

### CurrentViewModel
```
let didSelectNext = PassthroughSubject<Void, Never>()

func userSelectedNext() {
    didSelectNext.send()
}
```

### Coordinator
```
// subscribe/listen to the signal from the viewModel
_ = viewModel.didSelectNext
    .sink { [weak self] in
    self?.showNextScreen()
}

private func showNextScreen() {
    // create the new view
    let view = NextView()
    // hook up subscribers/listeners
    ...
    // wrap it in a HostingController
    let controller = UIHostingController(rootView: view)
    // push it onto the navigation stack
    navigationController.pushViewController(controller, animated: true)
}
```

## Downsides
The biggest downside, in my opinion, is that we lose the fancy new simplistic and beautiful, built-in transitions that come with letting a NavigationButton just do its thing and we are stuck depending on the old UINavigationController from UIKit to do its thing. I hope that in the future, perhaps the next version of SwiftUI will provide a more straight forward and clean way to code this pattern and no longer require the use of the UINavigationController.
