//
//  ButtonsCameraView.swift
//  SparrowQRScaner
//
//  Created by Андрей Щекатунов on 16.03.2022.
//

import UIKit

protocol ButtonsCameraViewDelegate {
	func scale1X()
	func scale2X()
	func scale3X()
}

final class ButtonsCameraView: UIView {

	var delegate: ButtonsCameraViewDelegate?

	private(set) lazy var qrCodeButtonWidthAndHeightAnchor: CGFloat = 60.0

	private(set) lazy var qrCodeButtonAnchor: CGFloat = 30.0

	private(set) lazy var buttonsStackViewLeadingAnchor: CGFloat = 20.0

	private(set) lazy var buttonsStackViewSpacing: CGFloat = 5.0

	private(set) lazy var qrCodeButton: UIButton = {
		let button = UIButton(type: .custom)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.layer.cornerRadius = qrCodeButtonWidthAndHeightAnchor / 2
		button.clipsToBounds = true
		button.setBackgroundImage(UIImage(named: "qrCode"), for: .normal)
		return button
	}()

	private(set) lazy var scale2XButton: UIButton = {
		let button = UIButton(type: .custom)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.layer.cornerRadius = qrCodeButtonWidthAndHeightAnchor / 2
		button.clipsToBounds = true
		button.backgroundColor = .separator
		button.setTitleColor(UIColor.yellowMain, for: .disabled)
		button.setTitle("2", for: .normal)
		return button
	}()

	private(set) lazy var scale1XButton: UIButton = {
		let button = UIButton(type: .custom)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.layer.cornerRadius = qrCodeButtonWidthAndHeightAnchor / 2
		button.clipsToBounds = true
		button.backgroundColor = .separator
		button.setTitleColor(UIColor.yellowMain, for: .disabled)
		button.isEnabled = false
		button.setTitle("1X", for: .normal)
		return button
	}()

	private(set) lazy var scale3XButton: UIButton = {
		let button = UIButton(type: .custom)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.layer.cornerRadius =  qrCodeButtonWidthAndHeightAnchor / 2
		button.clipsToBounds = true
		button.backgroundColor = .separator
		button.setTitleColor(UIColor.yellowMain, for: .disabled)
		button.setTitle("3", for: .normal)
		return button
	}()

	private(set) lazy var buttonsStackView: UIStackView = {
		let stack = UIStackView()
		stack.translatesAutoresizingMaskIntoConstraints = false
		stack.alignment = .center
		stack.axis = .horizontal
		stack.backgroundColor = .separator
		stack.layer.cornerRadius = qrCodeButtonWidthAndHeightAnchor / 2
		stack.distribution = .fillProportionally
		stack.spacing = buttonsStackViewSpacing
		return stack
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = .clear
		self.translatesAutoresizingMaskIntoConstraints = false

		addSubviews()
		constraintsInit()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	private func addSubviews() {

		self.addSubview(qrCodeButton)

		self.scale2XButton.addTarget(self,
									   action: #selector(handleScale2XTouchUpInseide),
									   for: .touchUpInside)
		self.scale1XButton.addTarget(self,
									   action: #selector(handleScale1XButtonTouchUpInseide),
									   for: .touchUpInside)
		self.scale3XButton.addTarget(self,
									   action: #selector(handleScale3XButtonTouchUpInseide),
									   for: .touchUpInside)

		self.buttonsStackView.addArrangedSubview(scale2XButton)
		self.buttonsStackView.addArrangedSubview(scale1XButton)
		self.buttonsStackView.addArrangedSubview(scale3XButton)

		self.addSubview(buttonsStackView)
	}

	@objc func handleScale2XTouchUpInseide() {
		selectedButton(number: 1)
		delegate?.scale2X()
	}

	@objc func handleScale1XButtonTouchUpInseide() {
		selectedButton(number: 2)
		delegate?.scale1X()
	}

	@objc func handleScale3XButtonTouchUpInseide() {
		selectedButton(number: 3)
		delegate?.scale3X()
	}

	private func selectedButton(number: Int) {

		if number == 1 {

			self.scale2XButton.setTitle("2X", for: .normal)
			self.scale1XButton.setTitle("1", for: .normal)
			self.scale3XButton.setTitle("3", for: .normal)

			self.scale2XButton.isEnabled = false
			self.scale1XButton.isEnabled = true
			self.scale3XButton.isEnabled = true

		} else if number == 2 {

			self.scale2XButton.setTitle("2", for: .normal)
			self.scale1XButton.setTitle("1X", for: .normal)
			self.scale3XButton.setTitle("3", for: .normal)

			self.scale2XButton.isEnabled = true
			self.scale1XButton.isEnabled = false
			self.scale3XButton.isEnabled = true

		} else {

			self.scale2XButton.setTitle("2", for: .normal)
			self.scale1XButton.setTitle("1", for: .normal)
			self.scale3XButton.setTitle("3X", for: .normal)

			self.scale2XButton.isEnabled = true
			self.scale1XButton.isEnabled = true
			self.scale3XButton.isEnabled = false
		}
	}

	func constraintsInit() {
		NSLayoutConstraint.activate([

			qrCodeButton.heightAnchor.constraint(equalToConstant: qrCodeButtonWidthAndHeightAnchor),
			qrCodeButton.widthAnchor.constraint(equalToConstant: qrCodeButtonWidthAndHeightAnchor),
			qrCodeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor,
												   constant: -qrCodeButtonAnchor),
			qrCodeButton.bottomAnchor.constraint(equalTo: self.bottomAnchor,
												 constant: -qrCodeButtonAnchor),

			scale2XButton.heightAnchor.constraint(equalToConstant: qrCodeButtonWidthAndHeightAnchor),
			scale1XButton.heightAnchor.constraint(equalToConstant: qrCodeButtonWidthAndHeightAnchor),
			scale3XButton.heightAnchor.constraint(equalToConstant: qrCodeButtonWidthAndHeightAnchor),

			scale2XButton.widthAnchor.constraint(equalToConstant: qrCodeButtonWidthAndHeightAnchor),
			scale1XButton.widthAnchor.constraint(equalToConstant: qrCodeButtonWidthAndHeightAnchor),
			scale3XButton.widthAnchor.constraint(equalToConstant: qrCodeButtonWidthAndHeightAnchor),

			buttonsStackView.centerYAnchor.constraint(equalTo: self.qrCodeButton.centerYAnchor),
			buttonsStackView.trailingAnchor.constraint(equalTo: self.qrCodeButton.leadingAnchor,
													   constant: -buttonsStackViewLeadingAnchor)
		])
	}
}


