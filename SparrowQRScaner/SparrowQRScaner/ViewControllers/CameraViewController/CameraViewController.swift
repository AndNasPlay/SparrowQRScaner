//
//  CameraViewController.swift
//  SparrowQRScaner
//
//  Created by Андрей Щекатунов on 13.03.2022.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

	private(set) lazy var qrCodeButtonWidthAndHeightAnchor: CGFloat = 60.0

	var videoStream = AVCaptureVideoPreviewLayer()

	var session = AVCaptureSession()

	private(set) lazy var qrString: String = ""

	private(set) lazy var popVC = PopoverTableViewController()

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
		button.layer.cornerRadius = 60
		button.clipsToBounds = true
		button.backgroundColor = .separator
		button.setTitleColor(UIColor.yellowMain, for: .selected)
		button.setTitle("3", for: .normal)
		return button
	}()

	private(set) lazy var buttonsStackView: UIStackView = {
		let stack = UIStackView()
		stack.translatesAutoresizingMaskIntoConstraints = false
		stack.backgroundColor = .separator
		stack.layer.cornerRadius = 30
		stack.alignment = .center
		stack.axis = .horizontal
		stack.distribution = .fillProportionally
		return stack
	}()

	private(set) lazy var videoView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	private(set) lazy var scaleButtonView: UIView = {
		let view = UIView()
		return view
	}()

	private(set) lazy var qrCodeView: QRCodeView = {
		let view = QRCodeView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
		return view
	}()

	private(set) lazy var urlLable: UILabel = {
		let text = UILabel()
		text.translatesAutoresizingMaskIntoConstraints = false
		text.textColor = .darkText
		text.textAlignment = .center
		text.numberOfLines = 0
		text.font = UIFont.systemFont(ofSize: 18.0)
		text.text = "URL"
		text.sizeToFit()
		return text
	}()

	private(set) lazy var safaryLable: UILabel = {
		let text = UILabel()
		text.textColor = .darkText
		text.textAlignment = .center
		text.numberOfLines = 1
		text.font = UIFont.systemFont(ofSize: 20.0)
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

		self.qrCodeButton.isHidden = true
		self.qrCodeView.isHidden = true
		self.scaleButtonView.isHidden = true

		constraintsInit()
		setupGestures()
		setupStream()
	}

	private func addSubviews() {

		self.view.addSubview(videoView)
		self.view.addSubview(qrCodeButton)
		self.view.addSubview(qrCodeView)

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

		self.scaleButtonView.addSubview(buttonsStackView)

		self.view.addSubview(scaleButtonView)

		self.searchStackView.addArrangedSubview(safatiImg)
		self.searchStackView.addArrangedSubview(safaryLable)

		self.allQrItemsStackView.addArrangedSubview(searchStackView)
		self.allQrItemsStackView.addArrangedSubview(urlLable)

		self.view.addSubview(allQrItemsStackView)
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
		popoverVC?.sourceView = self.qrCodeButton
		popoverVC?.sourceRect = CGRect(x: self.qrCodeButton.bounds.minX,
									   y: self.qrCodeButton.bounds.minY,
									   width: 0,
									   height: 0)

		popVC.preferredContentSize = CGSize(width: 300.0, height: 50.0)

		self.present(popVC, animated: true)
	}

	func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
		guard metadataObjects.isEmpty == false else {
			self.qrCodeButton.isHidden = true
			self.qrCodeView.isHidden = true
			self.allQrItemsStackView.isHidden = true
			self.qrString = ""
			return

		}

		if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
			if object.type == AVMetadataObject.ObjectType.qr {
				self.qrCodeButton.isHidden = false
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

			videoView.topAnchor.constraint(equalTo: self.view.topAnchor),
			videoView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
			videoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			videoView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),

			qrCodeButton.heightAnchor.constraint(equalToConstant: qrCodeButtonWidthAndHeightAnchor),
			qrCodeButton.widthAnchor.constraint(equalToConstant: qrCodeButtonWidthAndHeightAnchor),
			qrCodeButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
												   constant: -30.0),
			qrCodeButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,
												 constant: -30.0),

			scaleButtonView.centerYAnchor.constraint(equalTo: self.qrCodeButton.centerYAnchor),
			scaleButtonView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			scaleButtonView.widthAnchor.constraint(equalToConstant: 300.0),
			scaleButtonView.heightAnchor.constraint(equalToConstant: qrCodeButtonWidthAndHeightAnchor)

		])
	}
}

extension CameraViewController: UIPopoverPresentationControllerDelegate {

	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		return .none
	}
}
