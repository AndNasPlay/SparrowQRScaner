//
//  CameraViewController.swift
//  SparrowQRScaner
//
//  Created by Андрей Щекатунов on 13.03.2022.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

	var videoStream = AVCaptureVideoPreviewLayer()

	var session = AVCaptureSession()

	private(set) lazy var qrString: String = ""

	private(set) lazy var popVC = PopoverTableViewController()

	private(set) lazy var buttonsView = ButtonsCameraView()

	private(set) lazy var lablesFontofSize: CGFloat = 18.0

	private(set) lazy var videoView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	private(set) lazy var qrCodeView: QRCodeView = {
		let view = QRCodeView(frame: .zero)
		return view
	}()

	private(set) lazy var urlLable: UILabel = {
		let text = UILabel()
		text.translatesAutoresizingMaskIntoConstraints = false
		text.textColor = .darkText
		text.textAlignment = .center
		text.numberOfLines = 0
		text.font = UIFont.systemFont(ofSize: lablesFontofSize)
		text.text = "URL"
		text.sizeToFit()
		return text
	}()

	private(set) lazy var safaryLable: UILabel = {
		let text = UILabel()
		text.textColor = .darkText
		text.textAlignment = .center
		text.numberOfLines = 1
		text.font = UIFont.systemFont(ofSize: lablesFontofSize)
		text.text = "Search"
		text.sizeToFit()
		return text
	}()

	private(set) lazy var safatiImg: UIImageView = {
		let img = UIImageView()
		img.translatesAutoresizingMaskIntoConstraints = false
		img.image = UIImage(systemName: "safari")
		img.tintColor = .darkText
		return img
	}()

	private(set) lazy var searchStackView: UIStackView = {
		let stack = UIStackView()
		stack.translatesAutoresizingMaskIntoConstraints = false
		stack.alignment = .bottom
		stack.axis = .horizontal
		stack.distribution = .fillProportionally
		return stack
	}()

	private(set) lazy var allQrItemsStackView: UIStackView = {
		let stack = UIStackView(frame: CGRect(x: 50.0,
											 y: self.qrCodeView.bounds.maxY + 5.0,
											 width: self.view.bounds.width - 80.0,
											 height: 100.0))
		stack.alignment = .center
		stack.axis = .vertical
		stack.distribution = .fill
		stack.backgroundColor = .yellowMain
		stack.layer.cornerRadius = 40.0
		return stack
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white

		addSubviews()

		self.qrCodeView.isHidden = true
		self.allQrItemsStackView.isHidden = true

		constraintsInit()
		setupGestures()
		setupStream()
	}

	private func addSubviews() {

		self.view.addSubview(videoView)
		self.view.addSubview(buttonsView)
		self.view.addSubview(qrCodeView)

		self.searchStackView.addArrangedSubview(safatiImg)
		self.searchStackView.addArrangedSubview(safaryLable)

		self.allQrItemsStackView.addArrangedSubview(searchStackView)
		self.allQrItemsStackView.addArrangedSubview(urlLable)

		self.view.addSubview(allQrItemsStackView)
	}

	private func setupGestures() {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapQRCodeButtonTouchUpInseide))
		tapGesture.numberOfTapsRequired = 1
		buttonsView.qrCodeButton.addGestureRecognizer(tapGesture)
	}

	private func setupStream() {

		guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return }

		do {
			let input = try AVCaptureDeviceInput(device: captureDevice)
			session.addInput(input)
		}
		catch {
			print("input error")
		}

		let output = AVCaptureMetadataOutput()
		session.addOutput(output)

		output.setMetadataObjectsDelegate(self,
										  queue: DispatchQueue.main)
		output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]

		videoStream = AVCaptureVideoPreviewLayer(session: session)
		videoStream.videoGravity = AVLayerVideoGravity.resizeAspectFill
		videoStream.frame = view.layer.bounds
		videoView.layer.addSublayer(videoStream)

		session.startRunning()
	}

	@objc func handleTapQRCodeButtonTouchUpInseide() {
		popVC.qrTableViewHeader = self.qrString
		popVC.modalPresentationStyle = .popover

		let popoverVC = popVC.popoverPresentationController
		popoverVC?.delegate = self
		popoverVC?.sourceView = self.buttonsView.qrCodeButton
		popoverVC?.sourceRect = CGRect(x: self.buttonsView.qrCodeButton.bounds.minX,
									   y: self.buttonsView.qrCodeButton.bounds.minY,
									   width: 0,
									   height: 0)

		popVC.preferredContentSize = CGSize(width: 300.0, height: 50.0)

		self.present(popVC, animated: true)
	}

	func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
		guard metadataObjects.isEmpty == false else {
			self.buttonsView.qrCodeButton.isHidden = true
			self.qrCodeView.isHidden = true
			self.allQrItemsStackView.isHidden = true
			self.qrString = ""
			return

		}

		if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
			if object.type == AVMetadataObject.ObjectType.qr {
				self.buttonsView.qrCodeButton.isHidden = false
				self.qrCodeView.isHidden = false
				self.qrString = object.stringValue ?? ""
				self.urlLable.text = object.stringValue ?? ""
				self.allQrItemsStackView.isHidden = false
				let getFrameQrCode = videoStream.transformedMetadataObject(for: object)
				guard let frameQrCode = getFrameQrCode?.bounds else { return }
				self.qrCodeView.frame = frameQrCode
				self.allQrItemsStackView.frame = CGRect(x: 50.0,
												   y: frameQrCode.maxY + 5.0,
												width: self.view.bounds.width - 100.0,
												height: 80.0)
			}
		}

	}

	func constraintsInit() {
		NSLayoutConstraint.activate([

			videoView.topAnchor.constraint(equalTo: self.view.topAnchor),
			videoView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
			videoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			videoView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),

			buttonsView.topAnchor.constraint(equalTo: self.view.topAnchor),
			buttonsView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			buttonsView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
			buttonsView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
			
		])
	}
}

extension CameraViewController: UIPopoverPresentationControllerDelegate {

	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		return .none
	}
}
