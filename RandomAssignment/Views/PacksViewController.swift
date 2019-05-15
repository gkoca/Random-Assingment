//
//  PacksViewController.swift
//  RandomAssignment
//
//  Created by Gökhan KOCA on 11.05.2019.
//  Copyright © 2019 gkoca. All rights reserved.
//

import UIKit
import SwipeCellKit

class PacksViewController: UITableViewController {
	
	
	@IBOutlet var viewModel: PacksViewModel!
	
	var isFiltered = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		viewModel.load()
		tableView.reloadData()
	}
	
}

extension PacksViewController {
	override func numberOfSections(in tableView: UITableView) -> Int {
		return isFiltered ? 1 : viewModel.numberOfSections
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.numberOfRows(in: section, isFiltered: isFiltered)
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "packageCell") as? PackageCell else {
			fatalError("PackageCell is nil")
		}
		cell.pack = viewModel.pack(for: indexPath, isFiltered: isFiltered)
		cell.delegate = self
		return cell
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return viewModel.titleForHeader(in: section)
	}
	
}

extension PacksViewController: SwipeTableViewCellDelegate {
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
		guard orientation == .right else { return nil }
		
		if viewModel.titleForHeader(in: indexPath.section) == "FAVORITE" {
			let notFavoriteAction = SwipeAction(style: .destructive, title: "Remove Favorite") {[weak self] action, indexPath in
				// handle action by updating model with deletion
				guard let `self` = self else { return }
				self.viewModel.removeFromFavorite(in: indexPath)
//				self.tableView.reloadData()
				
			}
			notFavoriteAction.image = UIImage(named: "notFavorite")
			notFavoriteAction.backgroundColor = UIColor.red
			return [notFavoriteAction]
		} else {
			let favoriteAction = SwipeAction(style: .destructive, title: "Favorite") {[weak self] action, indexPath in
				// handle action by updating model with deletion
				guard let `self` = self else { return }
				self.viewModel.addToFavorite(in: indexPath)
//				self.tableView.reloadData()
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
