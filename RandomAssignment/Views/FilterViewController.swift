//
//  ViewController.swift
//  RandomAssignment
//
//  Created by Gökhan KOCA on 11.05.2019.
//  Copyright © 2019 gkoca. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	@IBAction func dismissView(_ sender: UIBarButtonItem) {
		if sender.tag == 0 {
			dismiss(animated: true)
			return
		}
		//TODO: apply filter
		dismiss(animated: true)
	}
}

