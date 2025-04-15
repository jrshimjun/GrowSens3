//
//  CameraViewModel.swift
//  GrowSense
//
//  Created by Jun Shim on 4/14/25.
//


import Foundation
import AVFoundation
import UIKit

class CameraViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()

    @Published var capturedPlantName: String?
    @Published var confidence: Double?
    @Published var isLoading = false
    @Published var errorMessage: String?

    @Published var watering: String?
    @Published var sunlight: String?
    @Published var soilHumidity: String?

    override init() {
        super.init()
        configureSession()
    }

    private func configureSession() {
        session.beginConfiguration()
        session.sessionPreset = .photo

        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input),
              session.canAddOutput(photoOutput) else {
            print("Failed to set up session")
            return
        }

        session.addInput(input)
        session.addOutput(photoOutput)
        session.commitConfiguration()
    }

    func startSession() {
        DispatchQueue.main.async {
            if !self.session.isRunning {
                self.session.startRunning()
            }
        }
    }

    func stopSession() {
        DispatchQueue.main.async {
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }

    func captureImage() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }

    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else {
            self.errorMessage = "Failed to process image"
            return
        }

        identifyPlant(from: image)
    }

    private func identifyPlant(from image: UIImage) {
        let resizedImage = resize(image: image, targetSize: CGSize(width: 1024, height: 1024))

        guard let jpegData = resizedImage.jpegData(compressionQuality: 0.8) else {
            self.errorMessage = "Could not convert image to JPEG"
            return
        }

        let base64 = jpegData.base64EncodedString()

        guard let apiKey = loadAPIKey() else {
            self.errorMessage = "Missing API key in Secrets.plist"
            return
        }

        var request = URLRequest(url: URL(string: "https://plant.id/api/v2/identify")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "Api-Key")

        let body: [String: Any] = [
            "images": [base64],
            "organs": ["leaf"],
            "similar_images": false
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }

            if let error = error {
                self.errorMessage = "Network error: \(error.localizedDescription)"
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code:", httpResponse.statusCode)
            }

            guard let data = data else {
                self.errorMessage = "No data received"
                return
            }

            if let raw = String(data: data, encoding: .utf8) {
                print("Raw response:", raw)
            } else {
                print("Response not UTF-8 decodable")
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print("Parsed JSON:", json)

                    if let suggestion = (json["suggestions"] as? [[String: Any]])?.first,
                       let name = suggestion["plant_name"] as? String,
                       let confidence = suggestion["probability"] as? Double {

                        let details = suggestion["plant_details"] as? [String: Any]

                        let watering = details?["watering"] as? String ?? "Unknown"
                        let sunlight = details?["sunlight"] as? String ?? "Unknown"
                        let soilHumidity = details?["soil_humidity"] as? String ?? "Unknown"

                        DispatchQueue.main.async {
                            self.capturedPlantName = name
                            self.confidence = confidence
                            self.watering = watering
                            self.sunlight = sunlight
                            self.soilHumidity = soilHumidity
                        }
                    } else {
                        print("Suggestion format missing or unexpected")
                        DispatchQueue.main.async {
                            self.errorMessage = "Could not parse plant name"
                        }
                    }
                }
            } catch {
                print("JSON decode error:", error.localizedDescription)
                self.errorMessage = "Error parsing server response"
            }
        }.resume()
    }

    private func resize(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let scaleFactor = min(widthRatio, heightRatio)

        let newSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
        let renderer = UIGraphicsImageRenderer(size: newSize)

        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }

    private func loadAPIKey() -> String? {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path),
           let key = dict["PlantIDAPIKey"] as? String {
            return key
        }
        return nil
    }
}
