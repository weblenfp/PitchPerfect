//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by W.b.e.n on 13/06/21.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    let recording_in_progress_text = "Recording in Progress", tap_to_record_text = "Tap to Record", recording_not_successful_text = "recording was not successful", segueStopRecording = "stopRecording", recordingName = "recordedVoice.wav", separator = "/"
    enum RecordingAction {case startRecording, stopRecording}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(for: .stopRecording)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        configureUI(for: .startRecording, with: recording_in_progress_text)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: separator))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(for: .startRecording, with: tap_to_record_text)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: segueStopRecording, sender: audioRecorder.url)
        } else {
            print(recording_not_successful_text)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueStopRecording {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    func configureUI(for recordingAction: RecordingAction, with labelText: String? = nil) {
        switch recordingAction {
        case .startRecording:
            recordButton.isEnabled = false
            stopRecordingButton.isEnabled = true
        case .stopRecording:
            recordButton.isEnabled = true
            stopRecordingButton.isEnabled = false
        }
        
        if let labelText = labelText {
            recordingLabel.text = labelText
        }
    }
}

