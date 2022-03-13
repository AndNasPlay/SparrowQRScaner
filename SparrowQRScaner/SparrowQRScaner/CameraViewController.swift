//
//  CameraViewController.swift
//  SparrowQRScaner
//
//  Created by Андрей Щекатунов on 13.03.2022.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

	private(set) lazy var qrCodeButtonWidthAndHeightAnchor: CGFloat = 60.0

	var videoStream = AVCaptureVideoPreviewLayer()
	let session = AVCaptureSession()

	private(set) lazy var qrCodeButton: UIButton = {
		let button = UIButton(type: .custom)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.layer.cornerRadius = qrCodeButtonWidthAndHeightAnchor / 2
		button.clipsToBounds = true
		button.setBackgroundImage(UIImage(named: "qrCode"), for: .normal)
		return button
	}()

	private(set) lazy var videoView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white
		self.view.addSubview(videoView)
		self.view.addSubview(qrCodeButton)

		constraintsInit()
		setupGestures()
		setupStream()
	}

	private func setupGestures() {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapQRCodeButtonTouchUpInseide))
		tapGesture.numberOfTapsRequired = 1
		qrCodeButton.addGestureRecognizer(tapGesture)
	}

	private func setupStream() {

		guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return }

		do {
			let input = try AVCaptureDeviceInput(device: captureDevice)
			session.addInput(input)
		}
		catch {
			print("error")
		}

		let output = AVCaptureMetadataOutput()
		session.addOutput(output)

		videoStream = AVCaptureVideoPreviewLayer(session: session)
		videoStream.videoGravity = AVLayerVideoGravity.resizeAspectFill
		videoStream.frame = view.layer.bounds
		videoView.layer.addSublayer(videoStream)

		session.startRunning()
	}

	@objc func handleTapQRCodeButtonTouchUpInseide() {
		let popVC = PopoverTableViewController()
		popVC.modalPresentationStyle = .popover

		let popoverVC = popVC.popoverPresentationController
		popoverVC?.delegate = self
		popoverVC?.sourceView = self.qrCodeButton
		popoverVC?.sourceRect = CGRect(x: self.qrCodeButton.bounds.minX,
									   y: self.qrCodeButton.bounds.minY,
									   width: 0,
									   height: 0)

		popVC.preferredContentSize = CGSize(width: 300.0, height: 50.0)

		self.present(popVC, animated: true)
	}

	func constraintsInit() {
		NSLayoutConstraint.activate([

			videoView.topAnchor.constraint(equalTo: self.view.topAnchor),
			videoView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
			videoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			videoView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),

			qrCodeButton.heightAnchor.constraint(equalToConstant: qrCodeButtonWidthAndHeightAnchor),
			qrCodeButton.widthAnchor.constraint(equalToConstant: qrCodeButtonWidthAndHeightAnchor),
			qrCodeButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
												   constant: -30.0),
			qrCodeButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,
												 constant: -30.0)
		])
	}

}

extension CameraViewController: UIPopoverPresentationControllerDelegate {

	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		return .none
	}
}
