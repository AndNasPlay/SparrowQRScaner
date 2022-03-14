//
//  QRCodeView.swift
//  SparrowQRScaner
//
//  Created by Андрей Щекатунов on 14.03.2022.
//

import UIKit

class QRCodeView: UIView {

	var radius: CGFloat = 10.0
	var lineLength: CGFloat = 30
	var lineWidth: CGFloat = 5.0
	var lineColor: UIColor = UIColor.yellowMain

	var shapeLayer: CAShapeLayer!

	override class var layerClass: AnyClass {
		return CAShapeLayer.self
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}

	func commonInit() -> Void {
		shapeLayer = self.layer as? CAShapeLayer
		shapeLayer.fillColor = UIColor.clear.cgColor
		shapeLayer.lineCap = .round
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		shapeLayer.strokeColor = lineColor.cgColor
		shapeLayer.lineWidth = lineWidth

		let pth = UIBezierPath()

		var ptA: CGPoint = .zero
		var ptB: CGPoint = .zero
		var ptC: CGPoint = .zero
		var ptD: CGPoint = .zero
		var arcCenter: CGPoint = .zero
		var startAngle: CGFloat = 0

		startAngle = .pi

		ptA.x = bounds.minX
		ptA.y = bounds.minY + radius + lineLength

		ptB.x = bounds.minX
		ptB.y = bounds.minY + radius

		ptC.x = bounds.minX + radius
		ptC.y = bounds.minY

		ptD.x = bounds.minX + radius + lineLength
		ptD.y = bounds.minY

		arcCenter.x = ptC.x
		arcCenter.y = ptB.y

		pth.move(to: ptA)
		pth.addLine(to: ptB)
		pth.addArc(withCenter: arcCenter,
				   radius: radius,
				   startAngle: startAngle,
				   endAngle: startAngle + .pi * 0.5,
				   clockwise: true)
		pth.addLine(to: ptD)

		startAngle += (.pi * 0.5)

		ptA.x = bounds.maxX - (radius + lineLength)
		ptA.y = bounds.minY

		ptB.x = bounds.maxX - radius
		ptB.y = bounds.minY

		ptC.x = bounds.maxX
		ptC.y = bounds.minY + radius

		ptD.x = bounds.maxX
		ptD.y = bounds.minY + radius + lineLength

		arcCenter.x = ptB.x
		arcCenter.y = ptC.y

		pth.move(to: ptA)
		pth.addLine(to: ptB)
		pth.addArc(withCenter: arcCenter,
				   radius: radius, startAngle:
					startAngle, endAngle:
					startAngle + .pi * 0.5,
				   clockwise: true)
		pth.addLine(to: ptD)


		startAngle += (.pi * 0.5)

		ptA.x = bounds.maxX
		ptA.y = bounds.maxY - (radius + lineLength)

		ptB.x = bounds.maxX
		ptB.y = bounds.maxY - radius

		ptC.x = bounds.maxX - radius
		ptC.y = bounds.maxY

		ptD.x = bounds.maxX - (radius + lineLength)
		ptD.y = bounds.maxY

		arcCenter.x = ptC.x
		arcCenter.y = ptB.y
		pth.move(to: ptA)
		pth.addLine(to: ptB)
		pth.addArc(withCenter: arcCenter,
				   radius: radius,
				   startAngle: startAngle,
				   endAngle: startAngle + .pi * 0.5,
				   clockwise: true)

		pth.addLine(to: ptD)

		startAngle += (.pi * 0.5)

		ptA.x = bounds.minX + radius + lineLength
		ptA.y = bounds.maxY

		ptB.x = bounds.minX + radius
		ptB.y = bounds.maxY

		ptC.x = bounds.minX
		ptC.y = bounds.maxY - radius

		ptD.x = bounds.minX
		ptD.y = bounds.maxY - (radius + lineLength)

		arcCenter.x = ptB.x
		arcCenter.y = ptC.y

		pth.move(to: ptA)
		pth.addLine(to: ptB)
		pth.addArc(withCenter: arcCenter,
				   radius: radius, startAngle:
					startAngle,
				   endAngle: startAngle + .pi * 0.5,
				   clockwise: true)
		pth.addLine(to: ptD)

		shapeLayer.path = pth.cgPath
	}

}
