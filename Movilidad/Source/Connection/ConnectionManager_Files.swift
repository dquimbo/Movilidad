//
//  ConnectionManager_Files.swift
//  Movilidad
//
//  Created by Diego Quimbo on 1/8/23.
//

import Alamofire
import RxSwift
import Foundation

class ConnectionManager_Files: ConnectionManager {
    func downloadVideoFile(url: String) -> Single<String?> {
        return Single.create { single in
            let destination: DownloadRequest.Destination = { _, _ in
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileURL = documentsURL.appendingPathComponent("video.mov")

                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            let request = AF.download(url, to: destination).response { response in
                debugPrint(response)

                if response.error == nil, let imagePath = response.fileURL?.path {
                    single(.success(imagePath))
                } else {
                    single(.failure(ApiError.internalServerError))
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
