//
//  ViewController.swift
//  VK_GB_ClientServer
//
//  Created by Polina Tikhomirova on 16.12.2021.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var subview = UIView()
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        performCirclesAnimation() {
            self.perform(
                #selector(self.login),
                with: nil,
                afterDelay: 3.0)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWasShown),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillBeHidden(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    @objc func keyboardWasShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(
            forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue)
            .cgRectValue
            .size
        let contentInsets = UIEdgeInsets(
                            top: 0.0,
                            left: 0.0,
                            bottom: kbSize.height,
                            right: 0.0)
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        UIView.animate(withDuration: 1) {
            self.scrollView.constraints
                .first(where: { $0.identifier == "keyboardShown" })?
                .priority = .required
            self.scrollView.constraints
                .first(where: { $0.identifier == "keyboardHide" })?
                .priority = .defaultHigh
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        UIView.animate(withDuration: 1) {
            self.scrollView.constraints
                .first(where: { $0.identifier == "keyboardShown" })?
                .priority = .defaultHigh
            self.scrollView.constraints
                .first(where: { $0.identifier == "keyboardHide" })?
                .priority = .required
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }
    
    @objc func login() {
        if !checkUser() {
            presentAlert()
        } else {
            clearData()
            performSegue(
                withIdentifier: "goToMain",
                sender: nil)
        }
    }
    
    private func checkUser() -> Bool {
        usernameTextField.text == "" &&
        passwordTextField.text == ""
    }
    
    private func setup() {
        subview.center.x = view.center.x - 50
        subview.center.y = 500.0
        view.addSubview(subview)
        scrollView.addGestureRecognizer(
                UITapGestureRecognizer(
                    target: self,
                    action: #selector(hideKeyboard)))
    }
    
    private func presentAlert() {
        let alertController = UIAlertController(
            title: "Error",
            message: "Incorrect username or password",
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: "Close",
            style: .cancel)
        alertController.addAction(action)
        present(
            alertController,
            animated: true)
    }
    
    private func clearData() {
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    
    private func performCirclesAnimation(
        _ completion: @escaping ()->()
    ) {
        
        CATransaction.begin()
        let circle1 = drawCircle(
                    x: view.frame.width / 2 - 14,
                    y: 550)
        let circle2 = drawCircle(
                    x: view.frame.width / 2 - 3.5,
                    y: 550)
        let circle3 = drawCircle(
                    x: view.frame.width / 2 + 7,
                    y: 550)
            
        view.layer.addSublayer(circle1)
        view.layer.addSublayer(circle2)
        view.layer.addSublayer(circle3)
        
        animateCircle(
            object: circle1,
            delay: 0)
        animateCircle(
            object: circle2,
            delay: 0.33)
        animateCircle(
            object: circle3,
            delay: 0.66)
        
        func drawCircle(
            x: CGFloat,
            y: CGFloat
        ) -> CAShapeLayer {
            let circleLayer = CAShapeLayer()
            circleLayer.backgroundColor = UIColor.systemBlue.cgColor
            circleLayer.frame = CGRect(
                                    x: x,
                                    y: y,
                                    width: 7.0,
                                    height: 7.0)
            circleLayer.cornerRadius = 3.5
            circleLayer.opacity = 0
            
            return circleLayer
        }
        
        func animateCircle(
            object: CALayer,
            delay: CGFloat
        ) {
            let animation = CABasicAnimation(
                            keyPath: #keyPath(CALayer.opacity))
            animation.beginTime = CACurrentMediaTime() + delay
            animation.fromValue = 1
            animation.toValue = 0.2
            animation.duration = 1
            animation.repeatCount = 3
         
            object.add(
                animation,
                forKey: nil)
        }
        
        CATransaction.setCompletionBlock {
                completion()
            }
        
        CATransaction.commit()
    }
}



