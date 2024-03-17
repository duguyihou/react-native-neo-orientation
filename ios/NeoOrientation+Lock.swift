extension NeoOrientation {

  @objc
  func lockToPortrait() {
    OperationQueue.main.addOperation { [self] in
      lockToOrientation(.portrait, withMask: .portrait)
    }
  }

  @objc
  func lockToLandscape() {
    withLock {
      OperationQueue.main.addOperation { [self] in
        UIDevice.current.setValue(UIInterfaceOrientation.unknown.rawValue,
                                  forKey: "orientation")

        let landscape = orientation == .landscapeRight ? UIInterfaceOrientation.landscapeLeft.rawValue : UIInterfaceOrientation.landscapeRight.rawValue
        setOrientationMask(.landscape)
        UIDevice.current.setValue(landscape, forKey: "orientation")

        UIViewController.attemptRotationToDeviceOrientation()
        sendEvent(withName: Constants.lockDidChange,
                  body: ["orientation": "landscapeLeft"])
      }

    }
  }

  @objc
  func lockToLandscapeRight() {
    OperationQueue.main.addOperation { [self] in
      lockToOrientation(.landscapeLeft, withMask: .landscapeLeft)
    }
  }

  @objc
  func lockToLandscapeLeft() {
    OperationQueue.main.addOperation { [self] in
      lockToOrientation(.landscapeRight, withMask: .landscapeRight)
    }
  }

  @objc
  func unlockAllOrientations() {
    OperationQueue.main.addOperation { [self] in
      lockToOrientation(.unknown, withMask: .all)
    }
  }

  private func lockToOrientation(_ newOrientation: UIInterfaceOrientation, 
                                 withMask mask: UIInterfaceOrientationMask) {
    withLock {
      setOrientationMask(mask)
      let currentDevice = UIDevice.current
      currentDevice.setValue(newOrientation, forKey: "orientation")

      if #available(iOS 16.0, *) {
        let windowScene = UIApplication.shared.connectedScenes.first as! UIWindowScene
        windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: mask))
        let rootController = windowScene.keyWindow?.rootViewController
        rootController?.setNeedsUpdateOfSupportedInterfaceOrientations()
      } else {
        UIViewController.attemptRotationToDeviceOrientation()
      }
      sendEvent(withName: Constants.lockDidChange,
                body: ["orientation": newOrientation.toString])
    }
  }

  private func withLock<T>(_ closure: () -> T) -> T {
    os_unfair_lock_lock(lock)
    defer { os_unfair_lock_unlock(lock) }
    return closure()
  }
}
