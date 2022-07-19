//
//  FileViewContoller+KeychainService.swift
//  FileManager
//
//  Created by Alex on 20.07.22.
//

import Foundation
import UIKit

extension FilesViewController {
    private func showEnterPasswordAllert() {
        let alertController = UIAlertController(title: "Locked!",
                                                message: "Please, enter your password to get access",
                                                preferredStyle: .alert)
        
        alertController.addTextField {
            $0.placeholder = "Password"
            $0.isSecureTextEntry = true
        }
        
        let addAction = UIAlertAction(title: "Enter",
                                      style: .default,
                                      handler: { [weak self] _ in
            if let textFieldText = alertController.textFields?.first?.text {
                self?.checkPassword(enteredPassword: textFieldText)
            }
            else {
                self?.showEnterPasswordAllert()
            }
        })
        
        alertController.addAction(addAction)
        
        present(alertController, animated: true)
    }
    
    private func showAddPasswordAllert() {
        let alertController = UIAlertController(title: "Create a password",
                                                message: "Please create a password",
                                                preferredStyle: .alert)
        
        alertController.addTextField {
            $0.placeholder = "New password"
            $0.isSecureTextEntry = false
        }
        
        let addAction = UIAlertAction(title: "Add",
                                      style: .default,
                                      handler: { [weak self] _ in
            if let textFieldText = alertController.textFields?.first?.text {
                self?.addPasswordToKeyChain(password: textFieldText)
                self?.checkStatusOfVerification()
            }
            else {
                self?.showAddPasswordAllert()
            }
        })
        
        alertController.addAction(addAction)
        
        present(alertController, animated: true)
    }
    
    private func checkPassword() {
        if KeychainService.shared.getPassword() != nil {
            self.showEnterPasswordAllert()
        }
        else {
            self.showAddPasswordAllert()
        }
    }
    
    private func addPasswordToKeyChain(password: String) {
        KeychainService.shared.setPassword(value: password)
    }
    
    private func checkPassword(enteredPassword: String) {
        let savedPassword = KeychainService.shared.getPassword()
        
        if enteredPassword == savedPassword {
            self.verificationStatus = true
        }
        else {
            self.showWrongPasswordAlert()
        }
    }
    
    func checkStatusOfVerification() {
        if self.verificationStatus == false {
            checkPassword()
        }
    }
    
    private func showWrongPasswordAlert() {
        let alertController = UIAlertController(title: "Sorry!",
                                                message: "You type wrong password, try again!",
                                                preferredStyle: .alert)
        
        let tryAgainAction = UIAlertAction(title: "Try again",
                                           style: .default,
                                           handler: { [weak self] _ in
            self?.showEnterPasswordAllert()
        })
        
        alertController.addAction(tryAgainAction)
        
        present(alertController, animated: true)
    }
}

