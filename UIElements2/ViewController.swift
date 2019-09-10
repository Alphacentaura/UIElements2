//
//  ViewController.swift
//  UIElements2
//
//  Created by Евгений Полянский on 09.09.2019.
//  Copyright © 2019 Евгений Полянский. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var stepper: UIStepper! {
        didSet {
            stepper.value = 17
            stepper.minimumValue = 10
            stepper.maximumValue = 25
            stepper.tintColor = .white
            stepper.backgroundColor = .gray
            stepper.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.layer.cornerRadius = 10
        textView.backgroundColor = view.backgroundColor
        textView.delegate = self
        
        textView.isHidden = true
        //textView.alpha = 0
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        // Activiti indicator
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
//        UIView.animate(withDuration: 1, delay: 2, options: .curveEaseInOut, animations: {
//            self.textView.alpha = 1
//        }) { (finished) in
//            self.activityIndicator.startAnimating()
//            self.textView.isHidden = false
//            UIApplication.shared.endIgnoringInteractionEvents()
//        }
        
        // Progress
        progressView.setProgress(0, animated: true)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.progressView.progress != 1 {
                self.progressView.progress += 0.2
            } else {
                self.activityIndicator.startAnimating()
                self.textView.isHidden = false
                UIApplication.shared.endIgnoringInteractionEvents()
                self.progressView.isHidden = true
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height-bottomConstraint.constant, right: 0)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        textView.contentInset = UIEdgeInsets.zero
    }
    
    @IBAction func sizeFontChange(_ sender: UIStepper) {
        let font = textView.font?.fontName
        let fontSize = CGFloat(sender.value)
        textView.font = UIFont(name: font!, size: fontSize)
    }
    
}

extension ViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.backgroundColor = .white
        textView.textColor = .gray
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.backgroundColor = self.view.backgroundColor
        textView.textColor = .black
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        label.text = "\(textView.text.count)"
        return textView.text.count + (text.count - range.length) <= 60
    }
}
