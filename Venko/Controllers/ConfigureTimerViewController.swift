//
//  ConfigureTimerViewController.swift
//  Venko
//
//  Created by Matias Glessi on 12/04/2020.
//  Copyright © 2020 Venko. All rights reserved.
//

import UIKit
import AVFoundation


struct TimerConfiguration {
    var workout: Int
    var rest: Int
    var bellSound: Sound?
    var countdownSound: CountdownSound?
    var isEnabled: Bool
    
    
    init() {
        self.workout = 0
        self.rest = 0
        self.isEnabled = false
    }

    init(workout: Int, rest: Int, bellSound: Sound? = nil, isEnabled: Bool, countdownSound: CountdownSound? = nil) {
        self.workout = workout
        self.rest = rest
        self.bellSound = bellSound
        self.isEnabled = isEnabled
        self.countdownSound = countdownSound
    }
}

class ConfigureTimerViewController: UIViewController {

    @IBOutlet weak var selectorsView: UIView!
    @IBOutlet weak var soundTextField: UITextField!
    @IBOutlet weak var restTextField: UITextField!
    @IBOutlet weak var workoutTextField: UITextField!
    
    var routineId = 0
    var player: AVAudioPlayer?
    var sounds: [Sound] = [
        Sound(showableName: "Voz Hombre", fileName: "321empezamos-hombre", fileExtension: "mp3", isOnlyVoice: true),
        Sound(showableName: "Voz Mujer", fileName: "321empeza-mujer", fileExtension: "mp3", isOnlyVoice: true),
        Sound(showableName: "Campana 1", fileName: "campana1", fileExtension: "mp3"),
        Sound(showableName: "Campana 2", fileName: "campana2", fileExtension: "mp3"),
        Sound(showableName: "Correcaminos", fileName: "correcaminos", fileExtension: "mp3")
    ]
    
    let womanCountDownSound = CountdownSound(
        workoutSounds:
            [Sound(showableName: "Empeza Mujer", fileName: "321empeza-mujer", fileExtension: "mp3")],
        restSounds:
            [Sound(showableName: "Descansa Mujer", fileName: "321descansa-mujer", fileExtension: "mp3")])
    
    let menCountDownSound = CountdownSound(
        workoutSounds:
            [Sound(showableName: "Empezamos Hombre", fileName: "321empezamos-hombre", fileExtension: "mp3"),
            Sound(showableName: "Arrancamos Hombre", fileName: "321arrancamos-hombre", fileExtension: "mp3")],
        restSounds:
            [Sound(showableName: "Descansa Hombre", fileName: "321descansa-hombre", fileExtension: "mp3"),
            Sound(showableName: "Pausita Hombre", fileName: "321pausita-hombre", fileExtension: "mp3")])

    
    var secondsArray = (10...59).map{ String(withInt: $0) }
    var minutesArray = (0...30).map{ String(withInt: $0) }

    private let timePickerView = UIPickerView()
    private let soundPickerView = UIPickerView()

    var selectedSound: Sound?
    var selectedWorkoutSeconds = 30
    var selectedRestSeconds = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timePickerView.delegate = self
        timePickerView.dataSource = self
        soundPickerView.delegate = self
        soundPickerView.dataSource = self
        workoutTextField.inputView = timePickerView
        restTextField.inputView = timePickerView
        soundTextField.inputView = soundPickerView
        selectedSound = sounds[0]
        timePickerView.selectRow(20, inComponent: 2, animated: false)
    }
    
    deinit {
        player?.stop()
        do {
            try AVAudioSession.sharedInstance()
                .setActive(false, options: .notifyOthersOnDeactivation)
        }
        catch {
            print(error)
        }
    }
    
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func goToRoutineWithoutTimer(_ sender: Any) {
        goToRoutine(with: TimerConfiguration())
    }

    @IBAction func goToRoutineWithTimer(_ sender: Any) {
        
        var timerConfiguration: TimerConfiguration?
        
        if selectedSound?.showableName == "Voz Hombre" {
            timerConfiguration = TimerConfiguration(workout: selectedWorkoutSeconds, rest: selectedRestSeconds, isEnabled: true, countdownSound: menCountDownSound)

        } else if selectedSound?.showableName == "Voz Mujer" {
            timerConfiguration = TimerConfiguration(workout: selectedWorkoutSeconds, rest: selectedRestSeconds, isEnabled: true, countdownSound: womanCountDownSound)
        } else {
            timerConfiguration = TimerConfiguration(workout: selectedWorkoutSeconds, rest: selectedRestSeconds, bellSound: selectedSound, isEnabled: true)
        }
        goToRoutine(with: timerConfiguration!)
    }

    @IBAction func playSound(_ sender: Any) {
        configureSound(with: selectedSound)
    }

    private func goToRoutine(with timerConfiguration: TimerConfiguration) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SingleRoutineViewController") as! SingleRoutineViewController
        controller.routineId = routineId
        controller.timerConfiguration = timerConfiguration
        self.present(controller, animated: true, completion: nil)

    }
    
}

extension ConfigureTimerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        soundTextField.inputView == pickerView ? 1 : 4
    }
    
    fileprivate func getNumberOfTimeRows(_ component: Int) -> Int {
        switch component {
        case 0:
            return minutesArray.count
        case 1:
            return 1
        case 2:
            return secondsArray.count
        case 3:
            return 1
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        soundTextField.inputView == pickerView ? sounds.count : getNumberOfTimeRows(component)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if soundTextField.inputView == pickerView {
            soundTextField.text = sounds[row].showableName
            selectedSound = sounds[row]
            configureSound(with: selectedSound)
        }
        else {
            let minutes = minutesArray[pickerView.selectedRow(inComponent: 0)].replacingOccurrences(of: "\"", with: "")
            let seconds = secondsArray[pickerView.selectedRow(inComponent: 2)].replacingOccurrences(of: "\"", with: "")
                        
            if workoutTextField.isFirstResponder {
                workoutTextField.text = [minutes,seconds].joined(separator: ":")
                selectedWorkoutSeconds = (Int(minutes)! * 60) + Int(seconds)!
            }
            else {
                restTextField.text = [minutes,seconds].joined(separator: ":")
                selectedRestSeconds = (Int(minutes)! * 60) + Int(seconds)!


            }
        }
    }
    
    fileprivate func getTimeTitle(_ component: Int, _ row: Int) -> String? {
        switch component {
        case 0:
            return minutesArray[row]
        case 1:
            return "min"
        case 2:
            return secondsArray[row]
        case 3:
            return "sec"
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        soundTextField.inputView == pickerView ? sounds[row].showableName : getTimeTitle(component, row)
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        soundTextField.inputView == pickerView ? 200.0 : 80.0
    }

}

extension ConfigureTimerViewController: AVAudioPlayerDelegate {
    
    private func configureSound(with sound: Sound?) {
        
        guard let unwrappedSound = sound, let url = Bundle.main.url(forResource: unwrappedSound.fileName, withExtension: unwrappedSound.fileExtension) else { return }
        do {
                try AVAudioSession.sharedInstance()
                    .setCategory(AVAudioSession.Category.playback, options: .duckOthers)
                try AVAudioSession.sharedInstance()
                    .setActive(true, options: .notifyOthersOnDeactivation)

                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                player?.delegate = self
                player?.prepareToPlay()
                player?.play()
        }
        catch {
            print(error)
        }
        
        player?.volume = 0.7
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

}

extension String {
    init(withInt int: Int) {
        let leadingZeros = int < 10 ? 2 : 0
        self.init(format: "%0\(leadingZeros)d", int)
    }
}
