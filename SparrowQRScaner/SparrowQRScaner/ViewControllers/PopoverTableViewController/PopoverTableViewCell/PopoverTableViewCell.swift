//
//  PopoverTableViewCell.swift
//  SparrowQRScaner
//
//  Created by Андрей Щекатунов on 13.03.2022.
//

import UIKit

class PopoverTableViewCell: UITableViewCell {
	
	static let identifier = "PopoverTableViewCell"

	private(set) lazy var lablesFontofSize: CGFloat = 20.0

	private(set) lazy var copyImgWidthAnchor: CGFloat = 30.0

	private(set) lazy var stackViewTopBottomAnchors: CGFloat = 10.0

	private(set) lazy var stackViewLeftRightAnchors: CGFloat = 20.0

	private(set) lazy var copyLable: UILabel = {
		let text = UILabel()
		text.translatesAutoresizingMaskIntoConstraints = false
		text.textAlignment = .left
		text.numberOfLines = 1
		text.font = UIFont.systemFont(ofSize: lablesFontofSize)
		text.text = "Copy"
		text.sizeToFit()
		return text
	}()
	
	private(set) lazy var copyImg: UIImageView = {
		let img = UIImageView()
		img.translatesAutoresizingMaskIntoConstraints = false
		img.image = UIImage(systemName: "doc.on.doc")
		img.tintColor = .imgColor
		return img
	}()
	
	private(set) lazy var stackView: UIStackView = {
		let stack = UIStackView()
		stack.translatesAutoresizingMaskIntoConstraints = false
		stack.alignment = .fill
		stack.axis = .horizontal
		stack.distribution = .fillProportionally
		return stack
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		selectionStyle = .gray
		
		contentView.addSubview(stackView)
		stackView.addArrangedSubview(copyLable)
		stackView.addArrangedSubview(copyImg)
		constraintsInit()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	private func constraintsInit() {
		
		NSLayoutConstraint.activate([
			
			stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor,
										   constant: stackViewTopBottomAnchors),
			stackView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor,
											constant: stackViewLeftRightAnchors),
			stackView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor,
											 constant: -stackViewLeftRightAnchors),
			stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,
											  constant: -stackViewTopBottomAnchors),
			
			copyImg.widthAnchor.constraint(equalToConstant: copyImgWidthAnchor)
		])
	}
}
