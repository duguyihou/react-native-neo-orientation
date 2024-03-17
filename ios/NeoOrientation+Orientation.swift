extension NeoOrientation {
  func setOrientationMask(_ orientationMask: UIInterfaceOrientationMask) {
    NeoOrientation.orientationMask = orientationMask
  }

  @objc
  static func getOrientationMask() -> UIInterfaceOrientationMask {
    return orientationMask
  }
  
  @objc
  func getOrientation(callback: @escaping RCTResponseSenderBlock) {
    OperationQueue.main.addOperation { [self] in
      callback([orientation.toString])
    }
  }

  @objc
  func getDeviceOrientation(callback: @escaping RCTResponseSenderBlock) {
    OperationQueue.main.addOperation { [self] in
      callback([deviceOrientation.toString])
    }
  }
}
