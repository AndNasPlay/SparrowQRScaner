//
//  PopoverTableViewController.swift
//  SparrowQRScaner
//
//  Created by Андрей Щекатунов on 13.03.2022.
//

import UIKit

class PopoverTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.isScrollEnabled = false
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")

    }

	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		preferredContentSize = CGSize(width: 300.0, height: tableView.contentSize.height)
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Qr code title"
	}

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

		var content = cell.defaultContentConfiguration()
		content.text = "title"
		cell.contentConfiguration = content

        return cell
    }

}
