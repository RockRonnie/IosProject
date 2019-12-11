//
//  UserImageFetch.swift
//  StrawberryPie
//
//  Created by iosdev on 01/12/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//
//  Class for the Post request that uploads image to server and returns response JSON which can be used later on.

import Foundation
import Alamofire
import SwiftyJSON

public class UserImagePost {
    
    let url = "http://foxer153.asuscomm.com:3000/upload" //API URL

    func requestWith(endUrl: String, imageData: Data?, parameters: [String : Any], onCompletion: ((JSON?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = imageData{
                multipartFormData.append(data, withName: "photo", fileName: "image.png", mimeType: "image/png")
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response)
                    if let err = response.error{
                        onError?(err)
                        return
                    } //on completion it returns a Json that is still optinal and is handled
                     //in profile viewcontroller
                    onCompletion?(JSON(response.result.value!))
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                onError?(error)
            }
        }
    }
    
    func getPic(image: String, onCompletion: ((UIImage?) -> Void)? = nil) {
        var resultImage: UIImage?
        print("haetaan kuvaa")
        Alamofire.request(image).responseData(completionHandler: { response in
            if let imageData = response.data
            {
                print ("Kuva löytyi")
                resultImage = UIImage(data: imageData)
                print(response)
                onCompletion?(resultImage)
            }
        })
}
}
