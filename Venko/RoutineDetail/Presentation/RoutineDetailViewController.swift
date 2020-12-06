//
//  RoutineDetailViewController.swift
//  Venko
//
//  Created by Matias Glessi on 18/03/2020.
//  Copyright © 2020 Venko. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation

enum ExerciseStatus {
    case workout
    case rest
    case restLimit
    case timelessWorkout
    case finalized
}


class RoutineDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, OpenYoutubeVideoDelegate {

    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var prepareView: UIView!
    @IBOutlet weak var restView: UIView!
    @IBOutlet weak var countdownView: UIView!
    @IBOutlet weak var finalizedView: ConfettiView!
    @IBOutlet weak var countdownTimerLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var exercisesCollectionView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var weightsTableView: UITableView!

    var timerConfiguration = TimerConfiguration()
    
    var viewModel: RoutineDetailViewModel!
        
    var exercises = [Exercise]()
    var routineId = 0
    var timer: Timer?
    var current = 0
    var workoutRounds = 0
    var restRounds = 0
    
    var status: ExerciseStatus = .restLimit
    var previousIndexPath = IndexPath(row: 0, section: 0)

    var player: AVAudioPlayer?
    var countdownPlayer: AVAudioPlayer?
    var clappingPlayer: AVAudioPlayer?
    
    var isSoundOn = true
    
    
    deinit {
        UIApplication.shared.isIdleTimerDisabled = false
        player?.stop()
        countdownPlayer?.stop()
        do {
            
            try AVAudioSession.sharedInstance()
                .setActive(false, options: .notifyOthersOnDeactivation)
        }
        catch {
            print(error)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playBellSound()
        prepareCountdownPlayer(for: .workout)
        countdownTimerLabel.hide()
        configureScreen(for: self.timerConfiguration.isEnabled ? .restLimit : .timelessWorkout)
        exercisesCollectionView.delegate = self
        exercisesCollectionView.dataSource = self
        exercisesCollectionView.register(UINib(nibName: "ExerciseCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ExerciseCollectionViewCell")
        
        UIApplication.shared.isIdleTimerDisabled = true

        
        viewModel.getExercises(for: routineId) { [weak self] (exercises, error) in
            
            guard let strongSelf = self else { return }
            
            if error {
                strongSelf.dismiss(animated: true, completion: nil)
            }
            else {
                strongSelf.exercises = exercises
                strongSelf.workoutRounds = strongSelf.exercises.count
                strongSelf.restRounds = strongSelf.exercises.count - 1
                strongSelf.exercisesCollectionView.reloadData()
                if strongSelf.timerConfiguration.isEnabled { strongSelf.startCountdownTimer() }
            }
        }

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }

    
    private func configureScreen(for status: ExerciseStatus) {
        self.status = status
        switch status {
            
        case .workout:
            prepareView.hide()
            restView.hide()
            countdownView.hide()
            timerLabel.show()
            finalizedView.hide()
        case .rest:
            prepareView.show()
            restView.show()
            countdownView.hide()
            timerLabel.show()
            finalizedView.hide()
        case .restLimit:
            countdownTimerLabel.show()
            prepareView.show()
            restView.hide()
            countdownView.show()
            timerLabel.hide()
            finalizedView.hide()
        case .finalized:
            countdownTimerLabel.hide()
            restView.hide()
            prepareView.show()
            countdownView.hide()
            timerLabel.hide()
            finalizedView.show()
            finalizedView.start()
        case .timelessWorkout:
            buttonsStackView.hide()
            prepareView.hide()
            restView.hide()
            countdownView.hide()
            timerLabel.hide()
            finalizedView.hide()
        }
    }
        
    
    private func startCountdownTimer() {
        current = 3
        configureScreen(for: .restLimit)
        countdownTimerLabel.text = "\(current)"
        playCountdownSound()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdownTimer), userInfo: nil, repeats: true)
    }

    
    private func startWorkoutTimer() {
        workoutRounds = workoutRounds - 1
        current = timerConfiguration.workout
        timerLabel.text = current.toTimerString
        configureScreen(for: .workout)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateWorkoutTimer), userInfo: nil, repeats: true)

    }

    private func startRestTimer() {
        restRounds = restRounds - 1
        current = timerConfiguration.rest
        timerLabel.text = current.toTimerString
        configureScreen(for: .rest)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateRestTimer), userInfo: nil, repeats: true)
    }

    @objc private func updateCountdownTimer() {
        if current == 0 {
            playBellSound()
            stopTimer()
            if timerConfiguration.isEnabled {
                startWorkoutTimer()
            }
            else {
                configureScreen(for: .timelessWorkout)
            }
        }
        else {
            updateTimer()
        }
    }
    
    fileprivate func updateTimer() {
        current = current - 1
        timerLabel.text = current.toTimerString
        countdownTimerLabel.text = "\(current)"

    }
    
    @objc private func updateWorkoutTimer() {
        if current == 0 {
            playBellSound()
            stopTimer()
            if workoutRounds == 0 {
                configureScreen(for: .finalized)
                showEndOfExerciseAlert()
                stopTimer()
            }
            else {
                startRestTimer()
                scrollToNextExercise()
            }
        }
        else if current == 5 {
            prepareCountdownPlayer(for: .rest)
            updateTimer()

        } else if current == 3 {
            playCountdownSound()
            updateTimer()
            
        } else {
            updateTimer()
        }
    }

    @objc private func updateRestTimer() {
        if current == 0 {
            playBellSound()
            stopTimer()
            startWorkoutTimer()
        }
        else if current == 6 {
            prepareCountdownPlayer(for: .workout)
            updateTimer()

        }
        else if current == 4 {
            configureScreen(for: .restLimit)
            updateTimer()
            playCountdownSound()
        }

        else {
            updateTimer()
        }
    }

    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    
    fileprivate func getCurrentCollectionIndexPath() -> IndexPath? {
        var visibleRect = CGRect()

        visibleRect.origin = exercisesCollectionView.contentOffset
        visibleRect.size = exercisesCollectionView.bounds.size

        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        guard let indexPath = exercisesCollectionView.indexPathForItem(at: visiblePoint) else { return nil }

        return indexPath
    }
    
    @IBAction func pauseTimer(_ sender: Any) {
        
        guard let unwrappedTimer = timer else { return }
        
        if unwrappedTimer.isValid {
            unwrappedTimer.invalidate()
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
        }
        else {
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            switch status {
            case .workout:
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateWorkoutTimer), userInfo: nil, repeats: true)
            case .rest:
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateRestTimer), userInfo: nil, repeats: true)
            case .restLimit:
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdownTimer), userInfo: nil, repeats: true)
            default: break
            }
        }
        
    }
   
    
    @IBAction func soundOnOff(_ sender: Any) {
        soundOnOff()
    }
    
    
    @IBAction func omitBreak(_ sender: Any) {
        if let currentIndex = getCurrentCollectionIndexPath() {
            resetWorkout(for: currentIndex.row)
        }
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.performSegue(withIdentifier: "backToRoutines", sender: self)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExerciseCollectionViewCell", for: indexPath) as! ExerciseCollectionViewCell
        cell.routineId = routineId
        cell.youtubeDelegate = self
        cell.exercise = exercises[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UIScreen.main.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func presentYoutubeVideo(with youtubeVideoId: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "YoutubeModalViewController") as! YoutubeModalViewController
        controller.youtubeVideoId = youtubeVideoId
        self.present(controller, animated: true, completion: nil)
    }


    
    
    private func resetTraining(){
        countdownTimerLabel.hide()
        finalizedView.stop()
        configureScreen(for: .restLimit)
        self.workoutRounds = self.exercises.count
        self.restRounds = self.exercises.count - 1
        self.exercisesCollectionView.reloadData()
        self.startCountdownTimer()
        let indexPath = IndexPath(row: 0, section: 0)
        self.exercisesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

    }
    
    fileprivate func prepareForNewTraining() {
        self.prepareCountdownPlayer(for: .workout, completion: {
            DispatchQueue.main.async {
                self.resetTraining()
            }
        })
    }
    
    private func showEndOfExerciseAlert() {
        playClappingSound()
        let alertController = UIAlertController(title: "Felicitaciones!", message: "Bien ahí! Terminaste el entrenamiento. Querés repetir una vuelta más o terminar?", preferredStyle: .alert)
        let endAction = UIAlertAction.init(title: "Repetir", style: .default, handler: { [weak self] (_) in
            self?.prepareForNewTraining()

        })
        let repeatAction = UIAlertAction.init(title: "Terminar", style: .default, handler: { [weak self] (_) in
            
            self?.finalizedView.stop()
            self?.performSegue(withIdentifier: "backToRoutines", sender: self)
        })

        alertController.addAction(repeatAction)
        alertController.addAction(endAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension RoutineDetailViewController {
    
    private func scrollToNextExercise() {
        if let currentIndexPath = getCurrentCollectionIndexPath() {
            let indexPath = IndexPath(row: currentIndexPath.row + 1, section: 0)
            self.exercisesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    private func resetWorkout(for row: Int) {
        stopTimer()
        workoutRounds = exercises.count - row - 1
        restRounds = exercises.count - row - 2
        current = timerConfiguration.workout
        timerLabel.text = current.toTimerString
        configureScreen(for: .workout)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateWorkoutTimer), userInfo: nil, repeats: true)
    }
    
    private func resetRounds(for row: Int) {
        workoutRounds = exercises.count - row - 1
        restRounds = exercises.count - row - 2
    }

    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if !timerConfiguration.isEnabled { return }
        guard let currentIndexPath = getCurrentCollectionIndexPath() else { return }
        previousIndexPath = currentIndexPath
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if !timerConfiguration.isEnabled { return }
        guard let currentIndexPath = getCurrentCollectionIndexPath() else { return }
        
        if !previousIndexPath.hasSamePosition(as: currentIndexPath) {
            resetWorkout(for: currentIndexPath.row)
        }
        else {
            resetRounds(for: currentIndexPath.row)
        }
    }
}

// MARK: SingleRoutine Sounds Management

extension RoutineDetailViewController: AVAudioPlayerDelegate {
    
    func playSound(){
        guard let _ = timerConfiguration.bellSound else { return }
        player?.play()
    }
    
    func playCountdownSound(){
        guard let _ = timerConfiguration.countdownSound else { return }
        countdownPlayer?.play()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        do {
            
            try AVAudioSession.sharedInstance()
                .setActive(false, options: .notifyOthersOnDeactivation)
        }
        catch {
            print(error)
        }
    }
    
    private func playBellSound() {
        
        guard let bellSound = timerConfiguration.bellSound, let url = Bundle.main.url(forResource: bellSound.fileName, withExtension: bellSound.fileExtension) else { return }
        do {
            
            try AVAudioSession.sharedInstance()
                .setCategory(AVAudioSession.Category.playback, options: .duckOthers)
            try AVAudioSession.sharedInstance()
                .setActive(true, options: .notifyOthersOnDeactivation)


            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            player?.delegate = self
            player?.prepareToPlay()
            playSound()
        }
        catch {
            print(error)
        }
        
        player?.volume = 0.5
    }
    
    private func prepareCountdownPlayer(for status: ExerciseStatus, completion: (() -> ())? = nil) {
        DispatchQueue.global(qos: .userInteractive).async {
            
            guard let countdownSound = self.timerConfiguration.countdownSound else { return }
            let randomSound = status == .workout ? countdownSound.workoutSounds.randomElement() : countdownSound.restSounds.randomElement()
            
            guard let sound = randomSound, let url = Bundle.main.url(forResource: sound.fileName, withExtension: sound.fileExtension) else { return }
            do {
                try AVAudioSession.sharedInstance()
                    .setCategory(AVAudioSession.Category.playback, options: .duckOthers)
                try AVAudioSession.sharedInstance()
                    .setActive(true, options: .notifyOthersOnDeactivation)
                
                self.countdownPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                self.countdownPlayer?.delegate = self
                self.countdownPlayer?.prepareToPlay()
                completion?()
            }
            catch {
                print(error)
            }
            
            self.countdownPlayer?.volume = 1

        }
    }
    
    private func playClappingSound() {
        
        let clappingSound = Sound(showableName: "Long Clapping", fileName: "aplausos-largo", fileExtension: "mp3")
        
        guard let url = Bundle.main.url(forResource: clappingSound.fileName, withExtension: clappingSound.fileExtension) else { return }
        do {
            
            try AVAudioSession.sharedInstance()
                .setCategory(AVAudioSession.Category.playback, options: .duckOthers)
            try AVAudioSession.sharedInstance()
                .setActive(true, options: .notifyOthersOnDeactivation)


            clappingPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            clappingPlayer?.delegate = self
            clappingPlayer?.prepareToPlay()
            clappingPlayer?.play()
        }
        catch {
            print(error)
        }
        
        clappingPlayer?.volume = 0.4
    }
    
    fileprivate func soundOnOff() {
        if isSoundOn {
            isSoundOn = false
            soundButton.setImage(UIImage(named: "soundOff"), for: .normal)
            player?.volume = 0.0
            countdownPlayer?.volume = 0.0
            clappingPlayer?.volume = 0.0
        }
        else {
            isSoundOn = true
            soundButton.setImage(UIImage(named: "soundOn"), for: .normal)
            player?.volume = 0.5
            countdownPlayer?.volume = 1
            clappingPlayer?.volume = 0.4
        }
    }

}

// MARK: SingleRoutine Extensions


extension IndexPath {
    
    fileprivate func hasSamePosition(as index: IndexPath) -> Bool {
        return self.row == index.row
    }
}

extension Int {
    fileprivate var toTimerString: String {
        let m = (self % 3600) / 60
        let s = (self % 3600) % 60
        return String(format: "%02d:%02d", m, s)
    }
}

