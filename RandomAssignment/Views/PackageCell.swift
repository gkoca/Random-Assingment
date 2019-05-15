//
//  PackageCell.swift
//  RandomAssignment
//
//  Created by Gökhan KOCA on 11.05.2019.
//  Copyright © 2019 gkoca. All rights reserved.
//

import UIKit
import SwipeCellKit

class PackageCell: SwipeTableViewCell {

	var pack: Pack? {
		didSet {
			if let pack = pack {
				nameLabel.text = pack.name
				descriptionLabel.text = pack.desc
				talkValueLabel.text = pack.tariff.talk
				dataValueLabel.text = pack.tariff.data
				smsValueLabel.text = pack.tariff.sms
				if let benefits = pack.benefits {
					let fits = benefits.map { $0.rawValue }.joined(separator: ", ")
					benefitsLabel.text = fits
				} else {
					benefitsLabel.text = ""
				}
				priceLabel.text = String(pack.price)
				usedBeforLabel.text = pack.didUseBefore ? "You used this package before" : ""
				if let availabilityDate = pack.availableUntilDate {
					let formatter = DateFormatter()
					formatter.dateFormat = "dd-MM-yyyy"
					let formattedDate = formatter.string(from: availabilityDate)
					availabilityDateLabel.text = "Available until \(formattedDate)"
				}
			}
		}
	}
	
	@IBOutlet weak var nameLabel: UILabel!
	
	@IBOutlet weak var descriptionLabel: UILabel!
	
	@IBOutlet weak var talkValueLabel: UILabel!
	
	@IBOutlet weak var dataValueLabel: UILabel!
	
	@IBOutlet weak var smsValueLabel: UILabel!
	
	@IBOutlet weak var priceLabel: UILabel!
	
	@IBOutlet weak var availabilityDateLabel: UILabel!
	
	@IBOutlet weak var benefitsLabel: UILabel!
	
	@IBOutlet weak var usedBeforLabel: UILabel!

}
