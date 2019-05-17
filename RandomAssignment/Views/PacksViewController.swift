//
//  PacksViewController.swift
//  RandomAssignment
//
//  Created by Gökhan KOCA on 11.05.2019.
//  Copyright © 2019 gkoca. All rights reserved.
//

import UIKit
import SwipeCellKit

final class PacksViewController: UITableViewController {
	
	@IBOutlet var viewModel: PacksViewModel!
	let searchController = UISearchController(searchResultsController: nil)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureSearchController()
		viewModel.delegate = self
		viewModel.load()
	}
	
	@IBAction func sortButtonAction(_ sender: Any) {
		let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		let dataAction = UIAlertAction(title: "İnternet hakkına göre sırala", style: .default) { [weak self] _ in
			guard let `self` = self else { return }
			self.viewModel.sortAllPacks(by: .data)
			
		}
		let talkAction = UIAlertAction(title: "Konuşma hakkına göre sırala", style: .default) { [weak self] _ in
			guard let `self` = self else { return }
			self.viewModel.sortAllPacks(by: .talk)
		}
		let smsAction = UIAlertAction(title: "Sms hakkına göre sırala", style: .default) { [weak self] _ in
			guard let `self` = self else { return }
			self.viewModel.sortAllPacks(by: .sms)
		}
		let cancelAction = UIAlertAction(title: "İptal", style: .cancel)
		controller.addAction(dataAction)
		controller.addAction(talkAction)
		controller.addAction(smsAction)
		controller.addAction(cancelAction)
		present(controller, animated: true)
	}
}

//MARK: - PacksViewModelDelegate
extension PacksViewController: PacksViewModelDelegate {
	func viewModelDidUpdate(viewModel: PacksViewModel) {
		UIView.transition(with: tableView,
						  duration: 0.35,
						  options: .transitionCrossDissolve,
						  animations: { self.tableView.reloadData() })
	}
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension PacksViewController {
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		
		return isFiltering() ? 1 : viewModel.numberOfSections
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.numberOfRows(in: section, isFiltered: isFiltering())
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "packageCell") as? PackageCell else {
			fatalError("PackageCell is nil")
		}
		let pack = viewModel.pack(for: indexPath, isFiltered: isFiltering())
		cell.pack = pack
		if viewModel.titleForHeader(in: indexPath.section) == "Favoriler" || (isFiltering() && searchController.searchBar.selectedScopeButtonIndex == 0) {
			cell.nameLabel.text = "\(pack.name) (\(pack.subscriptionType.localized()))"
		} else {
			cell.nameLabel.text = pack.name
		}
		cell.delegate = self
		return cell
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return isFiltering() ? "" : viewModel.titleForHeader(in: section)
	}
}

//MARK: - SwipeTableViewCellDelegate
extension PacksViewController: SwipeTableViewCellDelegate {
	
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
		guard orientation == .right, !isFiltering() else { return nil }
		if viewModel.titleForHeader(in: indexPath.section) == "Favoriler" {
			let notFavoriteAction = SwipeAction(style: .destructive, title: "Favorilerden çıkar") {[weak self] action, path in
				guard let `self` = self else { return }
				self.viewModel.removeFromFavorite(in: path)
			}
			notFavoriteAction.image = UIImage(named: "notFavorite")
			notFavoriteAction.backgroundColor = UIColor.red
			return [notFavoriteAction]
		} else {
			let favoriteAction = SwipeAction(style: .destructive, title: "Favorilere ekle") {[weak self] action, path in
				guard let `self` = self else { return }
				self.viewModel.addToFavorite(in: path)
			}
			favoriteAction.image = UIImage(named: "favorite")
			favoriteAction.backgroundColor = tableView.tintColor
			return [favoriteAction]
		}
	}
	
	func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
		var options = SwipeOptions()
		options.expansionStyle = .destructive
		options.transitionStyle = .border
		return options
	}
}

//MARK: - UISearchResultsUpdating
extension PacksViewController: UISearchBarDelegate, UISearchResultsUpdating {
	
	func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
		filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
	}
	
	func updateSearchResults(for searchController: UISearchController) {
		let searchBar = searchController.searchBar
		let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
		filterContentForSearchText(searchController.searchBar.text!, scope: scope)
	}
	
	private func configureSearchController() {
		searchController.searchBar.scopeButtonTitles = ["Tümü", "Yıllık", "Aylık", "Haftalık"]
		searchController.searchBar.delegate = self
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Paket ara"
		navigationItem.searchController = searchController
		definesPresentationContext = true
	}
	
	func searchBarIsEmpty() -> Bool {
		return searchController.searchBar.text?.isEmpty ?? true
	}
	
	func isFiltering() -> Bool {
		let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
		return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
	}
	
	func filterContentForSearchText(_ searchText: String, scope: String = "Tümü") {
		viewModel.filterPacks(searchText, in: scope)
	}
}
