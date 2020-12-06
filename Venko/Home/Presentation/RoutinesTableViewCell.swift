//
//  RoutinesTableViewCell.swift
//  Venko
//
//  Created by Matias Glessi on 18/03/2020.
//  Copyright © 2020 Venko. All rights reserved.
//

import UIKit
import SDWebImage
import SDWebImageWebPCoder

class RoutinesTableViewCell: UITableViewCell {

    @IBOutlet weak var openVideoButton: UIButton!
    @IBOutlet weak var attendanceLabel: UILabel!
    @IBOutlet weak var routineTitleLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    weak var youtubeDelegate: OpenYoutubeVideoDelegate?
    

    var routine: Routine? {
        didSet {
            setupRoutine()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundImage.sd_imageTransition = .fade
        backgroundImage.sd_imageIndicator = SDWebImageActivityIndicator.gray

    }

    fileprivate func configureVideoButton(_ routine: Routine) {
        if let youtubeId = routine.youtubeUrl {
            youtubeId.isEmpty ? openVideoButton.hide() : openVideoButton.show()
        }
        else {
            openVideoButton.hide()
        }
    }
    
    private func setupRoutine() {
        if let routine = routine {
            attendanceLabel.text = "Asistencia: \(routine.ocurrences)"
            routineTitleLabel.text = routine.name
            configureVideoButton(routine)
            if let url = URL(string: APIConstants().BASE_URL + routine.pictureUrl), !routine.pictureUrl.isEmpty {
                backgroundImage.sd_setImage(with: url)
            } else {
                backgroundImage.sd_imageIndicator?.stopAnimatingIndicator()
            }
        }
    }
    
    @IBAction func openVideo(_ sender: Any) {
        
        guard let routine = routine,
            let url = routine.youtubeUrl else { return }

        youtubeDelegate?.presentYoutubeVideo(with: url)
    }
}
