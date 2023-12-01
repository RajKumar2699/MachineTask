//
//  LoginViewController.swift
//  MachineTask
//
//  Created by Arvind Rawat on 30/11/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().currentUser?.reload()
        
    }
    
    func isValidPassword(_ password: String) -> [String] {
        var missingConstraints: [String] = []
        
        let uppercaseLetters = CharacterSet.uppercaseLetters
        let lowercaseLetters = CharacterSet.lowercaseLetters
        let decimalDigits = CharacterSet.decimalDigits
        let specialCharacters = CharacterSet(charactersIn: "$@$!%*?&")
        
        if password.rangeOfCharacter(from: uppercaseLetters) == nil {
            missingConstraints.append("Uppercase letter")
        }
        
        if password.rangeOfCharacter(from: lowercaseLetters) == nil {
            missingConstraints.append("Lowercase letter")
        }
        
        if password.rangeOfCharacter(from: decimalDigits) == nil {
            missingConstraints.append("Digit")
        }
        
        if password.rangeOfCharacter(from: specialCharacters) == nil {
            missingConstraints.append("Special character")
        }
        
        if password.count < 8 {
            missingConstraints.append("Password is too short")
        }
        
        return missingConstraints
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    func alert(title : String , message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { action in
            alert.dismiss(animated: true)
        }
        alert.addAction(alertAction)
        self.present(alert, animated: true)
        
    }
    
    @IBAction func btnEye(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    @IBAction func loginBtnAction(_ sender: Any) {
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        if isValidEmail(username) {
            let missingConstraints = isValidPassword(password)
            
            if missingConstraints.isEmpty {
                Auth.auth().signIn(withEmail: username, password: password) { result, error in
                    if let error = error {
                        print(error.localizedDescription)
                        self.alert(title: Constants.Alert.title, message: "provided email or password is incorrect")
                    } else {
                        let storyboard = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.headlineVC) as! HeadLineVC
                        self.navigationController?.pushViewController(storyboard, animated: true)
                    }
                }
            } else {
                let missingConstraintsMessage = "\(missingConstraints.joined(separator: ", ")) is missing in password"
                alert(title: Constants.Alert.title, message: missingConstraintsMessage)
            }
        } else {
            alert(title: Constants.Alert.title, message: "Please Enter email address in correct format")
        }
    }
    
    
    @IBAction func googleSignInBtnAction(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            guard error == nil else {
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    let storyboard = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.headlineVC) as! HeadLineVC
                    self.navigationController?.pushViewController(storyboard, animated: true)
                }
            }
        }
    }
}
