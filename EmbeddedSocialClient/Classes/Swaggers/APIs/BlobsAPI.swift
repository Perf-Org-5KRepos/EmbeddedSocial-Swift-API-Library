//
// BlobsAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire


open class BlobsAPI: APIBase {
    /**
     Get blob
     - parameter blobHandle: (path) Blob handle 
     - parameter authorization: (header) Format is: \&quot;Scheme CredentialsList\&quot;. Possible values are:  - Anon AK&#x3D;AppKey  - SocialPlus TK&#x3D;SessionToken  - Facebook AK&#x3D;AppKey|TK&#x3D;AccessToken  - Google AK&#x3D;AppKey|TK&#x3D;AccessToken  - Twitter AK&#x3D;AppKey|RT&#x3D;RequestToken|TK&#x3D;AccessToken  - Microsoft AK&#x3D;AppKey|TK&#x3D;AccessToken  - AADS2S AK&#x3D;AppKey|[UH&#x3D;UserHandle]|TK&#x3D;AADToken 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func blobsGetBlob(blobHandle: String, authorization: String, completion: @escaping ((_ data: URL?, _ error: ErrorResponse?) -> Void)) {
        blobsGetBlobWithRequestBuilder(blobHandle: blobHandle, authorization: authorization).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Get blob
     - GET /v0.7/blobs/{blobHandle}

     - examples: [{output=none}]
     - parameter blobHandle: (path) Blob handle 
     - parameter authorization: (header) Format is: \&quot;Scheme CredentialsList\&quot;. Possible values are:  - Anon AK&#x3D;AppKey  - SocialPlus TK&#x3D;SessionToken  - Facebook AK&#x3D;AppKey|TK&#x3D;AccessToken  - Google AK&#x3D;AppKey|TK&#x3D;AccessToken  - Twitter AK&#x3D;AppKey|RT&#x3D;RequestToken|TK&#x3D;AccessToken  - Microsoft AK&#x3D;AppKey|TK&#x3D;AccessToken  - AADS2S AK&#x3D;AppKey|[UH&#x3D;UserHandle]|TK&#x3D;AADToken 
     - returns: RequestBuilder<URL> 
     */
    open class func blobsGetBlobWithRequestBuilder(blobHandle: String, authorization: String) -> RequestBuilder<URL> {
        var path = "/v0.7/blobs/{blobHandle}"
        path = path.replacingOccurrences(of: "{blobHandle}", with: "\(blobHandle)", options: .literal, range: nil)
        let URLString = EmbeddedSocialClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = NSURLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "Authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<URL>.Type = EmbeddedSocialClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }


    /**
     Upload a blob
     - parameter authorization: (header) Format is: \&quot;Scheme CredentialsList\&quot;. Possible values are:  - Anon AK&#x3D;AppKey  - SocialPlus TK&#x3D;SessionToken  - Facebook AK&#x3D;AppKey|TK&#x3D;AccessToken  - Google AK&#x3D;AppKey|TK&#x3D;AccessToken  - Twitter AK&#x3D;AppKey|RT&#x3D;RequestToken|TK&#x3D;AccessToken  - Microsoft AK&#x3D;AppKey|TK&#x3D;AccessToken  - AADS2S AK&#x3D;AppKey|[UH&#x3D;UserHandle]|TK&#x3D;AADToken
     - parameter blob: (body) MIME encoded contents of the blob
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func blobsPostBlob(authorization: String, blob: Data, completion: @escaping ((_ data: PostBlobResponse?, _ error: ErrorResponse?) -> Void)) {
        
        // construct the URL where the POST will be issued
        let path = "/v0.7/blobs"
        let URLString = EmbeddedSocialClientAPI.basePath + path
        let url = URL(string: URLString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        // construct the body
        urlRequest.httpBody = blob
        
        // construct the headers
        urlRequest.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(authorization, forHTTPHeaderField: "Authorization")
        
        // issue the request
        let dataRequest = Alamofire.request(urlRequest)
        
        // parse the response
        let validatedDataRequest = dataRequest.validate()
        validatedDataRequest.responseJSON(options: .allowFragments) { response in
            // failure
            if response.result.isFailure {
                completion(nil, ErrorResponse.HttpError(statusCode: response.response?.statusCode ?? 500, data: response.data, error: response.result.error!))
                return
            }
            
            // handle HTTP 204 No Content
            if response.response?.statusCode == 204 && response.result.value is NSNull{
                completion(nil, nil)
                return
            }
            
            // parse the result into PostBlobResponse
            if let json: Any = response.result.value {
                let decoded = Decoders.decode(clazz: PostBlobResponse.self, source: json as AnyObject, instance: nil)
                switch decoded {
                case let .success(object): completion(object, nil)
                case let .failure(error): completion(nil, ErrorResponse.DecodeError(response: response.data, decodeError: error))
                }
                return
            }
            
            // unexpected
            completion(nil, ErrorResponse.HttpError(statusCode: 500, data: nil, error: NSError(domain: "localhost", code: 500, userInfo: ["reason": "unreacheable code"])))
        }
    }
}
