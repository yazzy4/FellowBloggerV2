//
//  StorageService.swift
//  FellowBloggerV2
//
//  Created by Yaz Burrell on 3/14/19.
//  Copyright © 2019 Yaz Burrell. All rights reserved.
//

import Foundation
import FirebaseStorage

struct StorageKeys {
    static let ImagesKey = "images"
}

final class StorageService {
    static var storageRef: StorageReference = {
        let ref = Storage.storage().reference()
        return ref
    }()
    
    static public func postImage(imageData: Data, imageName: String, completion: @escaping (Error?, URL?) -> Void) {
        let metadata = StorageMetadata()
        let imageRef = storageRef.child(StorageKeys.ImagesKey + "/\(imageName)")
        metadata.contentType = "image/jpg"
        let uploadTask = imageRef
            .putData(imageData, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("upload task error: \(error)")
                } else if let _ = metadata {
                    
                }
        }
        uploadTask.observe(.failure) { (snapshot) in
            //
        }
        uploadTask.observe(.pause) { (snapshot) in
            //
        }
        uploadTask.observe(.progress) { (snapshot) in
            //
        }
        uploadTask.observe(.resume) { (snapshot) in
            //
        }
        uploadTask.observe(.success) { (snapshot) in
            //
            imageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    completion(error, nil)
                } else if let url = url {
                    completion(nil, url)
                }
            })
        }
    }
}
