//
//  RecorderView.swift
//  Movilidad
//
//  Created by Diego Quimbo on 21/6/22.
//

import Foundation
import UIKit
import AVFoundation

protocol RecorderViewDelegate: AnyObject {
    func uploadAudioFile(audioPath: URL)
}

class RecorderView: NibLoadingView {
    // IBOutlets
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var helperLabel: UILabel!
    @IBOutlet weak var durationRecordLabel: UILabel!
    @IBOutlet weak var slideRecorder: UISlider!
    @IBOutlet weak var useAudioButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    // Private Properties
    private let vM: RecorderViewModel
    private var recordingSession = AVAudioSession.sharedInstance()
    private var audioRecorder: AVAudioRecorder!
    private var player: AVAudioPlayer!
    private var secondsRecordingTimer: Timer?
    private var updateSlideTimer: Timer?
    private var timerSecondsCounter = 60
    
    // Public Properties
    weak var delegate: RecorderViewDelegate?
    
    // MARK: - Lifecycle
    required init(codec: String, delegate: RecorderViewDelegate?) {
        vM = .init(codec: codec)
        
        super.init(frame: .zero)
        
        self.delegate = delegate
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        setupView()
        setupAudio()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - IBActions
    @IBAction func recordPressed(_ sender: Any) {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording()
        }
    }
    
    @IBAction func playAudioPressed(_ sender: Any) {
        if player == nil {
            do {
                player = try AVAudioPlayer(contentsOf: vM.audioPath)
                player.delegate = self
                player.prepareToPlay()
                
                slideRecorder.maximumValue = Float(player.duration)
                slideRecorder.value = 0.0
                slideRecorder.isHidden = false
                
                if updateSlideTimer == nil {
                    updateSlideTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimeInSlider), userInfo: nil, repeats: true)
                }
                
                player.play()
                playButton.setTitle(L10n.Audio.Recorder.pause, for: .normal)
                
            } catch {
                print("Error playing audio")
            }
        } else {
            if player.isPlaying {
                player.pause()
                
                playButton.setTitle(L10n.Audio.Recorder.play, for: .normal)
            } else {
                player.play()
                playButton.setTitle(L10n.Audio.Recorder.pause, for: .normal)
            }
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        stopRecordingTimer()
        stopUpdateTimeInSlider()
        
        removeFromSuperview()
    }
    
    @IBAction func useAudioRecordPressed(_ sender: Any) {
        delegate?.uploadAudioFile(audioPath: vM.audioPath)
        
        cancelPressed(sender)
    }
}

// MARK: - Private Functions
private extension RecorderView {
    func setupView() {
        durationRecordLabel.isHidden = true
        slideRecorder.isHidden = true
        playButton.isHidden = true
        useAudioButton.isHidden = true
    }
    
    func setupAudio() {
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { allowed in
                DispatchQueue.main.async {
                    if allowed {
                        // Allowed
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
    }
    
    func startRecording() {
        if player != nil {
            stopPlayingAudio()
        }
        
        let settings = vM.getAudioRecordSettings()

        do {
            audioRecorder = try AVAudioRecorder(url: vM.audioPath, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()

            recordButton.setImage(Asset.microphoneRed.image, for: .normal)
            helperLabel.text = L10n.Audio.Recorder.recording
            durationRecordLabel.isHidden = false
            playButton.isHidden = true
            useAudioButton.isHidden = true
            slideRecorder.isHidden = true
            
            startRecordingTimer()
        } catch {
            finishRecording()
        }
    }
    
    func finishRecording() {
        if audioRecorder != nil {
            audioRecorder.stop()
            audioRecorder = nil
        }

        recordButton.setImage(Asset.microphoneOrange.image, for: .normal)
        playButton.isHidden = false
        useAudioButton.isHidden = false
        durationRecordLabel.isHidden = true
        helperLabel.text = L10n.Audio.Recorder.Touch.Start.record
        timerSecondsCounter = 60
        durationRecordLabel.text = "\(Utilities.formatMinutesSeconds(value: self.timerSecondsCounter))"
        
        stopRecordingTimer()
    }
    
    func startRecordingTimer() {
        guard secondsRecordingTimer == nil else {
            return
        }
        secondsRecordingTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireRecordingTimer), userInfo: nil, repeats: true)
    }
    
    @objc func fireRecordingTimer() {
        if timerSecondsCounter <= 0 {
            finishRecording()
        } else {
            timerSecondsCounter -= 1
            durationRecordLabel.text = "\(Utilities.formatMinutesSeconds(value: self.timerSecondsCounter))"
        }
    }
    
    func stopRecordingTimer() {
        guard secondsRecordingTimer != nil else { return }
        secondsRecordingTimer?.invalidate()
        secondsRecordingTimer = nil
    }
    
    @objc func updateTimeInSlider() {
        slideRecorder.value = Float(player.currentTime)
    }
    
    func stopUpdateTimeInSlider() {
        guard updateSlideTimer != nil else { return }
        updateSlideTimer?.invalidate()
        updateSlideTimer = nil
    }
    
    func stopPlayingAudio() {
        stopUpdateTimeInSlider()
        slideRecorder.isHidden = true
        player.stop()
        player = nil
        playButton.setTitle(L10n.Audio.Recorder.play, for: .normal)
    }
}

extension RecorderView: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording()
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopPlayingAudio()
    }
}
