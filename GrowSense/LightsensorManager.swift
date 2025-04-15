//
//  LightsensorManager.swift
//  GrowSense
//
//  Created by Jason Park on 3/10/25.
//
import AVFoundation
import Combine

class LightSensorManager: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    private let captureSession = AVCaptureSession()
    private var device: AVCaptureDevice?
    
    @Published var brightness: Float = 0.0
    @Published var lightCategory: String = "Unknown"
    
    @Published var normalizedBrightness: Float = 0.0
    private let maxBrightness: Float = 50.0
    
    override init() {
        super.init()
        setupCamera()
    }
    
    private func setupCamera() {
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("No camera available")
            return
        }
        self.device = captureDevice
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            let output = AVCaptureVideoDataOutput()
            output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            captureSession.addOutput(output)
            
            captureSession.startRunning()
        } catch {
            print("Error setting up camera: \(error)")
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let device = device else { return }

        let iso = device.iso
        let exposureDuration = device.exposureDuration.seconds
        let brightnessEstimate = iso * Float(exposureDuration)

        
        DispatchQueue.main.async {
            self.brightness = brightnessEstimate
            self.normalizedBrightness = min(brightnessEstimate / self.maxBrightness, 1.0)
            self.lightCategory = self.categorizeLight(brightnessEstimate)
        }
    }

    private func categorizeLight(_ value: Float) -> String {
        switch value {
        case 0.0..<5:
            return "Full Sunlight 🌞 (Best for succulents, cacti, tomatoes)"
        case 5.0..<30:
            return "Bright Indirect 🌤️ (Great for pothos, orchids, ferns)"
        case 30..<50:
            return "Moderate Light ☁️ (Good for peace lilies, dracaenas)"
        case 50...:
            return "Low Light 🌑 (Okay for snake plants, ZZ plants)"
        default:
            return "Unknown"
        }
    }
}
