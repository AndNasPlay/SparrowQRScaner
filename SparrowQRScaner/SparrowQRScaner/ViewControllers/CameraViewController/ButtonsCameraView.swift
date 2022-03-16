//
//  ButtonsCameraView.swift
//  SparrowQRScaner
//
//  Created by Андрей Щекатунов on 16.03.2022.
//

import UIKit

final class ButtonsCameraView: UIView {

	private(set) lazy var qrCodeButtonWidthAndHeightAnchor: CGFloat = 60.0

	private(set) lazy var qrCodeButton: UIButton = {
		let button = UIButton(type: .custom)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.layer.cornerRadius = qrCodeButtonWidthAndHeightAnchor / 2
		button.clipsToBounds = true
		button.setBackgroundImage(UIImage(named: "qrCode"), for: .normal)
		return button
	}()

	private(set) lazy var scaleHalfButton: UIButton = {
		let button = UIButton(type: .custom)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.layer.cornerRadius = qrCodeButtonWidthAndHeightAnchor / 2
		button.clipsToBounds = true
		button.backgroundColor = .separator
		button.setTitleColor(UIColor.yellowMain, for: .selected)
		button.setTitle("0.5", for: .normal)
		return button
	}()

	private(set) lazy var scaleFirstButton: UIButton = {
		let button = UIButton(type: .custom)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.layer.cornerRadius = qrCodeButtonWidthAndHeightAnchor / 2
		button.clipsToBounds = true
		button.backgroundColor = .separator
		button.setTitleColor(UIColor.yellowMain, for: .selected)
		button.setTitle("1", for: .normal)
		return button
	}()

	private(set) lazy var scaleSecondButton: UIButton = {
		let button = UIButton(type: .custom)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.layer.cornerRadius =  qrCodeButtonWidthAndHeightAnchor / 2
		button.clipsToBounds = true
		button.backgroundColor = .separator
		button.setTitleColor(UIColor.yellowMain, for: .selected)
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
		stack.spacing = 5.0
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

		self.scaleHalfButton.addTarget(self,
									   action: #selector(handleScaleHalfCodeTouchUpInseide),
									   for: .touchUpInside)
		self.scaleFirstButton.addTarget(self,
									   action: #selector(handleScaleFirstCodeTouchUpInseide),
									   for: .touchUpInside)
		self.scaleSecondButton.addTarget(self,
									   action: #selector(handleScaleSecondCodeTouchUpInseide),
									   for: .touchUpInside)

		self.buttonsStackView.addArrangedSubview(scaleHalfButton)
		self.buttonsStackView.addArrangedSubview(scaleFirstButton)
		self.buttonsStackView.addArrangedSubview(scaleSecondButton)

		self.addSubview(buttonsStackView)
	}

	@objc func handleScaleHalfCodeTouchUpInseide() {
		selectedButton(number: 1)
	}

	@objc func handleScaleFirstCodeTouchUpInseide() {
		selectedButton(number: 2)
	}

	@objc func handleScaleSecondCodeTouchUpInseide() {
		selectedButton(number: 3)
	}

	private func selectedButton(number: Int) {

		if number == 1 {
			self.scaleHalfButton.isSelected = true
			self.scaleHalfButton.setTitle("0,5X", for: .normal)

			self.scaleFirstButton.isSelected = false
			self.scaleFirstButton.setTitle("1", for: .normal)

			self.scaleSecondButton.isSelected = false
			self.scaleSecondButton.setTitle("3", for: .normal)

		} else if number == 2 {

			self.scaleHalfButton.isSelected = false
			self.scaleHalfButton.setTitle("0,5", for: .normal)

			self.scaleFirstButton.isSelected = true
			self.scaleFirstButton.setTitle("1X", for: .normal)

			self.scaleSecondButton.isSelected = false
			self.scaleSecondButton.setTitle("3", for: .normal)

		} else {
			self.scaleHalfButton.isSelected = false
			self.scaleHalfButton.setTitle("0,5", for: .normal)

			self.scaleFirstButton.isSelected = false
			self.scaleFirstButton.setTitle("1", for: .normal)

			self.scaleSecondButton.isSelected = true
			self.scaleSecondButton.setTitle("3X", for: .normal)
		}
	}

	func constraintsInit() {
		NSLayoutConstraint.activate([

			qrCodeButton.heightAnchor.constraint(equalToConstant: qrCodeButtonWidthAndHeightAnchor),
			qrCodeButton.widthAnchor.constraint(equalToConstant: qrCodeButtonWidthAndHeightAnchor),
			qrCodeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor,
												   constant: -30.0),
			qrCodeButton.bottomAnchor.constraint(equalTo: self.bottomAnchor,
												 constant: -30.0),

			scaleHalfButton.heightAnchor.constraint(equalToConstant: 60.0),
			scaleFirstButton.heightAnchor.constraint(equalToConstant: 60.0),
			scaleSecondButton.heightAnchor.constraint(equalToConstant: 60.0),

			scaleHalfButton.widthAnchor.constraint(equalToConstant: 60.0),
			scaleFirstButton.widthAnchor.constraint(equalToConstant: 60.0),
			scaleSecondButton.widthAnchor.constraint(equalToConstant: 60.0),

			buttonsStackView.centerYAnchor.constraint(equalTo: self.qrCodeButton.centerYAnchor),
			buttonsStackView.trailingAnchor.constraint(equalTo: self.qrCodeButton.leadingAnchor,
													   constant: -20.0)
		])
	}
}


