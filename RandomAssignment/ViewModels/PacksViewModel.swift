//
//  PacksViewModel.swift
//  RandomAssignment
//
//  Created by Gökhan KOCA on 11.05.2019.
//  Copyright © 2019 gkoca. All rights reserved.
//

import Foundation

class PacksViewModel: NSObject {
	
	//TODO: order for data,talk,sms
	private var packs = [Pack]() {
		didSet {
			let favorites = UserDefaults.standard.object(forKey: FAVORITE_KEY) as? [String]
			for pack in packs {
				if favorites?.contains(pack.name) ?? false {
					favoritePacks.append(pack)
				} else {
					switch pack.subscriptionType {
					case .monthly:
						monthlyPacks.append(pack)
					case .weekly:
						weeklyPacks.append(pack)
					case .yearly:
						yearlyPacks.append(pack)
					}
				}
			}
			configureSections()
			sortPacks()
		}
	}
	
	
	private var favoritePacks = [Pack]()
	private var yearlyPacks = [Pack]()
	private var monthlyPacks = [Pack]()
	private var weeklyPacks = [Pack]()
	
	
	private var orderedPacks = [String:[Pack]]()
	private var sectionHeaders = [String]()
	
	private var filteredPacks = [Pack]()
	public private(set) var numberOfSections = 0
	
	func load() {
		MockPackService().fetch { [weak self] (result) in
			guard let `self` = self else { return }
			if let fetchedPacks = result {
				self.packs = fetchedPacks.packs
			}
		}
	}
	
	func titleForHeader(in section: Int) -> String {
		guard let title = sectionHeaders[safeIndex: section] else { return "" }
		return title.uppercased()
	}
	
	func numberOfRows(in section: Int, isFiltered: Bool) -> Int {
		if isFiltered {
			return filteredPacks.count
		} else {
			guard
				let section = sectionHeaders[safeIndex: section]
				else { return 0 }
			return packs(for: section).count
		}
	}
	
	func pack(for indexPath: IndexPath, isFiltered: Bool) -> Pack {
		if isFiltered {
			return filteredPacks[indexPath.row]
		} else {
			guard
				let section = sectionHeaders[safeIndex: indexPath.section]
				else { fatalError("section is nil") }
			return packs(for: section)[indexPath.row]
		}
	}
	
	func packs(for section: String) -> [Pack] {
		switch section {
		case "favorites":
			return favoritePacks
		case "yearly":
			return yearlyPacks
		case "monthly":
			return monthlyPacks
		case "weekly":
			return weeklyPacks
		default:
			fatalError("unknown section")
		}
	}
	func configureSections() {
		if favoritePacks.count > 0 { sectionHeaders.append("favorites") }
		if yearlyPacks.count > 0 { sectionHeaders.append("yearly") }
		if monthlyPacks.count > 0 { sectionHeaders.append("monthly") }
		if weeklyPacks.count > 0 { sectionHeaders.append("weekly") }
	}
	
	// TODO: simplify
	func addToFavorite(in indexPath: IndexPath) {
		
		
		let pack = self.pack(for: indexPath, isFiltered: false)
		
		
		
		if orderedPacks["favorite"] != nil {
			if let pack = orderedPacks[orderedPacksKeys[indexPath.section]]?[indexPath.row] {
				orderedPacks[orderedPacksKeys[indexPath.section]]!.remove(at: indexPath.row)
				orderedPacks["favorite"]!.append(pack)
				// todo: notify
				let favorites = orderedPacks["favorite"]!.map{ $0.name }
				UserDefaults.standard.set(favorites, forKey: FAVORITE_KEY)
				UserDefaults.standard.synchronize()
			}
		} else {
			if let pack = orderedPacks[orderedPacksKeys[indexPath.section]]?[indexPath.row] {
				orderedPacks[orderedPacksKeys[indexPath.section]]!.remove(at: indexPath.row)
				orderedPacks["favorite"] = [pack]
				// todo: notify
				let favorites = orderedPacks["favorite"]!.map{ $0.name }
				UserDefaults.standard.set(favorites, forKey: FAVORITE_KEY)
				UserDefaults.standard.synchronize()
			}
		}
	}
	
	func removeFromFavorite(in indexPath: IndexPath) {
		guard orderedPacks["favorite"] != nil else { return }
		if let pack = orderedPacks["favorite"]?[indexPath.row] {
			orderedPacks["favorite"]!.remove(at: indexPath.row)
			
			let subscriptionType = pack.subscriptionType.rawValue
			if orderedPacks[subscriptionType] != nil {
				orderedPacks[subscriptionType]!.append(pack)
			} else {
				orderedPacks[subscriptionType] = [pack]
			}
			

			// todo: notify
			let favorites = orderedPacks["favorite"]!.map{ $0.name }
			UserDefaults.standard.set(favorites, forKey: FAVORITE_KEY)
			UserDefaults.standard.synchronize()
		}
	}
	
	
	func sortPacks() {
		
	}
}
