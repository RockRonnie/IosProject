//
//  RegisterValidation.swift
//  StrawberryPie
//
//  Created by Markus Saronsao on 06/12/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import UIKit

struct RegisterValidation {
  // Validate email
  static func validateEmail(emailID: String) -> Bool {
    // Letters, Numbers, Needs valid email structure, 2-64 characters
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let trimmedString = emailID.trimmingCharacters(in: .whitespaces)
    let validateEmail = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    let isValidateEmail = validateEmail.evaluate(with: trimmedString)
    return isValidateEmail
  }
  // Validate password
  static func validatePassword(passwordID: String) -> Bool {
    // letters, numbers, 3-15 characters
    let passwordRegEx = "[A-Z0-9a-z]{3,15}"
    let trimmedString = passwordID.trimmingCharacters(in: .whitespaces)
    let validatePw = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
    let isValidPw = validatePw.evaluate(with: trimmedString)
    return isValidPw
  }
  static func validateUsername(user: String) -> Bool {
    // letters, numbers, 3-15 characters
    let usernameRegEx = "[A-Z0-9a-z]{3,15}"
    let trimmedString = user.trimmingCharacters(in: .whitespaces)
    let validatePw = NSPredicate(format:"SELF MATCHES %@", usernameRegEx)
    let isValidUsername = validatePw.evaluate(with: trimmedString)
    return isValidUsername
  }
}
