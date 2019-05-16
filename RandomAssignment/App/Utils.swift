//
//  Utils.swift
//  RandomAssignment
//
//  Created by Gökhan KOCA on 11.05.2019.
//  Copyright © 2019 gkoca. All rights reserved.
//

import Foundation

let FAVORITE_KEY = "works.gkoca.RandomAssignment.favorites"

enum Util {
	static func newJSONDecoder() -> JSONDecoder {
		let decoder = JSONDecoder()
		if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
			decoder.dateDecodingStrategy = .iso8601
		}
		return decoder
	}
}

extension Array {
	public subscript(safeIndex index: Int) -> Element? {
		guard index >= 0, index < endIndex else {
			return nil
		}
		
		return self[index]
	}
}

class Dispatch {
	static func mainAsync(_ block : @escaping ()->()) {
		DispatchQueue.main.async(execute: block)
	}
	
	static func mainAsync(after seconds: TimeInterval, block : @escaping ()->()) {
		DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: block)
	}
	
	static func background(_ block : @escaping ()->()) {
		DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async(execute: block)
	}
	
	static func background(after seconds: TimeInterval, block : @escaping ()->()) {
		DispatchQueue.global(qos: DispatchQoS.QoSClass.default).asyncAfter(deadline: .now() + seconds, execute: block)
	}
}
