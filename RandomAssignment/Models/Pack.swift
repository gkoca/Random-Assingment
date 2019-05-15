//
//  Pack.swift
//  RandomAssignment
//
//  Created by Gökhan KOCA on 11.05.2019.
//  Copyright © 2019 gkoca. All rights reserved.
//

import Foundation

struct Pack: Codable {
	let name, desc: String
	let subscriptionType: SubscriptionType
	let didUseBefore: Bool
	let benefits: [Benefit]?
	let price: Double
	let tariff: Tariff
	var availableUntil: String
	var availableUntilDate: Date? {
		get {
			guard let timeInterval = TimeInterval(availableUntil) else { return nil }
			return Date(timeIntervalSince1970: timeInterval)
		}
	}
	
	private enum CodingKeys: String, CodingKey {
		case name, desc, subscriptionType, didUseBefore, benefits, price, tariff, availableUntil
	}
}

struct Packs: Codable {
	let packs: [Pack]
}

extension Packs {
	
	init() {
		packs = []
	}
	
	init(data: Data) throws {
		self = try Util.newJSONDecoder().decode(Packs.self, from: data)
	}
	
	init(fromURL url: URL) throws {
		try self.init(data: try Data(contentsOf: url))
	}
	
}


