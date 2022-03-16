//
//  QRCodeView.swift
//  SparrowQRScaner
//
//  Created by Андрей Щекатунов on 14.03.2022.
//

import UIKit

final class QRCodeView: UIView {

	let radius: CGFloat = 10.0
	let lineLength: CGFloat = 0.08
	let lineWidth: CGFloat = 5.0
	let lineColor: UIColor = UIColor.yellowMain

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

	private func commonInit() -> Void {
		shapeLayer = self.layer as? CAShapeLayer
		shapeLayer.fillColor = UIColor.clear.cgColor
		shapeLayer.lineCap = .round
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		shapeLayer.strokeColor = lineColor.cgColor
		shapeLayer.lineWidth = lineWidth

		let bezierPath = UIBezierPath()

		var pointA: CGPoint = .zero
		var pointB: CGPoint = .zero
		var pointC: CGPoint = .zero
		var pointD: CGPoint = .zero
		var arcCenter: CGPoint = .zero
		var startAngle: CGFloat = 0

		startAngle = .pi

		pointA.x = bounds.minX
		pointA.y = bounds.minY + radius + self.bounds.height*lineLength

		pointB.x = bounds.minX
		pointB.y = bounds.minY + radius

		pointC.x = bounds.minX + radius
		pointC.y = bounds.minY

		pointD.x = bounds.minX + radius + self.bounds.width*lineLength
		pointD.y = bounds.minY

		arcCenter.x = pointC.x
		arcCenter.y = pointB.y

		bezierPath.move(to: pointA)
		bezierPath.addLine(to: pointB)
		bezierPath.addArc(withCenter: arcCenter,
				   radius: radius,
				   startAngle: startAngle,
				   endAngle: startAngle + .pi * 0.5,
				   clockwise: true)
		bezierPath.addLine(to: pointD)

		startAngle += (.pi * 0.5)

		pointA.x = bounds.maxX - (radius + self.bounds.width*lineLength)
		pointA.y = bounds.minY

		pointB.x = bounds.maxX - radius
		pointB.y = bounds.minY

		pointC.x = bounds.maxX
		pointC.y = bounds.minY + radius

		pointD.x = bounds.maxX
		pointD.y = bounds.minY + radius + self.bounds.height*lineLength

		arcCenter.x = pointB.x
		arcCenter.y = pointC.y

		bezierPath.move(to: pointA)
		bezierPath.addLine(to: pointB)
		bezierPath.addArc(withCenter: arcCenter,
				   radius: radius, startAngle:
					startAngle, endAngle:
					startAngle + .pi * 0.5,
				   clockwise: true)
		bezierPath.addLine(to: pointD)


		startAngle += (.pi * 0.5)

		pointA.x = bounds.maxX
		pointA.y = bounds.maxY - (radius + self.bounds.width*lineLength)

		pointB.x = bounds.maxX
		pointB.y = bounds.maxY - radius

		pointC.x = bounds.maxX - radius
		pointC.y = bounds.maxY

		pointD.x = bounds.maxX - (radius + self.bounds.height*lineLength)
		pointD.y = bounds.maxY

		arcCenter.x = pointC.x
		arcCenter.y = pointB.y
		bezierPath.move(to: pointA)
		bezierPath.addLine(to: pointB)
		bezierPath.addArc(withCenter: arcCenter,
				   radius: radius,
				   startAngle: startAngle,
				   endAngle: startAngle + .pi * 0.5,
				   clockwise: true)

		bezierPath.addLine(to: pointD)

		startAngle += (.pi * 0.5)

		pointA.x = bounds.minX + radius + self.bounds.width*lineLength
		pointA.y = bounds.maxY

		pointB.x = bounds.minX + radius
		pointB.y = bounds.maxY

		pointC.x = bounds.minX
		pointC.y = bounds.maxY - radius

		pointD.x = bounds.minX
		pointD.y = bounds.maxY - (radius + self.bounds.height*lineLength)

		arcCenter.x = pointB.x
		arcCenter.y = pointC.y

		bezierPath.move(to: pointA)
		bezierPath.addLine(to: pointB)
		bezierPath.addArc(withCenter: arcCenter,
				   radius: radius, startAngle:
					startAngle,
				   endAngle: startAngle + .pi * 0.5,
				   clockwise: true)
		bezierPath.addLine(to: pointD)

		shapeLayer.path = bezierPath.cgPath
	}

}
