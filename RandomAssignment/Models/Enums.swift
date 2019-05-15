//
//  Enums.swift
//  RandomAssignment
//
//  Created by Gökhan KOCA on 11.05.2019.
//  Copyright © 2019 gkoca. All rights reserved.
//

enum Benefit: String, Codable {
	case biP = "BiP"
	case dergilik = "Dergilik"
	case fizy = "Fizy"
	case lifebox = "lifebox"
	case platinum = "Platinum"
	case tvPlus = "TV+"
}

enum SubscriptionType: String, Codable, Comparable {
	case monthly = "monthly"
	case weekly = "weekly"
	case yearly = "yearly"
	
	func value() -> Int {
		switch self {
		case .monthly:
			return 2
		case .weekly:
			return 1
		case .yearly:
			return 3
		}
	}
	
	static func < (lhs: SubscriptionType, rhs: SubscriptionType) -> Bool {
		return lhs.value() < rhs.value()
	}
}

