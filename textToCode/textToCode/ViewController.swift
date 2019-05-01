//
//  ViewController.swift
//  textToCode
//
//  Created by Michael Smith on 4/21/19.
//  Copyright © 2019 Michael Smith. All rights reserved.
//

import UIKit
import Speech

extension String {
    static func ~= (lhs: String, rhs: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: rhs) else { return false }
        let range = NSRange(location: 0, length: lhs.utf16.count)
        return regex.firstMatch(in: lhs, options: [], range: range) != nil
    }
}

class ViewController: UIViewController, SFSpeechRecognizerDelegate {
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var textOutput: UITextView!
    @IBOutlet weak var bestTranscriptionOutput: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordButton.isEnabled = false
        speechRecognizer!.delegate = self
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            var isButtonEnabled = false
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.recordButton.isEnabled = isButtonEnabled
            }
        }
        
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            recordButton.isEnabled = true
        } else {
            recordButton.isEnabled = false
        }
    }
    
    @IBAction func recordPressed(_ sender: UIButton) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recordButton.isEnabled = true
            recordButton.setTitle("Start Recording", for: .normal)
        } else {
            startRecording()
            recordButton.setTitle("Stop Recording", for: .normal)
        }
    }
    
    func startRecording() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .default, options: [])
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let inputNode:AVAudioInputNode? = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        /* SHOW THE LIVE RESULTS */
        recognitionRequest.shouldReportPartialResults = true
        var firstSegment = 0;
        var numOfStops = 0;
        recognitionTask = speechRecognizer!.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            //var isFinal = false
            if result != nil {
                //print("new segments!");
                //print("first segment = \(firstSegment)");
                print("Current input::: \(result?.bestTranscription.formattedString)");
                //Check for "new line"
                if((result?.bestTranscription.segments[(result?.bestTranscription.segments.count)! - 1].substring.lowercased().contains("stop"))!){
                    if((result?.bestTranscription.segments[(result?.bestTranscription.segments.count)! - 2].substring.lowercased().contains("stop"))!){
                        self.audioEngine.stop()
                        self.recognitionRequest?.endAudio()
                        self.recordButton.isEnabled = true
                        self.recordButton.setTitle("Start Recording", for: .normal)
                    }else{
                        print(result?.bestTranscription.segments[(result?.bestTranscription.segments.count)! - 1].substring)
                        
                        //Only pasrse the new segments
                        let allSegments: [SFTranscriptionSegment] = (result?.bestTranscription.segments)!;
                        var newSegments = Array(allSegments.suffix(from: firstSegment));
                        
                        //the raw input
                        self.bestTranscriptionOutput.text = result?.bestTranscription.formattedString;
                        
                        //parse the new segments
                        self.textOutput.text = self.parseInput(resultArr: newSegments);
                        
                        //update first segment:
                        firstSegment = (result?.bestTranscription.segments.count)!;
                    }
                    
                }
                
                //isFinal = (result?.isFinal)!
            }
            
            if error != nil {
                self.audioEngine.stop()
                inputNode!.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.recordButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode!.outputFormat(forBus: 0)
        inputNode!.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        textOutput.text = "Say something, I'm listening!"
        
    }
    
    func parseInput(resultArr: [SFTranscriptionSegment]) -> String{
        var resultStr: String = "";
        for seg in resultArr{
            //Need to remove /n characters
           if(seg.substring.contains("stop")){
                resultStr += seg.substring;
           }else{
                resultStr += seg.substring;
                resultStr += " ";
            
                //let newString = seg.substring.replacingOccurrences(of: "stop", with: " ")
                //resultStr += newString;
            }
        }
        
        return SpeechProcessor.processInput(result: resultStr);
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    @IBAction func share(_ sender: Any) {
        let urls = SpeechProcessor.state.saveFilesAndGetNames()
        
        let controller = UIActivityViewController(activityItems: urls, applicationActivities: nil)
        controller.excludedActivityTypes = [.postToTwitter, .assignToContact, .saveToCameraRoll]
        
        self.present(controller, animated: true, completion: nil)
        
    }
    
}

