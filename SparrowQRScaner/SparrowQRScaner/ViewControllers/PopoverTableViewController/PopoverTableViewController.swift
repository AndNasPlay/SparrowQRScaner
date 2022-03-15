//
//  PopoverTableViewController.swift
//  SparrowQRScaner
//
//  Created by Андрей Щекатунов on 13.03.2022.
//

import UIKit
import SafariServices

class PopoverTableViewController: UITableViewController {

	public var qrTableViewHeader: String = "Qr code title"

    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.isScrollEnabled = false
		tableView.register(UITableViewCell.self,
										 forCellReuseIdentifier: "identifier")
		tableView.register(PopoverTableViewCell.self,
										 forCellReuseIdentifier: PopoverTableViewCell.identifier)
		self.tableView.dataSource = self
		self.tableView.delegate = self
    }

	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		preferredContentSize = CGSize(width: 300.0, height: tableView.contentSize.height)
	}

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		if indexPath.row == 0 {

			let cell = tableView.dequeueReusableCell(withIdentifier: "identifier",
															 for: indexPath)

			var content = cell.defaultContentConfiguration()
			content.text = qrTableViewHeader
			cell.selectionStyle = .none
			cell.contentConfiguration = content

			return cell

		} else if indexPath.row == 1 {
			let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: PopoverTableViewCell.identifier,
															 for: indexPath)
			guard let cell = dequeuedCell as? PopoverTableViewCell else {
				return dequeuedCell
			}
			
			return cell

		} else {
			let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: PopoverTableViewCell.identifier,
															 for: indexPath)
			guard let cell = dequeuedCell as? PopoverTableViewCell else {
				return dequeuedCell
			}

			cell.copyLable.text = "Search web"
			cell.copyImg.image = UIImage(systemName: "safari")
			return cell
		}
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row == 1 {
			UIPasteboard.general.string = qrTableViewHeader
			self.dismiss(animated: true,
						 completion: nil)

		} else if indexPath.row == 2 {
			guard let url = URL(string: qrTableViewHeader) else { return }
			let svc = SFSafariViewController(url: url)
			present(svc, animated: true, completion: nil)
		}
	}

}
