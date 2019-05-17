//
//  PackageCell.swift
//  RandomAssignment
//
//  Created by Gökhan KOCA on 11.05.2019.
//  Copyright © 2019 gkoca. All rights reserved.
//

import UIKit
import SwipeCellKit

final class PackageCell: SwipeTableViewCell {

	var pack: Pack? {
		didSet {
			if let pack = pack {
				nameLabel.text = pack.name
				descriptionLabel.text = pack.desc
				talkValueLabel.text = "\(pack.tariff.talk) dakika konuşma"
				talkValueLabel.isHidden = pack.tariff.talkVal == 0
				dataValueLabel.text = "\(pack.tariff.dataVal / 1024) gb internet"
				dataValueLabel.isHidden = pack.tariff.dataVal == 0
				smsValueLabel.text = "\(pack.tariff.sms) adet sms"
				smsValueLabel.isHidden = pack.tariff.smsVal == 0
				
				if let benefits = pack.benefits {
					let fits = benefits.map { $0.rawValue }.joined(separator: ", ")
					benefitsLabel.text = "Ek faydalar: \(fits)"
				} else {
					benefitsLabel.text = ""
				}
				priceLabel.text = "\(pack.price) ₺"
				usedBeforLabel.text = pack.didUseBefore ? "Bu paketi daha önce kullandınız" : ""
				if let availabilityDate = pack.availableUntilDate {
					let formatter = DateFormatter()
					formatter.dateFormat = "dd-MM-yyyy"
					let formattedDate = formatter.string(from: availabilityDate)
					availabilityDateLabel.text = "\(formattedDate) tarihine kadar geçerli"
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
