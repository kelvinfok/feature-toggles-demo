//
//  TeamFlagsTableViewController.swift
//  ios-feature-toggle-demo
//
//  Created by Kelvin Fok on 31/3/22.
//

import UIKit

class TeamFlagsTableViewController: UITableViewController {
  
  var teamflags: TeamFlaggable?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    teamflags?.flags.forEach({ print($0.key) })
  }
  
  private func setupView() {
    title = teamflags?.team.rawValue.capitalizingFirstLetter()
    tableView.allowsSelection = false
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return teamflags?.flags.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let flags = teamflags?.flags else { return UITableViewCell() }
    let flag = flags[indexPath.item]
    switch flag.defaultValue {
    case is Bool:
      let cell = tableView.dequeueReusableCell(withIdentifier: switchCellId, for: indexPath) as! FlagSwitchTableViewCell
      cell.configure(flag: flag)
      return cell
    case is String, is Int, is Double:
      let cell = tableView.dequeueReusableCell(withIdentifier: textfieldCellId, for: indexPath) as! FlagTextfieldTableViewCell
      cell.configure(flag: flag)
      return cell

    default:
      return UITableViewCell()
      
      
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
}

class FlagSwitchTableViewCell: UITableViewCell {
  
  enum Environment {
    case local
    case remote
  }
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var switchToggle: UISwitch!
  
  private var flag: Flag<Any>?
  
  func configure(flag: Flag<Any>) {
    // will be nice if there's a way to receive Flag<Bool> instead of Flag<Any>
    // to avoid all the type casting but i'm not sure how to do that for now
    self.flag = flag
    titleLabel.text = flag.key
    descriptionLabel.text = flag.description
    updateValue()
  }
  
  @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl) {
    updateValue()
  }
  
  @IBAction func switchDidChange(_ sender: UISwitch) {
    print(sender.isOn)
  }
  
  func updateValue() {
    switch environment {
    case .local:
      switchToggle.isOn = flag?.defaultValue as! Bool
      switchToggle.isEnabled = true
    case .remote:
      switchToggle.isOn = (flag?.remoteValue as? Bool) ?? false
      switchToggle.isEnabled = false
    }
  }
  
  var environment: Environment {
    if segmentedControl.selectedSegmentIndex == 0 {
      return .local
    }
    return .remote
  }
}

class FlagTextfieldTableViewCell: UITableViewCell {
  
  enum Environment {
    case local
    case remote
  }
  
  private var flag: Flag<Any>?

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var textField: UITextField!
  
  func configure(flag: Flag<Any>) {
    self.flag = flag
    titleLabel.text = flag.key
    descriptionLabel.text = flag.description
    updateValue()
  }
  
  func updateValue() {
    switch environment {
    case .local:
      textField.text = String(describing: flag?.defaultValue ?? "")
      textField.isEnabled = true
    case .remote:
      print(flag?.remoteValue)
      textField.text = String(describing: flag?.remoteValue ?? "")
      textField.isEnabled = false
    }
  }
  
  @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl) {
    updateValue()
  }
  
  var environment: Environment {
    if segmentedControl.selectedSegmentIndex == 0 {
      return .local
    }
    return .remote
  }
  
}
