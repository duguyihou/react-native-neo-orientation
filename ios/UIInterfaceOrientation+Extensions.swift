extension UIInterfaceOrientation {
  var toString: String {
    switch self {
    case .portrait:
      return "portrait"
    case .landscapeLeft:
      return "landscapeLeft"
    case .landscapeRight:
      return "landscapeRight"
    case .portraitUpsideDown:
      return "portraitUpsideDown"
    default:
      return "unknown"
    }
  }
}
