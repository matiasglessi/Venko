//
//  YoutubeModalViewController.swift
//  Venko
//
//  Created by Matias Glessi on 23/03/2020.
//  Copyright © 2020 Venko. All rights reserved.
//

import UIKit
import YouTubePlayer

class YoutubeModalViewController: UIViewController {

    @IBOutlet weak var youtubePlayerView: YouTubePlayerView!
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet var backgroundView: UIView!
    var acceptAction: (() -> Void)?
    
    var youtubeVideoId: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAlertUI()
        youtubePlayerView.loadVideoID(youtubeVideoId)
        closeButton.round()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateIn()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private func animateIn() {
        self.modalView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        UIView.animate(withDuration: 0.4) {
            self.modalView.alpha = 1
            self.modalView.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func accept(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        acceptAction?()
    }
    
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func configureAlertUI() {
        modalView.round(to: 15)
        modalView.alpha = 0
    }
}
