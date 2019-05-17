//
//  MockPackService.swift
//  RandomAssignment
//
//  Created by Gökhan KOCA on 11.05.2019.
//  Copyright © 2019 gkoca. All rights reserved.
//

import Foundation

final class MockPackService: PackServiceProtocol {
	
	func fetch(complete: @escaping (Packs?) -> Void) {
		if let jsonUrl = Bundle.main.url(forResource: "packageList", withExtension: "json") {
			do {
				complete(try Packs(fromURL: jsonUrl))
			} catch {
				complete(nil)
				print(error)
			}
		} else {
			complete(nil)
			print("ERROR. Something wrong with jsonUrl")
		}
	}
}
