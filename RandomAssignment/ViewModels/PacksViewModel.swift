//
//  PacksViewModel.swift
//  RandomAssignment
//
//  Created by Gökhan KOCA on 11.05.2019.
//  Copyright © 2019 gkoca. All rights reserved.
//

import Foundation

protocol PacksViewModelDelegate: class {
	func viewModelDidUpdate(viewModel: PacksViewModel)
}

final class PacksViewModel: NSObject {
	
	weak var delegate: PacksViewModelDelegate?
	
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
			sortAllPacks()
		}
	}
	private var sectionHeaders = [String]()
	private var favoritePacks = [Pack]()
	private var yearlyPacks = [Pack]()
	private var monthlyPacks = [Pack]()
	private var weeklyPacks = [Pack]()
	private var filteredPacks = [Pack]()
	
	public private(set) var numberOfSections = 0
}

//MARK: - Public
extension PacksViewModel {
	
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
		return title
	}
	
	func numberOfRows(in section: Int, isFiltered: Bool) -> Int {
		if isFiltered {
			return filteredPacks.count
		} else {
			guard
				let sectionHeader = sectionHeaders[safeIndex: section]
				else { return 0 }
			let count = packs(for: sectionHeader).count
			return count
		}
	}
	
	func pack(for indexPath: IndexPath, isFiltered: Bool) -> Pack {
		if isFiltered {
			return filteredPacks[indexPath.row]
		} else {
			guard
				let section = sectionHeaders[safeIndex: indexPath.section]
				else { fatalError("section is nil") }
			let pack = packs(for: section)[indexPath.row]
			return pack
		}
	}
	
	func packs(for section: String) -> [Pack] {
		switch section {
		case "Favoriler":
			return favoritePacks
		case "Yıllık":
			return yearlyPacks
		case "Aylık":
			return monthlyPacks
		case "Haftalık":
			return weeklyPacks
		default:
			fatalError("unknown section")
		}
	}
	
	func addToFavorite(in indexPath: IndexPath) {
		let pack = self.pack(for: indexPath, isFiltered: false)
		if let section = sectionHeaders[safeIndex: indexPath.section] {
			switch section {
			case "Yıllık":
				yearlyPacks.remove(at: indexPath.row)
			case "Aylık":
				monthlyPacks.remove(at: indexPath.row)
			case "Haftalık":
				weeklyPacks.remove(at: indexPath.row)
			default:
				fatalError("unknown section")
			}
			Dispatch.mainAsync(after: 0.5) { [weak self] in
				guard let `self` = self else { return }
				self.favoritePacks.append(pack)
				self.favoritePacks = self.sortedPacks(packs: self.favoritePacks)
				self.configureSections()
				let favorites = self.favoritePacks.map{ $0.name }
				UserDefaults.standard.set(favorites, forKey: FAVORITE_KEY)
				UserDefaults.standard.synchronize()
			}
		}
	}
	
	func removeFromFavorite(in indexPath: IndexPath) {
		let pack = self.pack(for: indexPath, isFiltered: false)
		favoritePacks.remove(at: indexPath.row)
		let favorites = favoritePacks.map{ $0.name }
		UserDefaults.standard.set(favorites, forKey: FAVORITE_KEY)
		UserDefaults.standard.synchronize()
		Dispatch.mainAsync(after: 0.5) { [weak self] in
			guard let `self` = self else { return }
			switch pack.subscriptionType {
			case .monthly:
				self.monthlyPacks.append(pack)
				self.monthlyPacks = self.sortedPacks(packs: self.monthlyPacks)
			case .weekly:
				self.weeklyPacks.append(pack)
				self.weeklyPacks = self.sortedPacks(packs: self.weeklyPacks)
			case .yearly:
				self.yearlyPacks.append(pack)
				self.yearlyPacks = self.sortedPacks(packs: self.yearlyPacks)
			}
			self.configureSections()
		}
	}
	
	func sortAllPacks(by option: PackSortOption = .talk) {
		favoritePacks = sortedPacks(packs: favoritePacks, by: option)
		yearlyPacks = sortedPacks(packs: yearlyPacks, by: option)
		monthlyPacks = sortedPacks(packs: monthlyPacks, by: option)
		weeklyPacks = sortedPacks(packs: weeklyPacks, by: option)
		configureSections()
	}
	
	func filterPacks(_ searchText: String, in scope: String) {
		var searchPacks = [Pack]()
		switch scope {
		case "Yıllık":
			searchPacks = packs.filter{ $0.subscriptionType == .yearly }
		case "Aylık":
			searchPacks = packs.filter{ $0.subscriptionType == .monthly }
		case "Haftalık":
			searchPacks = packs.filter{ $0.subscriptionType == .weekly }
		default:
			searchPacks = packs
		}
		filteredPacks = searchPacks.filter{ $0.name.range(of: searchText, options: [.diacriticInsensitive, .caseInsensitive]) != nil }
		delegate?.viewModelDidUpdate(viewModel: self)
	}
}


//MARK: - Private
fileprivate extension PacksViewModel {
	
	func sortedPacks(packs: [Pack], by option: PackSortOption = .talk) ->[Pack] {
		let sortedPacks = packs.sorted { (lhs, rhs) -> Bool in
			switch option {
			case .talk:
				return lhs.tariff.talkVal > rhs.tariff.talkVal
			case .data:
				return lhs.tariff.dataVal > rhs.tariff.dataVal
			case .sms:
				return lhs.tariff.smsVal > rhs.tariff.smsVal
			}
		}
		return sortedPacks
	}
	
	func configureSections() {
		sectionHeaders.removeAll()
		if favoritePacks.count > 0 { sectionHeaders.append("Favoriler") }
		if yearlyPacks.count > 0 { sectionHeaders.append("Yıllık") }
		if monthlyPacks.count > 0 { sectionHeaders.append("Aylık") }
		if weeklyPacks.count > 0 { sectionHeaders.append("Haftalık") }
		numberOfSections = sectionHeaders.count
		delegate?.viewModelDidUpdate(viewModel: self)
	}
}

enum PackSortOption: Int {
	case talk = 0
	case data
	case sms
}
