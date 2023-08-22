//
//  FirstOperation.swift
//  Pr2503
//
//  Created by Роман Глухарев on 21/08/2023.
//

import Foundation
import UIKit

class FirstOperation: Operation {
    
    var passwordToUnlock: String = ""
    var delegate: ShowPasswordProtocol?
    
    init (passwordToUnlock: String) {
        self.passwordToUnlock = passwordToUnlock
    }
    
    func bruteForce() {
        let allowed_characters: [String] = String().printable.map { String($0) }
        var password: String = ""
        
        while password != passwordToUnlock {
            password = generateBruteForce(password, fromArray: allowed_characters)
            
            DispatchQueue.main.async {
                self.delegate?.showPasswordLabel(password)
            }
            if self.isCancelled {
                DispatchQueue.main.sync {
                    self.delegate?.cancelHacking()
                }
                return
            }
        }
        DispatchQueue.main.sync {
            self.delegate?.successHacking()
        }
    }
    
    override func main() {
        guard !isCancelled else { return }
        bruteForce()
    }
}

