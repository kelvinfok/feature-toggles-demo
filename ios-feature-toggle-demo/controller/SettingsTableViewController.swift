//
//  SettingsTableViewController.swift
//  ios-feature-toggle-demo
//
//  Created by Kelvin Fok on 31/3/22.
//

import UIKit

class SettingsViewController: UITableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    showFeatureToggles()
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  private func showFeatureToggles() {
    performSegue(withIdentifier: "showFeatureToggles", sender: nil)
  }
  
}
