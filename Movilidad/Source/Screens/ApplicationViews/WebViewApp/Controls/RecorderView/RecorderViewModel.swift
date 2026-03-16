//
//  RecorderViewModel.swift
//  Movilidad
//
//  Created by Diego Quimbo on 21/6/22.
//

import Foundation
import AVFoundation

enum Codec: String {
    case AAC = "aac"
    case PCM = "pcm"
}

final class RecorderViewModel {
        
    // Private Vars
    private var codec: Codec
    
    private var audioPathM4a: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("recordingM4.m4a")
    }
    
    private var audioPathWav: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("recordingWa.wav")
    }
    
    // Public Vars
    var audioPath: URL {
        switch codec {
        case .AAC:
            return audioPathM4a
        case .PCM:
            return audioPathWav
        }
    }
    
    // MARK: - Init
    init(codec: String) {
        // CODEC could be AAC or PCM
        self.codec = Codec(rawValue: codec) ?? .AAC
    }
    
    // MARK: - Public Functions
    func getAudioRecordSettings() -> [String : Any] {
        switch codec {
        case .AAC:
            return configAudioRecordInAACFormat()
        case .PCM:
            return configAudioRecordInPCMFormat()
        }
    }
}

private extension RecorderViewModel {
    func configAudioRecordInAACFormat() -> [String : Any] {
        // PCM settings
        return [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 16000.0,
            AVNumberOfChannelsKey: 1
        ] as [String : Any]
    }
    
    func configAudioRecordInPCMFormat() -> [String : Any] {
        // PCM settings
        return [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVLinearPCMIsBigEndianKey: false,
            AVLinearPCMIsFloatKey: false,
            AVSampleRateKey: 16000.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ] as [String : Any]
    }
}
