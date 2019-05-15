//
//  Tariff.swift
//  RandomAssignment
//
//  Created by Gökhan KOCA on 11.05.2019.
//  Copyright © 2019 gkoca. All rights reserved.
//

import Foundation

struct Tariff: Codable {
	let data, talk, sms: String
	
	var dataVal: Int {
		get {
			return Int(data) ?? 0
		}
	}
	var talkVal: Int {
		get {
			return Int(talk) ?? 0
		}
	}
	var smsVal: Int {
		get {
			return Int(sms) ?? 0
		}
	}
	
	private enum CodingKeys: String, CodingKey {
		case data, talk, sms
	}
}

