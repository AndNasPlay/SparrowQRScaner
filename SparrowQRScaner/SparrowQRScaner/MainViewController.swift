//
//  MainViewController.swift
//  SparrowQRScaner
//
//  Created by Андрей Щекатунов on 13.03.2022.
//

import UIKit

final class MainViewController: UIViewController {

	private(set) lazy var cameraButtonVariables: CGFloat = 50.0

	private(set) lazy var cameraButton: UIButton = {
		let button = UIButton(type: .system)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.backgroundColor = .lightGray
		button.setTitle("Scan QR code", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.layer.cornerRadius = 5.0
		return button
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.addSubview(cameraButton)
		self.view.backgroundColor = .white
		self.cameraButton.addTarget(self,
									action: #selector(handleScanQRCodeTouchUpInseide),
									for: .touchUpInside)
	}

	@objc func handleScanQRCodeTouchUpInseide() {
		self.navigationController?.pushViewController(CameraViewController(),
													  animated: true)
	}

	override func updateViewConstraints() {
		super.updateViewConstraints()

		NSLayoutConstraint.activate([

			cameraButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
			cameraButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: cameraButtonVariables),
			cameraButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -cameraButtonVariables),
			cameraButton.heightAnchor.constraint(equalToConstant: cameraButtonVariables)

		])
	}

}

