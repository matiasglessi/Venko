//
//  ExerciseCollectionViewCell.swift
//  Venko
//
//  Created by Matias Glessi on 18/03/2020.
//  Copyright © 2020 Venko. All rights reserved.
//

import UIKit
import SDWebImageWebPCoder
import Alamofire

class ExerciseCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource, SaveWeightsDelegate {
    
    
    @IBOutlet weak var openVideoButton: UIButton!
    @IBOutlet weak var newRowButton: UIButton!
    @IBOutlet weak var saveWeightsButton: UIButton!
    @IBOutlet weak var weightsTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var weightsTableView: UITableView!
    @IBOutlet weak var exerciseImage: UIImageView!
    
    var rows = 2
    var routineId = 0
    
    weak var youtubeDelegate: OpenYoutubeVideoDelegate?

    var exercise: Exercise? {
        didSet {
            setupExercise()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        exerciseImage.sd_imageTransition = .fade
        exerciseImage.sd_imageIndicator = SDWebImageActivityIndicator.white
        weightsTableView.delegate = self
        weightsTableView.dataSource = self
        weightsTableView.register(UINib(nibName: "WeightsTableViewCell", bundle: nil), forCellReuseIdentifier: "WeightsTableViewCell")
        weightsTableView.hide()
        saveWeightsButton.hide()
        newRowButton.hide()
    }
    
    fileprivate func configureVideoButton(_ exercise: Exercise) {
        if let youtubeId = exercise.youtubeUrl {
            youtubeId.isEmpty ? openVideoButton.hide() : openVideoButton.show()
        }
        else {
            openVideoButton.hide()
        }
    }

    
    private func setupExercise() {
        if let exercise = exercise {
            configureVideoButton(exercise)
            if let url = URL(string: APIConstants().BASE_URL + exercise.pictureUrl) {
                exerciseImage.sd_setImage(with: url)
            }
            rows = (exercise.weights.count == 0) ? 2 : exercise.weights.count
            weightsTableViewHeight.constant = getTableViewHeight()
            weightsTableView.reloadData()
        }
    }
    
    fileprivate func maxAvailableRows() -> Int {
        let screenHeight = UIScreen.main.bounds.height
        let totalAvailableHeight = (screenHeight - 30 * 3) / 40
        return Int(totalAvailableHeight)
    }
    
    
    fileprivate func getTableViewHeight() -> CGFloat {
        if rows <= maxAvailableRows() {
            return CGFloat(rows) * 40
        }
        return CGFloat(maxAvailableRows()) * 40
    }
    
    
    @IBAction func addNewRow(_ sender: Any) {
        rows+=1
        weightsTableViewHeight.constant = getTableViewHeight()
        weightsTableView.reloadData()
    }
    
    @IBAction func showWeights(_ sender: Any) {
        weightsTableView.toogleHide()
        saveWeightsButton.toogleHide()
        newRowButton.toogleHide()
    }
    
    @IBAction func saveCurrentWeights(_ sender: Any) {
        
        
        guard let exercise = exercise else { return }
        
        let weightsToGo = exercise.generateWeightsForServer()
        
        saveWeightsButton.isUserInteractionEnabled = false
        
        let parameters: [String:Any] = ["pesos": weightsToGo.weights,
                                        "repeticiones": weightsToGo.reps,
                                        "ejercicio_id": exercise.exerciseId,
                                        "rutina": routineId]
        
        do {
         let parametersStringified = try JSONStringify(value: parameters).stringify()

            Alamofire.request(APIConstants().BASE_URL +  APIConstants().SAVE_CURRENT_WEIGHTS, method: .post, parameters: [:], encoding: JSONStringArrayEncoding.init(string: parametersStringified), headers: [:]).responseJSON { (response) in
                print(response.result)
                self.saveWeightsButton.isUserInteractionEnabled = true
            }
        } catch let error { print(error) }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = weightsTableView.dequeueReusableCell(withIdentifier: "WeightsTableViewCell") as! WeightsTableViewCell
        cell.delegate = self
        cell.index = indexPath.row
        if let exercise = exercise {
            if indexPath.row < exercise.weights.count {
                let weight = exercise.weights[indexPath.row]
                cell.firstTextField.text = weight.first
                cell.secondTextField.text = weight.second
            }
            else {
                cell.firstTextField.text = ""
                cell.secondTextField.text = ""

            }
        }
        
        return cell
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows
    }

    func saveWeightsWithValues(_ first: String, _ second: String, for index: Int) {
        
        guard let exercise = exercise else { return }
        
        if index < exercise.weights.count {
            exercise.weights[index] = Weights(first: first, second: second)
        }
        else {
            exercise.weights.append(Weights(first: first, second: second))
        }
    }

    @IBAction func openVideo(_ sender: Any) {
        guard let exercise = exercise,
            let url = exercise.youtubeUrl else { return }

        youtubeDelegate?.presentYoutubeVideo(with: url)
    }
}


protocol SaveWeightsDelegate: class {
    func saveWeightsWithValues(_ first: String, _ second: String, for index: Int)
}
