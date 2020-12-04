//
//  RoutinesViewController.swift
//  Venko
//
//  Created by Matias Glessi on 18/03/2020.
//  Copyright © 2020 Venko. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RoutinesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, OpenYoutubeVideoDelegate{

    @IBOutlet weak var routinesTableView: UITableView!
    @IBOutlet weak var userLabel: UILabel!
    
    var routines: [Routine] = []
    var dni = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        routinesTableView.delegate = self
        routinesTableView.dataSource = self
        routinesTableView.register(UINib(nibName: "RoutinesTableViewCell", bundle: nil), forCellReuseIdentifier: "RoutinesTableViewCell")
        
        getAlumno(for: dni) { name, error in
            if error {
                self.dismiss(animated: true, completion: nil)
            }
            else {
                self.userLabel.text = name
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    @IBAction func logout(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func getAlumno(for dni: String, completionHandler: @escaping (String, Bool) -> Void){
        Alamofire.request(APIConstants().BASE_URL + APIConstants().LOGIN + dni).responseJSON { response in
            
            if let value = response.result.value {
                let jsonFields = JSON(value)
                let jsonFieldsArray = jsonFields.arrayValue
                if let first = jsonFieldsArray.first, let name = first["fields"]["nombre"].string {
                    completionHandler(name, false)
                    return
                }
            }
            completionHandler("", true)

        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ConfigureTimerViewController") as! ConfigureTimerViewController
        controller.routineId = routines[indexPath.row].routineId
        self.present(controller, animated: true, completion: nil)
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = routinesTableView.dequeueReusableCell(withIdentifier: "RoutinesTableViewCell") as! RoutinesTableViewCell
        cell.routine = routines[indexPath.row]
        cell.youtubeDelegate = self
        return cell
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routines.count
    }

    
    func presentYoutubeVideo(with youtubeVideoId: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "YoutubeModalViewController") as! YoutubeModalViewController
        controller.youtubeVideoId = youtubeVideoId
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func unwindToViewControllerA(segue: UIStoryboardSegue) {}
}


protocol OpenYoutubeVideoDelegate: class {
    func presentYoutubeVideo(with youtubeVideoId: String)
}


