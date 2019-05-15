//
//  PackSevice.swift
//  RandomAssignment
//
//  Created by Gökhan KOCA on 11.05.2019.
//  Copyright © 2019 gkoca. All rights reserved.
//

protocol PackServiceProtocol {
	func fetch(complete: @escaping (Packs?)->Void)
}
