//
//  CheckInVC.swift
//  woopsicredi
//
//  Created by Edwy Lugo on 04/05/19.
//

import UIKit

class CheckInVC: WSViewController {
    
    var scrollView: UIScrollView!
    var nameLabel,nameValidationLabel,emailLabel,emailValidationLabel: UILabel!
    var nameTextField: UITextField!
    var emailTextField: UITextField!
    var checkInButton: UIButton!
    var alertVC: AlertVC!
    var model: CheckInVM!
    var coordinator: EventsCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        viewSetup()
    }
    
    private func updateDetails() {
        coordinator.navigationController.viewControllers.forEach { (vc) in
            if vc is EventDetailVC {
                guard let vcDetails = vc as? EventDetailVC else { return }
                vcDetails.shouldUpdateDetails = true
            }
        }
    }
    
    private func sendCheckIn(name: String, email: String) {
        setupLoader()
        model.sendCheckIn(name: name, email: email) { [weak self] (error) in
            guard let weakSelf = self else { return }
            weakSelf.hideLoader()
            if error != nil {
                weakSelf.setupTryAgain(errorDesc: error?.errorDescription)
            } else {
                weakSelf.checkInSucceed()
            }
        }
    }
    
    private func setupTryAgain(errorDesc: String?) {
        alertVC = AlertVC()
        let cancelRetryBlock = { [ weak self ] in
            guard let weakSelf = self else { return }
            weakSelf.view.sendSubviewToBack(weakSelf.alertVC.view)
        }
        let content = GenericPopUpContent(imageName: model.errorIconName, color: WSColorPalette.fontColor, title: model.alertErrorTitle, desc: errorDesc ?? "Erro desconhecido", buttonTitle: model.alertcheckInTryAgainButtonTitle, cancelBlock: cancelRetryBlock) { [weak self] in
            guard let weakSelf = self, let name = weakSelf.nameTextField.text, let email = weakSelf.emailTextField.text else { return }
            weakSelf.view.sendSubviewToBack(weakSelf.alertVC.view)
            weakSelf.setupLoader()
            weakSelf.model.sendCheckIn(name: name, email: email, completion: { (error) in
                weakSelf.hideLoader()
                if error != nil {
                    weakSelf.setupTryAgain(errorDesc: error?.errorDescription)
                } else {
                    weakSelf.checkInSucceed()
                }
            })
        }
        alertVC.content = content
        guard let errorAlertView = alertVC.view else { return }
        addChild(alertVC)
        view.addSubview(errorAlertView)
    }
    
    private func checkInSucceed() {
        alertVC = AlertVC()
        let cancelRetryBlock = { [ weak self ] in
            guard let weakSelf = self else { return }
            weakSelf.updateDetails()
            weakSelf.view.sendSubviewToBack(weakSelf.alertVC.view)
            weakSelf.coordinator.navigationController.popViewController(animated: true)
        }
        let content = GenericPopUpContent(imageName: model.successIconName, color: WSColorPalette.fontColor, title: model.alertSuccessTitle, desc: model.alertSuccessDesc, buttonTitle: model.alertSuccessButtonTitle, cancelBlock: cancelRetryBlock) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.updateDetails()
            weakSelf.coordinator.navigationController.popViewController(animated: true)
        }
        alertVC.content = content
        guard let errorAlertView = alertVC.view else { return }
        addChild(alertVC)
        view.addSubview(errorAlertView)
    }
}

extension CheckInVC {
    //MARK: Validations
    private func validadeEntries() {
        guard let emailText = emailTextField.text, let nameText = nameTextField.text else { return }
        
        //Validate name
        if validadeName(name: nameText) == false {
            setStateValidationErrorFor(label: nameValidationLabel, validationErrorDescription: model.nameLabelErrorText)
            return
        } else {
            setStateValid(label: nameValidationLabel)
        }
        
        //Validade email
        
        if validadeEmail(email: emailText) == false {
            setStateValidationErrorFor(label: emailValidationLabel, validationErrorDescription: model.emailLabelErrorText)
            return
        } else {
            setStateValid(label: emailValidationLabel)
        }
        
        sendCheckIn(name: nameText, email: emailText)
    }
    
    private func validadeEmail(email: String ) -> Bool {
        if email.isEmpty || email.isValidEmail() == false {
            return false
        } else {
            return true
        }
    }
    
    private func validadeName(name: String ) -> Bool {
        return name.isEmpty ? false : true
    }
    
    private func setStateValidationErrorFor(label:UILabel, validationErrorDescription: String) {
        label.text = validationErrorDescription
    }
    
    private func setStateValid(label: UILabel) {
        label.text = model.emptyString
    }
}

extension CheckInVC {
    //MARK: Actions
    
    @objc func didTapCheckInButton() {
        validadeEntries()
    }
    
    @objc private func scrollViewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension CheckInVC {
    //MARK: VIEW CODE
    private func viewSetup() {
        //if it had more textfields we should use keyboard notifications to move scrollview content up.
        let maxContentWidth = view.frame.width - 32
        view.backgroundColor = UIColor.white
        title = model.title
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = WSFont.FontTypes.bold.font(withSize: 20)
        nameLabel.textColor = WSColorPalette.mediumGreen
        nameLabel.text = model.nameLabelText
        
        nameValidationLabel = UILabel()
        nameValidationLabel.translatesAutoresizingMaskIntoConstraints = false
        nameValidationLabel.font = WSFont.FontTypes.regular.font(withSize: 13)
        nameValidationLabel.textColor = WSColorPalette.errorRedColor
        nameValidationLabel.text = model.emptyString
        
        nameTextField = UITextField()
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.font = WSFont.FontTypes.regular.font(withSize: 16)
        nameTextField.textColor = WSColorPalette.fontColor
        nameTextField.borderStyle = .roundedRect
        nameTextField.tintColor = WSColorPalette.fontColor
        nameTextField.tag = 1
        nameTextField.delegate = self
        
        emailLabel = UILabel()
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.font = WSFont.FontTypes.bold.font(withSize: 20)
        emailLabel.textColor = WSColorPalette.mediumGreen
        emailLabel.text = model.emailLabelText
        
        emailValidationLabel = UILabel()
        emailValidationLabel.translatesAutoresizingMaskIntoConstraints = false
        emailValidationLabel.font = WSFont.FontTypes.regular.font(withSize: 13)
        emailValidationLabel.textColor = WSColorPalette.errorRedColor
        emailValidationLabel.text = model.emptyString
        
        emailTextField = UITextField()
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.font = WSFont.FontTypes.regular.font(withSize: 16)
        emailTextField.textColor = WSColorPalette.fontColor
        emailTextField.borderStyle = .roundedRect
        emailTextField.tintColor = WSColorPalette.fontColor
        emailTextField.delegate = self
        
        checkInButton = UIButton()
        checkInButton.translatesAutoresizingMaskIntoConstraints = false
        checkInButton.backgroundColor = WSColorPalette.darkGreen
        checkInButton.layer.cornerRadius = 3
        checkInButton.titleLabel?.font = WSFont.FontTypes.regular.font(withSize: 16)
        checkInButton.setTitle(model.checkInButtonTitle, for: .normal)
        checkInButton.setTitleColor(UIColor.white, for: .normal)
        checkInButton.addTarget(self, action: #selector(didTapCheckInButton), for: .touchUpInside)
        
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(nameValidationLabel)
        scrollView.addSubview(nameTextField)
        scrollView.addSubview(emailLabel)
        scrollView.addSubview(emailValidationLabel)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(checkInButton)
        
        let views : [String:UIView] = ["nameLabel": nameLabel,
                                       "nameValidationLabel":nameValidationLabel,
                                       "nameTextField":nameTextField,
                                       "emailLabel":emailLabel,
                                       "emailValidationLabel":emailValidationLabel,
                                       "emailTextField":emailTextField,
                                       "checkInButton":checkInButton]
        
        var allConstraints: [NSLayoutConstraint] = []
        allConstraints += "V:|-32-[nameLabel]-4-[nameTextField]-4-[nameValidationLabel(14)]-8-[emailLabel]-4-[emailTextField]-4-[emailValidationLabel(14)]-24-[checkInButton(50)]-32-|".toConstraints(withViews: views)
        allConstraints += "|-16-[nameLabel(\(maxContentWidth))]-16-|".toConstraints(withViews: views)
        allConstraints += "|-16-[nameTextField]-16-|".toConstraints(withViews: views)
        allConstraints += "|-16-[nameValidationLabel]-16-|".toConstraints(withViews: views)
        allConstraints += "|-16-[emailLabel]-16-|".toConstraints(withViews: views)
        allConstraints += "|-16-[emailTextField]-16-|".toConstraints(withViews: views)
        allConstraints += "|-16-[emailValidationLabel]-16-|".toConstraints(withViews: views)
        allConstraints += "|-16-[checkInButton]-16-|".toConstraints(withViews: views)
        
        NSLayoutConstraint.activate(allConstraints)
        
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor.white
        let scrollViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped(_:)))
        scrollViewTapGestureRecognizer.numberOfTapsRequired = 1
        scrollViewTapGestureRecognizer.isEnabled = true
        scrollViewTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(scrollViewTapGestureRecognizer)
        
        view.addSubview(scrollView)
        
        let views : [String:UIView] = ["scrollView":scrollView]
        
        var allConstraints: [NSLayoutConstraint] = []
        allConstraints += "V:|[scrollView]|".toConstraints(withViews: views)
        allConstraints += "|[scrollView]|".toConstraints(withViews: views)
        
        NSLayoutConstraint.activate(allConstraints)
    }
}

extension CheckInVC : UITextFieldDelegate {
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 1:
            emailTextField.becomeFirstResponder()
            break
        default:
            view.endEditing(true)
        }
        return true
    }
}
