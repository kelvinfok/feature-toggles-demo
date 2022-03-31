//
//  AppDelegate.swift
//  ios-feature-toggle-demo
//
//  Created by Kelvin Fok on 31/3/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    fetchFeatureFlags()
    return true
  }

  private func fetchFeatureFlags() {
    // Simulates making an API call to fetch flags
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      let dict: [String : Any] = [
        "isNewFeedEnabled": true,
        "mobileWelcomeMessage": "Book a holiday and enjoy your time!",
        "minimumCacheFeedResults": 8.0,
        "isPaymentV3Enabled": false,
        "paginationErrorMessageJsonString": "{\r\"msg\":\"We are working on a solution.\"\r}"]
      FeatureToggles.shared.sync(dict: dict)
    }
  }

}

