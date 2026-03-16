//
//  ApplicationWebViewViewModel.swift
//  Movilidad
//
//  Created by Diego Quimbo on 21/2/22.
//

import Foundation
import UIKit
import RxSwift

final class ApplicationWebViewViewModel {
    let operationInfo: OperationWeb
    
    init(operationInfo: OperationWeb) {
        self.operationInfo = operationInfo
    }
    
    // MARK: - Public properties
    var url: URL {        
        if operationInfo.isExternal {
            var urlString = operationInfo.url
            insertRedirectIfItIsNecessary(urlString: &urlString)
            return URL(string: urlString)!
        }
        
        return URL(string:"\(URLs.baseURL())\(operationInfo.url)")!
    }
    
    var codecAudioRecording: String {
        return interopAction?.codec ?? "aac"
    }
    
    private(set) var updateNotificationCount: Int?
    
    // MARK: - Private properties
    private var videoCount = 0
    private var interopAction: InteropAction?
    private var currentFileToUpload: NSData?
    private var urlDownloadedFile: String?
    
    private let fileService = ConnectionManager_Files()
    
    // Dispose bag
    private let disposeBag = DisposeBag()
    
    // MARK: - Public Functions
    func handleWebInteropAction(url: URL) -> WebInteropAction? {
        let urlPath = url.absoluteString
        
        if urlPath.contains("fileupload") {
            guard let source = url.valueOf("source"),
                  let controlId = url.valueOf("controlId"),
                  let callback = url.valueOf("callback")else {
                return nil
            }
            
            interopAction = InteropAction(requestControlId: controlId,
                                          callbackFunction: callback,
                                          compressionQuality: Float(url.valueOf("compressionQuality") ?? "1.0"),
                                          codec: nil,
                                          maxDuration: nil)
            
            switch source {
            case WebInteropAction.camera.rawValue:
                return .camera
            case WebInteropAction.galeryMultiple.rawValue:
                return .galeryMultiple
            case WebInteropAction.videocamera.rawValue:
                return .videocamera
            case WebInteropAction.videogalery.rawValue:
                return .videogalery
            case WebInteropAction.videogalerychunck.rawValue:
                interopAction?.fileName = url.valueOf("name")
                return .videogalerychunck
            case WebInteropAction.videoremovetemp.rawValue:
                return .videoremovetemp
            default:
                return nil
            }
        } else if urlPath.contains(WebInteropAction.recordaudio.rawValue) {
            guard let controlId = url.valueOf("controlId"),
                  let callback = url.valueOf("callback"),
                  let codec = url.valueOf("codec"),
                  let maxDuration = url.valueOf("maxduration") else {
                return nil
            }
            
            interopAction = InteropAction(requestControlId: controlId,
                                          callbackFunction: callback,
                                          compressionQuality: nil,
                                          codec: codec,
                                          maxDuration: maxDuration)
            
            return .recordaudio
        } else if urlPath.contains(WebInteropAction.barcode.rawValue) {
            guard let controlId = url.valueOf("controlId"),
                  let callback = url.valueOf("callback") else {
                return nil
            }
            
            interopAction = InteropAction(requestControlId: controlId,
                                          callbackFunction: callback,
                                          compressionQuality: nil,
                                          codec: nil,
                                          maxDuration: nil)
            
            return .barcode
        } else if urlPath.contains(WebInteropAction.playVideo.rawValue) {
            urlDownloadedFile = url.valueOf("url")
            return .playVideo
        } else if urlPath.contains(WebInteropAction.playAudio.rawValue) {
            urlDownloadedFile = url.valueOf("url")
            return .playAudio
        } else if urlPath.contains(WebInteropAction.notificationRegister.rawValue) {
            return .notificationRegister
        } else if urlPath.contains(WebInteropAction.updateNotificationCount.rawValue) {
            guard let countStr = url.valueOf("count") else {
                return nil
            }
            
            updateNotificationCount = Int(countStr)
            return .updateNotificationCount
        }
        
        return nil
    }
    
    func checkIfIsOpenNewWebView(url: URL) -> Bool {
        let urlString = url.absoluteString
        
        return urlString.hasPrefix(WebInteropAction.open.rawValue)
    }
    
    func checkIfIsOpenMultipleOperations(url: URL) -> Bool {
        let urlString = url.absoluteString
        
        return urlString.contains(WebInteropAction.multipleOperations.rawValue)
    }
    
    func getMultipleOperationsURLs(url: URL) -> [String]? {
        let urlString = url.absoluteString
        
        guard urlString.contains(WebInteropAction.multipleOperations.rawValue),
              var operationsStr = url.valueOf(WebInteropAction.multipleOperations.rawValue) else {
            return nil
        }
        
        // It's necessary to remove characters []
        operationsStr = String(operationsStr.dropFirst())
        operationsStr = String(operationsStr.dropLast())
        
        let operations = operationsStr.components(separatedBy: ",")
        
        let baseUrl = getBaseUrl(url: url)
        
        var multipleOperationsUrls: [String] = []
        
        for operationId in operations {
            let trimmingOrderId = operationId.trimmingCharacters(in: .whitespacesAndNewlines)
            let operationUrl = "\(baseUrl)?Orden=\(trimmingOrderId)"
            
            multipleOperationsUrls.append(operationUrl)
        }
        
        print("Multiple operations are: \(multipleOperationsUrls)")
        
        return multipleOperationsUrls
    }
    
    func buildExternalUrl(url: URL) -> String? {
        var urlString = url.absoluteString
        
        let rangePrefix = if urlString.hasPrefix("open::") { "open::" } else {"http"}
        
        guard let range = urlString.range(of: rangePrefix) else {
           return urlString
        }
        
        if urlString.hasPrefix("open::") {
            urlString.removeSubrange(range)
        } else {
            // Opening a Notification message
            urlString.removeSubrange(urlString.startIndex..<range.lowerBound)
        }
        
        insertRedirectIfItIsNecessary(urlString: &urlString)
        
        return urlString
    }
    
    func processImage(image: UIImage) -> String? {
        guard let interop = interopAction else {
            return nil
        }
        
        let imageBase64 = convertImageToBase64String(img: image, compressionQuality: CGFloat(interop.compressionQuality ?? 1.0))
        
        return "\(interop.callbackFunction)('\(interop.requestControlId)', '\(imageBase64)')"
    }
    
    func processVideo(info: [UIImagePickerController.InfoKey : Any]) -> String? {
        guard let interop = interopAction,
              let videoPath =  info[UIImagePickerController.InfoKey.mediaURL] as? URL  else { return nil }
        
        videoCount += 1
        
        let videoData = NSData(contentsOf: videoPath)
        let videoSize = videoData?.length ?? 0
        let name = "video\(videoCount).\(videoPath.pathExtension)"
        
        currentFileToUpload = videoData
        
        return "\(interop.callbackFunction)('\(interop.requestControlId)', '\(name)', \(videoSize))"
    }
    
    func processVideoFromLibrary(source: URL) -> String? {
        guard let interop = interopAction else { return nil }
        
        videoCount += 1
        
        let videoData = NSData(contentsOf: source)
        let videoSize = videoData?.length ?? 0
        let name = "video\(videoCount).\(source.pathExtension)"
        
        currentFileToUpload = videoData
        
        return "\(interop.callbackFunction)('\(interop.requestControlId)', '\(name)', \(videoSize))"
    }
    
    func processRecordAudio(audioPath: URL) -> String? {
        guard let data = NSData(contentsOf: audioPath),
              let interop = interopAction else { return nil }
        
        let base64 = data.base64EncodedString()
        
        return "\(interop.callbackFunction)('\(interop.requestControlId)', '\(base64)')"
    }
    
    func processBarcode(code: String) -> String? {
        guard let interop = interopAction else { return nil }
        
        return "\(interop.callbackFunction)('\(interop.requestControlId)', '\(code)')"
    }
    
    func processVideoGaleryChunck() -> String? {
        guard let interop = interopAction,
              let base64File = currentFileToUpload?.base64EncodedString() else { return nil }
        
        return "\(interop.callbackFunction)('\(interop.requestControlId)', '\(base64File)')"
    }
    
    func downloadVideoFile() -> Single<String?> {
        return Single.create { [weak self] single in
            guard let self = self,
                  let fileURL = self.urlDownloadedFile else { return Disposables.create { } }
            
            fileService.downloadVideoFile(url: fileURL)
                .subscribe { videoURL in
                    guard let videoPath = videoURL else { return }
                    
                    single(.success(videoPath))
                    
                } onFailure: { _ in
                    single(.failure(ApiError.internalServerError))
                }.disposed(by: disposeBag)
            
            return Disposables.create { }
        }
    }
    
    func downloadAudioFile() -> Single<String?> {
        return Single.create { [weak self] single in
            guard let self = self,
                  let fileURL = self.urlDownloadedFile else { return Disposables.create { } }
            
            fileService.downloadVideoFile(url: fileURL)
                .subscribe { videoURL in
                    guard let videoPath = videoURL else { return }
                    
                    single(.success(videoPath))
                    
                } onFailure: { _ in
                    single(.failure(ApiError.internalServerError))
                }.disposed(by: disposeBag)
            
            return Disposables.create { }
        }
    }
    
    func processRegisterNotification(url: URL) -> String? {
        if let token = SettingsHandler.shared.pushNotificationsToken, let callback = url.valueOf("callback") {
            return "\(callback)('\(token)', '\(SettingsHandler.shared.deviceName)', '\("IOS")', '\("1")')"
        } else {
            guard let errorCallback = url.valueOf("errorcallback") else { return nil }
            
            return "\(errorCallback)('\(L10n.Register.Notification.Apns.error)'"
        }
    }
}

private extension ApplicationWebViewViewModel {
    func convertImageToBase64String(img: UIImage, compressionQuality: CGFloat) -> String {
        return img.jpegData(compressionQuality: compressionQuality)?.base64EncodedString() ?? ""
    }
}

// MARK: - Private functions
private extension ApplicationWebViewViewModel {
    func insertRedirectIfItIsNecessary(urlString: inout String) {
        if SessionManager.shared.profile?.transactionRedirectEnable ?? false &&
            SettingsHandler.shared.transactionRedirectSelected != "" {
            let redirectTransaction = SettingsHandler.shared.transactionRedirectSelected
            
            let redirectUrl = if urlString.suffix(1) == "?" {"redirect=\(redirectTransaction)"} else {"?redirect=\(redirectTransaction)"}
            
            urlString = "\(urlString)\((redirectUrl))"
        }
    }
    
    func getBaseUrl(url: URL) -> String {
        let separateBaseUrl = url.removingQueries.absoluteString.components(separatedBy: "https")
        
        if separateBaseUrl.count > 1 {
            return "https\(separateBaseUrl[1])"
        }
        
        return url.removingQueries.absoluteString
    }
}
