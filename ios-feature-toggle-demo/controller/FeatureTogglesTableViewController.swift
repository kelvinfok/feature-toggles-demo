//
//  FeatureTogglesTableViewController.swift
//  ios-feature-toggle-demo
//
//  Created by Kelvin Fok on 31/3/22.
//

import UIKit

class FeatureTogglesTableViewController: UITableViewController {
    
  private lazy var searchController: UISearchController = {
    let controller = UISearchController()
    controller.searchResultsUpdater = self
    return controller
  }()
  
  private let featureToggles = FeatureToggles.shared
  private var filteredTeams: [Team] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupSearch()
  }
  
  private func setupSearch() {
    navigationItem.searchController = searchController
//    navigationItem.hidesSearchBarWhenScrolling = false
    filteredTeams = featureToggles.teams
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destination = segue.destination as! TeamFlagsTableViewController
    let teamFlags = sender as! TeamFlaggable
    destination.teamflags = teamFlags
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredTeams.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TeamNameTableViewCell
    let teamName = filteredTeams[indexPath.item].rawValue.capitalizingFirstLetter()
    cell.configure(text: teamName)
    cell.accessoryType = .disclosureIndicator
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return rowHeight
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let selectedTeam = filteredTeams[indexPath.item]
    guard let teamFlags = featureToggles.getTeamFlaggable(team: selectedTeam) else { return }
    performSegue(withIdentifier: "showTeamFlags", sender: teamFlags )
  }
  
}

extension FeatureTogglesTableViewController: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    guard let query = searchController.searchBar.text else { return }
    filteredTeams = featureToggles.teams.filter({ $0.rawValue.starts(with: query) })
    tableView.reloadData()
  }
}

class TeamNameTableViewCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  
  func configure(text: String) {
    titleLabel.text = text
  }
  
}
