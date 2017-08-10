//: [Previous](@previous)

import UIKit
import Foundation
import ReactiveSwift
import Result
import ReactiveCocoa
import XCPlayground
import PlaygroundSupport

class SimulatorViewController: UIViewController {
	
	let textField = UITextField()
	let button = UIButton(type: UIButtonType.roundedRect)
	var disposable: Disposable?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configure()
		//Defining consumer
		let observer: Signal<Bool, NoError>.Observer = Signal<Bool, NoError>.Observer(value: { value in
			self.button.isEnabled = value
		})
		
		//Defining source
		let signal = textField.reactive.continuousTextValues
		let transformedSignal = signal
			.skipNil()
			.map { text in
				text.characters.count > 10
		}
		
		//Consuming signal
		disposable = transformedSignal.observe(observer)
	}
	
	func configure() {
		view.addSubview(textField)
		view.addSubview(button)
		
		textField.frame = CGRect(x: 20, y: 100, width: 335, height: 100)
		button.frame = CGRect(x: 138, y: 300, width: 100, height: 50)
		textField.backgroundColor = UIColor.gray
		button.setTitle("Inactive", for: UIControlState.disabled)
		button.setTitle("Active", for: UIControlState.normal)
		button.isEnabled = false
	}
	
	func stopObserving() {
		//Limit Scope
		disposable?.dispose()
	}
}

let viewController = SimulatorViewController()
let currentView = viewController.view!
currentView.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
currentView.backgroundColor = UIColor.white

PlaygroundPage.current.liveView = currentView
PlaygroundPage.current.needsIndefiniteExecution = true
