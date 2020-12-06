//
//  WeightsTableViewCell.swift
//  Venko
//
//  Created by Matias Glessi on 20/03/2020.
//  Copyright © 2020 Venko. All rights reserved.
//

import UIKit

class WeightsTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    
    weak var delegate: SaveWeightsDelegate?
    var index: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        firstTextField.delegate = self
        secondTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {        
        let newString = textField.text ?? ""
        
        if textField.tag == 0 {
            let secondText = secondTextField.text
            delegate?.saveWeightsWithValues(newString, secondText ?? "", for: index)
        }
        else {
            let firstText = firstTextField.text
            delegate?.saveWeightsWithValues(firstText ?? "", newString, for: index)
        }
    }
    
    
    
    
}
