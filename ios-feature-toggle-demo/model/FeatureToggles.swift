//
//  FeatureToggles.swift
//  ios-feature-toggle-demo
//
//  Created by Kelvin Fok on 31/3/22.
//

import Foundation

class Flag<T> {
  
  let key: String
  let defaultValue: T
  let description: String
  
  var remoteValue: T?
  
  init(defaultValue: T, key: String, description: String) {
    self.defaultValue = defaultValue
    self.key = key
    self.description = description
  }
  
  func updateRemoteValue(_ value: T) {
    self.remoteValue = value
  }
}

protocol TeamFlaggable {
  var team: Team { get }
  var flags: [Flag<Any>] { get }
}

enum Team: String, CaseIterable {
  case platform
  case payment
  case browsing
  case reward
}

class FeatureToggles {
  
  static let shared = FeatureToggles()
  private init() {}
  
  private let teamFlags: [TeamFlaggable] = [
    PlatformTeamFlags(),
    PaymentTeamFlags(),
    BrowsingTeamFlags(),
    RewardTeamFlags()
  ]
  
  var teams: [Team] {
    teamFlags.map({ $0.team })
  }
  
  func getTeamFlaggable(team: Team) -> TeamFlaggable? {
    return teamFlags.filter({ $0.team == team }).first
  }
  
  func sync(dict: [String: Any]) {
    let flags = teamFlags.flatMap({ $0.flags })
    flags.forEach({ $0.remoteValue = dict[$0.key] })
  }
  
}

class PlatformTeamFlags: TeamFlaggable {

  var flags: [Flag<Any>] = [
    Flag(defaultValue: false,
         key: "isNewFeedEnabled",
         description: "if true, we call layout/v2 to load the feed"),
    Flag(defaultValue: "Welcome to my app",
         key: "mobileWelcomeMessage",
         description: "Text to show on onboarding screen"),
    Flag(defaultValue: 5.0,
         key: "minimumCacheFeedResults",
         description: "Minimum of cache results to show on feed if device is unable to connect to server")
  ]
  
  var team: Team {
    return .platform
  }
    
}

class PaymentTeamFlags: TeamFlaggable {

  var flags: [Flag<Any>] = [
    Flag(defaultValue: true,
         key: "isPaymentV3Enabled",
         description: "if true, we call payment/v3 endpoint"),
  ]
  
  var team: Team {
    return .payment
  }
    
}

class BrowsingTeamFlags: TeamFlaggable {

  var flags: [Flag<Any>] = [
    Flag(defaultValue: "{\r\"msg\":\"Something's wrong\"\r}",
         key: "paginationErrorMessageJsonString",
         description: "payload to use when pagination api return 5xx"),
  ]
  
  var team: Team {
    return .browsing
  }
    
}

class RewardTeamFlags: TeamFlaggable {

  var flags: [Flag<Any>] = []
  
  var team: Team {
    return .reward
  }
    
}
