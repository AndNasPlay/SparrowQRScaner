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

		var ptA: CGPoint = .zero
		var ptB: CGPoint = .zero
		var ptC: CGPoint = .zero
		var ptD: CGPoint = .zero
		var arcCenter: CGPoint = .zero
		var startAngle: CGFloat = 0

		startAngle = .pi

		ptA.x = bounds.minX
		ptA.y = bounds.minY + radius + self.bounds.height*lineLength

		ptB.x = bounds.minX
		ptB.y = bounds.minY + radius

		ptC.x = bounds.minX + radius
		ptC.y = bounds.minY

		ptD.x = bounds.minX + radius + self.bounds.width*lineLength
		ptD.y = bounds.minY

		arcCenter.x = ptC.x
		arcCenter.y = ptB.y

		bezierPath.move(to: ptA)
		bezierPath.addLine(to: ptB)
		bezierPath.addArc(withCenter: arcCenter,
				   radius: radius,
				   startAngle: startAngle,
				   endAngle: startAngle + .pi * 0.5,
				   clockwise: true)
		bezierPath.addLine(to: ptD)

		startAngle += (.pi * 0.5)

		ptA.x = bounds.maxX - (radius + self.bounds.width*lineLength)
		ptA.y = bounds.minY

		ptB.x = bounds.maxX - radius
		ptB.y = bounds.minY

		ptC.x = bounds.maxX
		ptC.y = bounds.minY + radius

		ptD.x = bounds.maxX
		ptD.y = bounds.minY + radius + self.bounds.height*lineLength

		arcCenter.x = ptB.x
		arcCenter.y = ptC.y

		bezierPath.move(to: ptA)
		bezierPath.addLine(to: ptB)
		bezierPath.addArc(withCenter: arcCenter,
				   radius: radius, startAngle:
					startAngle, endAngle:
					startAngle + .pi * 0.5,
				   clockwise: true)
		bezierPath.addLine(to: ptD)


		startAngle += (.pi * 0.5)

		ptA.x = bounds.maxX
		ptA.y = bounds.maxY - (radius + self.bounds.width*lineLength)

		ptB.x = bounds.maxX
		ptB.y = bounds.maxY - radius

		ptC.x = bounds.maxX - radius
		ptC.y = bounds.maxY

		ptD.x = bounds.maxX - (radius + self.bounds.height*lineLength)
		ptD.y = bounds.maxY

		arcCenter.x = ptC.x
		arcCenter.y = ptB.y
		bezierPath.move(to: ptA)
		bezierPath.addLine(to: ptB)
		bezierPath.addArc(withCenter: arcCenter,
				   radius: radius,
				   startAngle: startAngle,
				   endAngle: startAngle + .pi * 0.5,
				   clockwise: true)

		bezierPath.addLine(to: ptD)

		startAngle += (.pi * 0.5)

		ptA.x = bounds.minX + radius + self.bounds.width*lineLength
		ptA.y = bounds.maxY

		ptB.x = bounds.minX + radius
		ptB.y = bounds.maxY

		ptC.x = bounds.minX
		ptC.y = bounds.maxY - radius

		ptD.x = bounds.minX
		ptD.y = bounds.maxY - (radius + self.bounds.height*lineLength)

		arcCenter.x = ptB.x
		arcCenter.y = ptC.y

		bezierPath.move(to: ptA)
		bezierPath.addLine(to: ptB)
		bezierPath.addArc(withCenter: arcCenter,
				   radius: radius, startAngle:
					startAngle,
				   endAngle: startAngle + .pi * 0.5,
				   clockwise: true)
		bezierPath.addLine(to: ptD)

		shapeLayer.path = bezierPath.cgPath
	}

}
