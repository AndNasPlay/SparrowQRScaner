//
//  QRCodeNewView.swift
//  SparrowQRScaner
//
//  Created by Андрей Щекатунов on 14.03.2022.
//

import UIKit

class QRCodeNewView: UIView {

	private(set) lazy var roundView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.borderWidth = 5.0
		view.layer.cornerRadius = 10.0
		view.layer.borderColor = UIColor.yellowMain.cgColor
		view.backgroundColor = .clear
		view.layer.masksToBounds = true
		return view
	}()

	private(set) lazy var topBottomView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .clear
		view.layer.borderWidth = 5.0
		view.layer.borderColor = UIColor.separator.cgColor
		view.layer.masksToBounds = true
		return view
	}()

	private(set) lazy var rightLeftView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .clear
		view.layer.borderWidth = 5.0
		view.layer.borderColor = UIColor.clear.cgColor
		view.layer.masksToBounds = true
		return view
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = .clear
		self.addSubview(roundView)
		self.addSubview(topBottomView)
		self.addSubview(rightLeftView)
		constraintsInit()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	private func constraintsInit() {
		NSLayoutConstraint.activate([

			roundView.topAnchor.constraint(equalTo: self.topAnchor),
			roundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			roundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			roundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),

			topBottomView.topAnchor.constraint(equalTo: self.roundView.topAnchor),
			topBottomView.bottomAnchor.constraint(equalTo: self.roundView.bottomAnchor),
			topBottomView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
			topBottomView.centerXAnchor.constraint(equalTo: self.centerXAnchor),

			rightLeftView.leadingAnchor.constraint(equalTo: self.roundView.leadingAnchor),
			rightLeftView.trailingAnchor.constraint(equalTo: self.roundView.trailingAnchor),
			rightLeftView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
			rightLeftView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
		])
	}
}
